#import "NSIDeckLinkAudioInputPacket.hh"

@implementation NSIDeckLinkAudioInputPacket

+ (NSIDeckLinkAudioInputPacket*)audioInputPacketWithIDeckLinkAudioInputPacket:(IDeckLinkAudioInputPacket *)packet {
	return [[[NSIDeckLinkAudioInputPacket alloc] initWithIDeckLinkAudioInputPacket:packet] autorelease];
}

- (instancetype)initWithIDeckLinkAudioInputPacket:(IDeckLinkAudioInputPacket *)packet {
	if (packet == NULL)
		return nil;
	if (self = [super initWithIUnknown:packet refiid:IID_IDeckLinkAudioInputPacket]) {
		_audioinputpacket = packet;
	}
	return self;
}

- (NSInteger)sampleFrameCount
{
	return _audioinputpacket->GetSampleFrameCount();
}

- (BMDTimeValue)packetTimeWithScale:(BMDTimeScale)scale
{
	BMDTimeValue value;
	if (_audioinputpacket->GetPacketTime (&value, scale) != S_OK)
		return 0;
	 
	return value;
	
}

- (NSData*)bytes
{
	void* data;
	if ( _audioinputpacket->GetBytes(&data) != S_OK) 
		return nil;

	// a frame is a single point in time.
	// it does not consider bits per sample
	// and it doesn't consider number of channels

	// calculate sample size

	// TODO: correctly calculate sampleSize.
	NSUInteger sampleSize = 4;

	NSInteger dlen = _audioinputpacket->GetSampleFrameCount() * sampleSize;
	//cannot use dataWithBytesNoCopy as NSData will attempt to free the buffer when released but the Decklink API will also free it.
	return [NSData dataWithBytes:data length:dlen];
	
}

@end
