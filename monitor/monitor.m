#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>
#import <NSDeckLink/NSDeckLink.h>
#include <signal.h>

// OSStatus
// #import <CarbonCore/MacErrors.h>

/*
gcc test.m -F .. -I../SDK/include  -framework Foundation -framework AudioToolbox -framework NSDeckLink
install_name_tool -add_rpath .. a.out
*/


// /usr/local/Cellar/llvm/19.1.4/bin/clang++ -g -fsanitize=address  -I ../../include -framework foundation -framework AudioToolbox -F /Library/Frameworks -framework DeckLinkAPI  main.m ../../NSDeckLink/NSDeckLink/*.o


/* 
Once DeckLinkAPI (and its headers) and NSDeckLink have been copied to /Library/Frameworks
/usr/local/Cellar/llvm/19.1.4/bin/clang++ -O2 -framework foundation -framework AudioToolbox -F /Library/Frameworks -framework DeckLinkAPI -framework NSDeckLink main.m
*/

NSCondition* hw;

#define kNumberOfPlaybackBuffers 3
#define kOutputBufferSize 7680

typedef struct wavheader {
	char riff[4]; // 4
	int size;     // 4
	char wave[4]; // 4
	char fmt[4];  // 4
	int fmt_size; // 4
	short format; // 2
	short channels; // 2
	int sample_rate; // 4
	int byte_rate; // 4
	short block_align; // 2
	short bits_per_sample; // 2
	char data[4]; // 4
	int data_size; // 4
} wavheader;

@interface GetAudio : NSObject <NSIDeckLinkInputCallback>
{
	int filedescriptor;
	dispatch_queue_t writeQueue;
	dispatch_queue_t monitorQueue;

	NSLock* bufferLock;
	NSCondition* bufferSync;
	BOOL playing;

	NSData* bufferShare; // as long as the system is synchronized we don't need to queue.

	// BMDAudioSampleType sampletype;
	// uint32_t channelcount;
	NSUInteger sampleSize;
	NSUInteger samplesPerFrame;
	NSUInteger bufferSize;

	AudioQueueRef audioQueue;
	AudioQueueBufferRef	outBuffer[kNumberOfPlaybackBuffers];

	NSMutableArray *BMDbufferList;

	AudioStreamBasicDescription audioFormat;
	AudioStreamPacketDescription packetDescription;

	uint32_t bytesWritten;
}

- (instancetype)init;
- (HRESULT)videoInputFrameArrived:(NSIDeckLinkVideoInputFrame*)videoFrame audio:(NSIDeckLinkAudioInputPacket *)audioPacket;
- (HRESULT)videoInputFormatChangedEvent:(BMDVideoInputFormatChangedEvents)notificationEvents displayMode:(NSIDeckLinkDisplayMode*)newDisplayMode signalFlags:(BMDDetectedVideoInputFormatFlags)detectedSignalFlags;
- (BOOL)setupMonitoringSampleRate:(double)sampleRate bits:(NSUInteger)bitsPerSample samplesPerFrame:(NSUInteger)samplesPerFrame;
- (void)setAudioSampleType:(BMDAudioSampleType)sampleType channelCount:(NSUInteger)channelCount samplesPerFrame:(NSUInteger)spf;
- (BOOL)setFileName:(NSString*)fileName sampleRate:(unsigned int)sampleRate bits:(unsigned int)bitsPerSample;
- (BOOL)startOutput
- (BOOL)stopMonitoring;
- (void)closeFile;

@end 

/*
typedef struct {
    @defs(GetAudio);
} GetAudioRef;
*/

@implementation GetAudio

- (HRESULT)videoInputFrameArrived:(NSIDeckLinkVideoInputFrame*)videoFrame audio:(NSIDeckLinkAudioInputPacket *)audioPacket
{
	// NSLog(@"videoInputFrameArrived: V:%@ %ldx%ld A:%@ %ld",videoFrame,[videoFrame width],[videoFrame height],audioPacket,[audioPacket sampleFrameCount]);

	[self->bufferLock lock];

	//NSLog(@"bufferShare: %x", bufferShare);

	if (audioPacket)
	{
	// && sampleSize>0) {

		NSData* d = [audioPacket bytesWithSampleSize:sampleSize];

		if (filedescriptor>2)
		{
			[d retain];
			dispatch_async(writeQueue, ^{
				//NSLog(@"write with %d",filedescriptor);
				//NSLog(@"bufferShare retain");
				write(self->filedescriptor, [d bytes], [d length] );
				bytesWritten += [d length];
				[d release];
				//	NSLog(@"write");

				//[audioPacket autorelease];
				//NSLog(@"bufferShare autorelease");

			});
		}

		if (bufferSync)
		{
			NSLog(@"sync signal");
			[bufferSync lock];
			[bufferSync signal];
			[bufferSync unlock];
		}

		if (BMDbufferList)
		{
			//NSLog(@"Buffer: %lu",[BMDbufferList count]);
			
			[d retain];

			dispatch_async(monitorQueue, ^{
				[self->BMDbufferList addObject:d];
				//NSLog(@"Buffer: %lu",[BMDbufferList count]);
			});
			
		}

		[self->bufferLock unlock];

		//NSLog(@"S_OK");
		return S_OK;
	}
	//NSLog(@"E_FAIL");

	return E_FAIL;
}

- (HRESULT)videoInputFormatChangedEvent:(BMDVideoInputFormatChangedEvents)notificationEvents displayMode:(NSIDeckLinkDisplayMode*)newDisplayMode signalFlags:(BMDDetectedVideoInputFormatFlags)detectedSignalFlags
{
	NSLog(@"videoInputFormatChangedEvent");
	return S_OK;
}

- (void)setAudioSampleType:(BMDAudioSampleType)sampleType channelCount:(NSUInteger)channelCount samplesPerFrame:(NSUInteger)spf
{
	//NSUInteger samplesize;
	samplesPerFrame = spf;
	switch (sampleType)
	{
		case bmdAudioSampleType16bitInteger:
			sampleSize = channelCount * 2;
			break;
		case bmdAudioSampleType32bitInteger:
			sampleSize = channelCount * 4;
			break;
		default:
			sampleSize=0;
			break;
	}

	bufferSize = sampleSize * samplesPerFrame;
}

void outputCallbackQueue (GetAudio* ga, AudioQueueRef aqr, AudioQueueBufferRef aqbr)
{
	//NSLog(@"bing when there's stuff");
	[ga->bufferLock lock];
	unsigned int bufferSize = ga->bufferSize;
	if (ga->BMDbufferList)
	{
		if([ga->BMDbufferList count] > 0)
		{
			//NSLog(@"BUFFER Count: %lu",[ga->BMDbufferList count]);

			NSData* d = [ga->BMDbufferList objectAtIndex:0];
			//NSLog(@"Data: %@",d);

			[ga->BMDbufferList removeObjectAtIndex:0];
			//NSLog(@"dest buffer ref: %x",aqbr);

			memcpy(aqbr->mAudioData, [d bytes], bufferSize);
			[d release];

			//NSLog(@"buffer copy");

		} else {
			NSLog(@"Monitoring BUFFER UNDERRUN");
			memset(aqbr->mAudioData, 0, bufferSize);
		}
		aqbr->mAudioDataByteSize = bufferSize;
	
	//NSLog(@"enqueue buffer");

		OSStatus rr = AudioQueueEnqueueBuffer(aqr, aqbr, 0, NULL);
		if ( rr != S_OK)
			NSLog(@"Enqueue Buffer failure: %d",rr);
	}
	[ga->bufferLock unlock];

}

void outputCallback (GetAudio* ga, AudioQueueRef aqr, AudioQueueBufferRef aqbr)
{
	//NSLog(@">>> outputCallback");

	[ga->bufferSync lock];
	[ga->bufferSync wait];
	[ga->bufferSync unlock];

	memcpy(aqbr->mAudioData, (ga->bufferShare).bytes, (ga->bufferShare).length);

	aqbr->mAudioDataByteSize = 7680;
	OSStatus rr = AudioQueueEnqueueBuffer(aqr, aqbr, 0, NULL);
	NSLog(@"enqueue status: %d",rr);
}

- (BOOL)startOutput
{
	NSLog(@"startOutput");
	OSStatus res=AudioQueueStart(audioQueue,NULL);
	NSLog(@"startOutput done: %d",res);
	return res==0;
}

- (BOOL)stopMonitoring
{
	if (BMDbufferList)
	{
		OSStatus r;
		r = AudioQueueStop(audioQueue,YES);
		if (r!=0)
		{
			NSLog(@"Error stopping audio queue: %d",r);
			return NO;
		}

		r = AudioQueueDispose(audioQueue, YES);
		if (r!=0)
		{
			NSLog(@"Error disposing audio queue: %d",r);
			return NO;
		}
	}
	return YES;
}

// set up audio output
- (BOOL)setupMonitoringSampleRate:(double)sampleRate bits:(NSUInteger)bitsPerSample samplesPerFrame:(NSUInteger)spf
{

	NSLog(@"Setup Monitoring sps:%f bits:%lu spf:%lu",sampleRate,bitsPerSample,spf);

	monitorQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	playing = NO;

	bufferSync = nil;
	//bufferSync = [[NSCondition alloc] init];

	BMDbufferList = [[NSMutableArray alloc] init];

	bufferShare = nil;

	// some these values have been determined by looking at the Black Magic incoming data
	// AudioStreamBasicDescription audioFormat;

	audioFormat.mSampleRate = sampleRate;
	audioFormat.mFormatID = kAudioFormatLinearPCM;
	audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket = 1; // but I really wanted 1920
	audioFormat.mChannelsPerFrame = 2;
	audioFormat.mBitsPerChannel = bitsPerSample;
	audioFormat.mBytesPerPacket = audioFormat.mFramesPerPacket * (audioFormat.mBitsPerChannel/8) * audioFormat.mChannelsPerFrame;
	audioFormat.mBytesPerFrame = (audioFormat.mBitsPerChannel/8) * audioFormat.mChannelsPerFrame;
	audioFormat.mReserved = 0;

	//packetDescription.mStartOffset =0;
	//packetDescription.mVariableFramesInPacket = 0;
	unsigned int bSize = spf * audioFormat.mChannelsPerFrame * (bitsPerSample/8);

	NSLog(@"Buffer Size: %u",bSize);

	//packetDescription.mDataByteSize = bSize;

/*
 OSStatus AudioQueueNewOutput(
	const AudioStreamBasicDescription *inFormat, 
 	AudioQueueOutputCallback inCallbackProc, 
	void *inUserData, 
	CFRunLoopRef inCallbackRunLoop, 
	CFStringRef inCallbackRunLoopMode, 
	UInt32 inFlags, 
	AudioQueueRef  _Nullable *outAQ);

OSStatus AudioQueueNewOutputWithDispatchQueue(
	AudioQueueRef  _Nullable *outAQ, 
	const AudioStreamBasicDescription *inFormat, 
	UInt32 inFlags, 
	dispatch_queue_t inCallbackDispatchQueue, 
	AudioQueueOutputCallbackBlock inCallbackBlock);
*/

	OSStatus res = AudioQueueNewOutputWithDispatchQueue (
		&audioQueue, 
		&audioFormat, 
		0, 
		monitorQueue, 
		^(AudioQueueRef aqr, AudioQueueBufferRef aqbr) { outputCallbackQueue (self, aqr, aqbr); }
	);

	if (res!=0)
	{
		NSLog(@"ERROR osstatus %d",res);
	} else{
		for (int i=0; i < kNumberOfPlaybackBuffers; i++)
		{
			OSStatus res= AudioQueueAllocateBuffer(audioQueue, bSize, &outBuffer[i]);
			NSLog(@"allocate buffer osstatus %d",res);

			NSLog(@"buffer Bytes Capacity: %d",outBuffer[i]->mAudioDataBytesCapacity);
			NSLog(@"buffer Byte Size: %d",outBuffer[i]->mAudioDataByteSize);
			NSLog(@"buffer description Count: %d",outBuffer[i]->mPacketDescriptionCount);
			NSLog(@"buffer Description capacity: %d",outBuffer[i]->mPacketDescriptionCapacity);

			//outputCallback(self,audioQueue,outBuffer[i]);
			memset(outBuffer[i]->mAudioData, 0, bSize);
			outBuffer[i]->mAudioDataByteSize = bSize;
			OSStatus rr= AudioQueueEnqueueBuffer(audioQueue, outBuffer[i], 0, NULL);
			NSLog(@"initial enquque status: %d",rr);
			//AudioQueueEnqueueBuffer(audioQueue, audioBuffers[i], 0, NULL);
		}
	}

	NSLog(@"rate: %f",audioFormat.mSampleRate);
	NSLog(@"Format ID: %u flags: %u",audioFormat.mFormatID,audioFormat.mFormatFlags);
	NSLog(@"bytes: %u frames: %u per packet",audioFormat.mBytesPerFrame,audioFormat.mFramesPerPacket);
	NSLog(@"bytes: %u channels: %u per frame",audioFormat.mBytesPerFrame,audioFormat.mChannelsPerFrame);
	NSLog(@"bits per channel: %u",audioFormat.mBitsPerChannel);
/*
    Float64             mSampleRate;
    AudioFormatID       mFormatID;
    AudioFormatFlags    mFormatFlags;
    UInt32              mBytesPerPacket;
    UInt32              mFramesPerPacket;
    UInt32              mBytesPerFrame;
    UInt32              mChannelsPerFrame;
    UInt32              mBitsPerChannel;
	*/

	//AudioQueueAllocateBuffer(audioQueue, 7680, &outBuffer);
	//packetDescription.mStartOffset=0;
	//packetDescription.mVariableFramesInPacket=0;
	//packetDescription.mDataByteSize = kOutputBufferSize;

	return res == 0;

}

- (void)closeFile
{
	if (filedescriptor>2)
	{
		// silly wave header requiring data not known at start time.
		uint32_t totalBytes = bytesWritten + 36;
		lseek(filedescriptor,4,SEEK_SET);
		write(filedescriptor,&totalBytes,4);
		lseek(filedescriptor,40,SEEK_SET);
		write(filedescriptor,&bytesWritten,4);

		close(filedescriptor);
	}
}

- (BOOL)setFileName:(NSString*)fileName sampleRate:(unsigned int)sampleRate bits:(unsigned int)bitsPerSample
{
	//writeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	writeQueue = dispatch_queue_create("net.silicontrip.NSDeckLink.monitor", DISPATCH_QUEUE_SERIAL);

	filedescriptor = open([fileName UTF8String], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (filedescriptor < 0) {
		NSLog(@"open %@ failed",fileName);
		return NO;
	}

	unsigned int channels = 2;
	unsigned int bytesPerSecond = channels * sampleRate * (bitsPerSample/8); 
	unsigned int bytesPerSample = channels * bitsPerSample / 8;

// unknown length wave header
// 48kHz, 16bit LE, stereo
		wavheader head = {
			'R','I','F','F',
			0xFFFFFFFF,
			'W','A','V','E',
			'f','m','t',' ',
			16,  // format header size
			1, // format type
			channels,
			sampleRate,
			bytesPerSecond,
			bytesPerSample,
			bitsPerSample,
			'd','a','t','a',
			0xFFFFFFFF
		};
		if (write(filedescriptor, &head, sizeof(head)) < 0) {
			NSLog(@"write header failed");
			return NO;
		}

	return YES;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		//queue= dispatch_get_main_queue();
		sampleSize = 0;
		bytesWritten = 0;
	}
	return self;
} 

void logDecklinkAttributes(NSIDeckLinkProfileAttributes* attr)
{
	NSLog(@"BMDDeckLinkSupportsInternalKeying: %@",[attr flagForAttributeID:BMDDeckLinkSupportsInternalKeying]);
	NSLog(@"BMDDeckLinkSupportsExternalKeying: %@",[attr flagForAttributeID:BMDDeckLinkSupportsExternalKeying]);
	NSLog(@"BMDDeckLinkSerialPortDeviceName: %@",[attr stringForAttributeID:BMDDeckLinkSerialPortDeviceName]);
	NSLog(@"BMDDeckLinkMaximumAudioChannels: %@",[attr intForAttributeID:BMDDeckLinkMaximumAudioChannels]);
	NSLog(@"BMDDeckLinkMaximumAnalogAudioInputChannels: %@",[attr intForAttributeID:BMDDeckLinkMaximumAnalogAudioInputChannels]);
	NSLog(@"BMDDeckLinkMaximumAnalogAudioOutputChannels: %@",[attr intForAttributeID:BMDDeckLinkMaximumAnalogAudioOutputChannels]);
	NSLog(@"BMDDeckLinkSupportsInputFormatDetection: %@",[attr flagForAttributeID:BMDDeckLinkSupportsInputFormatDetection]);
	NSLog(@"BMDDeckLinkHasReferenceInput: %@",[attr flagForAttributeID:BMDDeckLinkHasReferenceInput]);
	NSLog(@"BMDDeckLinkHasSerialPort: %@",[attr flagForAttributeID:BMDDeckLinkHasSerialPort]);
	NSLog(@"BMDDeckLinkNumberOfSubDevices: %@",[attr intForAttributeID:BMDDeckLinkNumberOfSubDevices]);
	NSLog(@"BMDDeckLinkSubDeviceIndex: %@",[attr intForAttributeID:BMDDeckLinkSubDeviceIndex]);
	NSLog(@"BMDDeckLinkVideoOutputConnections: %@",[attr intForAttributeID:BMDDeckLinkVideoOutputConnections]);
	NSLog(@"BMDDeckLinkAudioOutputConnections: %@",[attr intForAttributeID:BMDDeckLinkAudioOutputConnections]);
	NSLog(@"BMDDeckLinkVideoInputConnections: %@",[attr intForAttributeID:BMDDeckLinkVideoInputConnections]);
	NSLog(@"BMDDeckLinkAudioInputConnections: %@",[attr intForAttributeID:BMDDeckLinkAudioInputConnections]);
	NSLog(@"BMDDeckLinkHasAnalogVideoOutputGain: %@",[attr flagForAttributeID:BMDDeckLinkHasAnalogVideoOutputGain]);
	NSLog(@"BMDDeckLinkCanOnlyAdjustOverallVideoOutputGain: %@",[attr flagForAttributeID:BMDDeckLinkCanOnlyAdjustOverallVideoOutputGain]);
	NSLog(@"BMDDeckLinkHasVideoInputAntiAliasingFilter: %@",[attr flagForAttributeID:BMDDeckLinkHasVideoInputAntiAliasingFilter]);
	NSLog(@"BMDDeckLinkHasBypass: %@",[attr flagForAttributeID:BMDDeckLinkHasBypass]);
	NSLog(@"BMDDeckLinkVideoInputGainMinimum: %@",[attr floatForAttributeID:BMDDeckLinkVideoInputGainMinimum]);
	NSLog(@"BMDDeckLinkVideoInputGainMaximum: %@",[attr floatForAttributeID:BMDDeckLinkVideoInputGainMaximum]);
	NSLog(@"BMDDeckLinkVideoOutputGainMinimum: %@",[attr floatForAttributeID:BMDDeckLinkVideoOutputGainMinimum]);
	NSLog(@"BMDDeckLinkVideoOutputGainMaximum: %@",[attr floatForAttributeID:BMDDeckLinkVideoOutputGainMaximum]);
	NSLog(@"BMDDeckLinkVideoIOSupport: %@",[attr intForAttributeID:BMDDeckLinkVideoIOSupport]);
	NSLog(@"BMDDeckLinkSupportsClockTimingAdjustment: %@",[attr flagForAttributeID:BMDDeckLinkSupportsClockTimingAdjustment]);
	NSLog(@"BMDDeckLinkPersistentID: %@",[attr intForAttributeID:BMDDeckLinkPersistentID]);
	NSLog(@"BMDDeckLinkDeviceGroupID: %@",[attr intForAttributeID:BMDDeckLinkDeviceGroupID]);
	NSLog(@"BMDDeckLinkTopologicalID: %@",[attr intForAttributeID:BMDDeckLinkTopologicalID]);
	NSLog(@"BMDDeckLinkSupportsFullFrameReferenceInputTimingOffset: %@",[attr flagForAttributeID:BMDDeckLinkSupportsFullFrameReferenceInputTimingOffset]);
	NSLog(@"BMDDeckLinkSupportsSMPTELevelAOutput: %@",[attr flagForAttributeID:BMDDeckLinkSupportsSMPTELevelAOutput]);
	NSLog(@"BMDDeckLinkSupportsDualLinkSDI: %@",[attr flagForAttributeID:BMDDeckLinkSupportsDualLinkSDI]);
	NSLog(@"BMDDeckLinkSupportsQuadLinkSDI: %@",[attr flagForAttributeID:BMDDeckLinkSupportsQuadLinkSDI]);
	NSLog(@"BMDDeckLinkSupportsIdleOutput: %@",[attr flagForAttributeID:BMDDeckLinkSupportsIdleOutput]);
	NSLog(@"BMDDeckLinkDeckControlConnections: %@",[attr intForAttributeID:BMDDeckLinkDeckControlConnections]);
	NSLog(@"BMDDeckLinkMicrophoneInputGainMinimum: %@",[attr floatForAttributeID:BMDDeckLinkMicrophoneInputGainMinimum]);
	NSLog(@"BMDDeckLinkMicrophoneInputGainMaximum: %@",[attr floatForAttributeID:BMDDeckLinkMicrophoneInputGainMaximum]);
	NSLog(@"BMDDeckLinkDeviceInterface: %@",[attr intForAttributeID:BMDDeckLinkDeviceInterface]);
	NSLog(@"BMDDeckLinkHasLTCTimecodeInput: %@",[attr flagForAttributeID:BMDDeckLinkHasLTCTimecodeInput]);
	NSLog(@"BMDDeckLinkVendorName: %@",[attr stringForAttributeID:BMDDeckLinkVendorName]);
	NSLog(@"BMDDeckLinkDisplayName: %@",[attr stringForAttributeID:BMDDeckLinkDisplayName]);
	NSLog(@"BMDDeckLinkModelName: %@",[attr stringForAttributeID:BMDDeckLinkModelName]);
	NSLog(@"BMDDeckLinkSupportsHDRMetadata: %@",[attr flagForAttributeID:BMDDeckLinkSupportsHDRMetadata]);
	NSLog(@"BMDDeckLinkAudioInputRCAChannelCount: %@",[attr intForAttributeID:BMDDeckLinkAudioInputRCAChannelCount]);
	NSLog(@"BMDDeckLinkAudioInputXLRChannelCount: %@",[attr intForAttributeID:BMDDeckLinkAudioInputXLRChannelCount]);
	NSLog(@"BMDDeckLinkAudioOutputRCAChannelCount: %@",[attr intForAttributeID:BMDDeckLinkAudioOutputRCAChannelCount]);
	NSLog(@"BMDDeckLinkAudioOutputXLRChannelCount: %@",[attr intForAttributeID:BMDDeckLinkAudioOutputXLRChannelCount]);
	NSLog(@"BMDDeckLinkDeviceHandle: %@",[attr stringForAttributeID:BMDDeckLinkDeviceHandle]);
	NSLog(@"BMDDeckLinkSupportsColorspaceMetadata: %@",[attr flagForAttributeID:BMDDeckLinkSupportsColorspaceMetadata]);
	NSLog(@"BMDDeckLinkDuplex: %@",[attr intForAttributeID:BMDDeckLinkDuplex]);
	NSLog(@"BMDDeckLinkSupportsHighFrameRateTimecode: %@",[attr flagForAttributeID:BMDDeckLinkSupportsHighFrameRateTimecode]);
	NSLog(@"BMDDeckLinkSupportsSynchronizeToCaptureGroup: %@",[attr flagForAttributeID:BMDDeckLinkSupportsSynchronizeToCaptureGroup]);
	NSLog(@"BMDDeckLinkSupportsSynchronizeToPlaybackGroup: %@",[attr flagForAttributeID:BMDDeckLinkSupportsSynchronizeToPlaybackGroup]);
	NSLog(@"BMDDeckLinkSupportsHDMITimecode: %@",[attr flagForAttributeID:BMDDeckLinkSupportsHDMITimecode]);
	NSLog(@"BMDDeckLinkVANCRequires10BitYUVVideoFrames: %@",[attr flagForAttributeID:BMDDeckLinkVANCRequires10BitYUVVideoFrames]);
	NSLog(@"BMDDeckLinkMinimumPrerollFrames: %@",[attr intForAttributeID:BMDDeckLinkMinimumPrerollFrames]);
	NSLog(@"BMDDeckLinkSupportedDynamicRange: %@",[attr intForAttributeID:BMDDeckLinkSupportedDynamicRange]);
	NSLog(@"BMDDeckLinkSupportsAutoSwitchingPPsFOnInput: %@",[attr flagForAttributeID:BMDDeckLinkSupportsAutoSwitchingPPsFOnInput]);
	NSLog(@"BMDDeckLinkEthernetMACAddress: %@",[attr stringForAttributeID:BMDDeckLinkEthernetMACAddress]);



}

NSDictionary<NSString*,id>* getOptions (int argc, char *const * argv, NSString* arg)
{
	NSMutableDictionary* toptions = [NSMutableDictionary dictionaryWithCapacity:3];
	NSMutableArray *targuments = [NSMutableArray arrayWithCapacity:3];
	if (argc > 0)
	{
			int k;

			while ((k=getopt(argc,argv,[arg UTF8String])) != -1)
			{

					NSString* strarg = [NSString stringWithFormat:@"%c",k];

					if (optarg==NULL)
					{
							[toptions setObject:@"" forKey:strarg];
					} else {
							NSString* stropt = [NSString stringWithUTF8String:optarg];
							[toptions setObject:stropt forKey:strarg];
					}
					// the rest are positional arguments
			}

			argc -= optind;
			argv += optind;
			for (int i=0; i < argc; ++i)
					[targuments addObject:[NSString stringWithUTF8String:argv[i]]];

			[toptions setObject:[NSArray arrayWithArray:targuments] forKey:@"ARGS"];

			// how do we return both of these?
			return [NSDictionary dictionaryWithDictionary:toptions];
			//arguments = [NSArray arrayWithArray:targuments];
	}
	return @{};
}

void intHandler(int dummy) {
    [hw signal];
}


int main(int argc, char *const *  argv)
{
	// NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary<NSString*,id>* options = getOptions(argc,argv,@"hma:v:s:d:f:F:S:l:");

	NSIDeckLinkIterator* dlit = [NSIDeckLinkIterator iterator];
	int deckNumber = 0;
	if ([options objectForKey:@"d"])
		deckNumber = [[options objectForKey:@"d"] intValue] - 1 ;

	NSArray<NSIDeckLink*>* allDecklinks = [dlit allObjects];

	if ([allDecklinks count] > deckNumber)
	{

		NSIDeckLink* decklink = [allDecklinks objectAtIndex:deckNumber];
		NSIDeckLinkInput* dli = [decklink input];

		GetAudio* ga = [[GetAudio alloc] init];

		hw = [NSCondition new];
		signal(SIGINT, intHandler);

		NSIDeckLinkProfileAttributes* attr = [decklink profileAttributes];
		NSLog(@"Got Decklink: \"%@\"",[attr stringForAttributeID:BMDDeckLinkDisplayName]);
		//logDecklinkAttributes(attr);
		NSIDeckLinkConfiguration* dlc = [decklink configuration];

		NSLog(@"configuration: %@",dlc);
/*
    bmdVideoConnectionSDI                                        = 1 << 0,
    bmdVideoConnectionHDMI                                       = 1 << 1,
    bmdVideoConnectionOpticalSDI                                 = 1 << 2,
    bmdVideoConnectionComponent                                  = 1 << 3,
    bmdVideoConnectionComposite                                  = 1 << 4,
    bmdVideoConnectionSVideo                                     = 1 << 5
*/

		int vidConnection = bmdVideoConnectionHDMI;
		if ([options objectForKey:@"v"])
			vidConnection = [[options objectForKey:@"v"] intValue];

		if(![dlc setInt:vidConnection forAttributeID:bmdDeckLinkConfigVideoInputConnection])
		{
			NSLog(@"Failed to set video input connection");
			return 1;
		}

// this can affect the framerate and therefore the samples per frame.
		NSString* vim = @"Hp25";  //  Hp25, H: HD, p: progressive, 25: 25fps aka 1080p25
		NSUInteger spf = 1920; // ( 48000 / fps )

		if ([options objectForKey:@"f"])
		{
			vim = [options objectForKey:@"f"];
		}

		const char *c = [vim UTF8String];
		uint32_t videoInputMode = ((unsigned char)c[0] << 24) |
                 ((unsigned char)c[1] << 16) |
                 ((unsigned char)c[2] << 8) |
                 (unsigned char)c[3];

		NSString* vform = @"2vuy";  // don't confuse with 2yuv
 
		if ([options objectForKey:@"F"])
		{
			vform = [options objectForKey:@"F"];
		}

		c = [vform UTF8String];
		uint32_t videoFormat = ((unsigned char)c[0] << 24) |
                 ((unsigned char)c[1] << 16) |
                 ((unsigned char)c[2] << 8) |
                 (unsigned char)c[3];

		if(![dli enableVideoInputMode:videoInputMode format:videoFormat flags:bmdVideoInputFlagDefault])
		{
			NSLog(@"Could not enable video input: %x for format %x", videoInputMode,videoFormat);
			return 1;
		}

		NSIDeckLinkDisplayMode* dldm = [dli displayMode:videoInputMode];
		NSBMDFrameRate videoFrameRate = [dldm frameRate];

		NSLog(@"Video input framerate: %lld/%lld",videoFrameRate.timeValue,videoFrameRate.timeScale);

		spf = 48000 *   videoFrameRate.timeValue / videoFrameRate.timeScale;

	/*
    bmdAudioConnectionEmbedded                                   = 1 << 0,
    bmdAudioConnectionAESEBU                                     = 1 << 1,
    bmdAudioConnectionAnalog                                     = 1 << 2,
    bmdAudioConnectionAnalogXLR                                  = 1 << 3,
    bmdAudioConnectionAnalogRCA                                  = 1 << 4,
    bmdAudioConnectionMicrophone                                 = 1 << 5,
    bmdAudioConnectionHeadphones                                 = 1 << 6
	*/

		int audConnection = bmdAudioConnectionAnalog;
		if ([options objectForKey:@"a"])
			audConnection = [[options objectForKey:@"a"] intValue];

		if(![dlc setInt:audConnection forAttributeID:bmdDeckLinkConfigAudioInputConnection])
		{
			NSLog(@"Failed to set audio input connection");
			return 1;
		}

		float audInputScale = 0.0;
		if ([options objectForKey:@"s"])
			audInputScale = [[options objectForKey:@"s"] floatValue];

		if(![dlc setFloat:audInputScale forAttributeID:bmdDeckLinkConfigAnalogAudioInputScaleChannel1])
		{
			NSLog(@"Failed to set Audio Input Scale (1)");
			return 1;
		}

		if(![dlc setFloat:audInputScale forAttributeID:bmdDeckLinkConfigAnalogAudioInputScaleChannel2])
		{
			NSLog(@"Failed to set Audio Input Scale (2)");
			return 1;
		}

/*
		if(![dlc setFloat:audInputScale forAttributeID:bmdDeckLinkConfigAnalogAudioInputScaleChannel3])
		{
			NSLog(@"Failed to set Audio Input Scale (3)");
			return 1;
		}

		if(![dlc setFloat:audInputScale forAttributeID:bmdDeckLinkConfigAnalogAudioInputScaleChannel4])
		{
			NSLog(@"Failed to set Audio Input Scale (4)");
			return 1;
		}
*/

		unsigned int bitsPerSample = 16;
		if ([options objectForKey:@"S"])
			bitsPerSample = [[options objectForKey:@"S"] intValue];

		[ga setAudioSampleType:bitsPerSample channelCount:2 samplesPerFrame:spf];
		// bmdAudioSampleType32bitInteger
		// bmdAudioSampleType16bitInteger
		// Only 48Khz supported
		if(![dli enableAudioInputSampleRate:bmdAudioSampleRate48kHz sampleType:bitsPerSample channelCount:2])
		{
			NSLog(@"Could not enable audio");
			return 1;
		}

		if ([options objectForKey:@"m"])
		{
			[ga setupMonitoringSampleRate:48000.0 bits:bitsPerSample samplesPerFrame:spf];
			//return 1;
		}

		NSArray* args = [options objectForKey:@"ARGS"];
		if ([args count]>0)
		{
			NSString * filename = [args firstObject];
			[ga setFileName:filename sampleRate:48000 bits:bitsPerSample];
		}  
		if ([args count]>1)
		{
			NSLog(@"Warning: only using first filename");
		}

		[dli setCallback:ga];
		// NSIDeckLinkDisplayModeIterator* dldmi = [dli displayModeIterator];

// something interesting here with buffer queue synchronization
		[dli startStreams];
		if ([options objectForKey:@"m"] && [options objectForKey:@"l"])
		{
			int frameDelay = [[options objectForKey:@"l"] intValue];
			float sDelay = frameDelay * videoFrameRate.timeValue / videoFrameRate.timeScale;
			[NSThread sleepForTimeInterval:sDelay];
		}
		[ga startOutput];

		NSLog(@"Streams started");


		[hw lock];
		[hw wait]; // but nothing will signal us
		// still put this in for completeness
		[hw unlock];
		//[hw release];

		// stop monitor
		[ga stopMonitoring];
		// stop NSIDecklinkCallback
		NSLog(@"Stopping streams");
		[dli stopStreams];
		[dli flushStreams];
		// close file
		[ga closeFile];

		//[ga autorelease];

	}
	else
	{
		NSLog(@"No Decklinks found.");
	}
//	[ga autorelease];

	//[pool release];
	//NSLog(@"decklink: %@",list);
}
@end
