#import "NSIDeckLinkInput.hh"

@implementation NSIDeckLinkInput
{

}

// I dont think we can init this class as it's internal class is made by a call to the decklink object
+ (NSIDeckLinkInput *)inputWithIDeckLinkInput:(IDeckLinkInput*)input
{
	return [[[NSIDeckLinkInput alloc] initWithIDeckLinkInput:input] autorelease];
}

- (instancetype)initWithIDeckLinkInput:(IDeckLinkInput*)input
{
    if (self = [super initWithIUnknown:input refiid:IID_IDeckLinkInput])
	{
		_deckLinkinput = input;
	}
	return self;
}

// want to come up with a better way to report failures

- (BOOL)supportsVideoModeConnection:(BMDVideoConnection)connection mode:(BMDDisplayMode)mode pixelFormat:(BMDPixelFormat)pixelFormat conversion:(BMDVideoOutputConversionMode)conversion flags:(BMDSupportedVideoModeFlags)flags
{
	//BMDDisplayMode actualMode = NULL;
	BOOL supported = NO;
	
	if (_deckLinkInput->DoesSupportVideoMode(connection, mode, pixelFormat, conversion, flags, &supported) != S_OK)
		return NO;
	
	return supported;
}

- (NSIDeckLinkDisplayModeIterator*)displayModeIterator
{
	IDeckLinkDisplayModeIterator* iterator = NULL;
	
	if (_deckLinkInput->GetDisplayModeIterator(&iterator) != S_OK)
		return nil;
	
	return [NSIDeckLinkDisplayModeIterator displayModeIteratorWithIDeckLinkDisplayModeIterator:iterator];
}

- (NSIDeckLinkDisplayMode*)displayMode:(BMDDisplayMode)displayMode
{
	IDeckLinkDisplayMode* deckLinkDisplayMode = NULL;
	
	if (_deckLinkInput->GetDisplayMode(displayMode, &deckLinkDisplayMode) != S_OK)
		return nil;
	
	return [NSIDeckLinkDisplayMode displayModeWithIDeckLinkDisplayMode:deckLinkDisplayMode];
}

- (void)setCallback:(NSIDeckLinkInputCallback*)callback
{

// encapsulate the NSIDeckLinkInputCallback in the C++ IDeckLinkInputCallback subclass
	IDeckLinkInputCallbackNS* cb = new IDeckLinkInputCallbackNS(callback);

	if (_deckLinkInput->SetCallback(cb) != S_OK)
		return;
}

- (BOOL)startStreams
{
	return _deckLinkInput->StartStreams() == S_OK;
}

- (BOOL)stopStreams
{
	return _deckLinkInput->StopStreams == S_OK;
}

- (BOOL)flushStreams
{
	return _deckLinkInput->FlushStreams() == S_OK;
}

- (BOOL)pauseStreams
{
	return _deckLinkInput->PauseStreams() == S_OK;
}


- (BOOL)enableAudioInput:(BOOL)enable
{
	return _deckLinkInput->EnableAudioInput(enable) == S_OK;
}

- (BOOL)enableVideoInputMode:(BMDDisplayMode)displayMode format:(BMDPixelFormat)pixelFormat flags:(BMDVideoInputFlags)inputFlags
{
	return (_deckLinkInput->enableVideoInput(displayMode,pixelFormat,inputFlags));
}

- (BOOL)enableVideoInput:(BOOL)enable
{
	return _deckLinkInput->EnableVideoInput(enable) == S_OK;
}

- (BOOL)setScreenPreviewCallback:(NSIDeckLinkScreenPreviewCallback*)previewCallback
{
	// encapsulate the NSIDeckLinkInputCallback in the C++ IDeckLinkInputCallback subclass

	return _deckLinkInput->SetScreenPreviewCallback(previewCallback) == S_OK;
}

- (BOOL)enableVideoInputMode:(BMDDisplayMode)displayMode format:(BMDPixelFormat)pixelFormat flags:(BMDVideoInputFlags)inputFlags
{
	return _deckLinkInput->EnableVideoInputMode(displayMode, pixelFormat, inputFlags) == S_OK;
}

- (BOOL)disableVideoInput
{
	return _deckLinkInput->DisableVideoInput() == S_OK;
}

- (NSInteger)availableVideoFrameCount
{
	int frameCount;
	if (_deckLinkInput->GetAvailableVideoFrameCount(&frameCount) == S_OK)
		return frameCount;
	return -1; // NSNumber and nil maybe?
}

- (BOOL)enableAudioInputSampleRate:(BMDAudioSampleRate)sampleRate type:(BMDAudioSampleType)sampleType count:(NSUInteger)channelCount
{
	return _deckLinkInput->EnableAudioInput(sampleRate, sampleType, channelCount) == S_OK;
}

- (BOOL)disableAudioInput
{
	return _deckLinkInput->DisableAudioInput() == S_OK;
}

- (NSInteger)availableAudioSampleFrameCount
{
	int frameCount;
	if (_deckLinkInput->GetAvailableAudioSampleFrameCount(&frameCount))
		return frameCount;
}

// allocator is something I would expect to see in Core Foundation code.
// setVideoInputFrameMemoryAllocator:(NSIDeckLinkMemoryAllocator*)theAllocator;

- (BMDTimeValue)hardwareTimeReferenceClockScale:(BMDTimeScale)timeScale
{
	BMDTimeValue hardwareTime;
	BMDTimeValue timeInFrame;
	BMDTimeValue ticksPerFrame;
	if (_deckLinkInput->GetHardwareReferenceClock(&hardwareTime, &timeInFrame, &ticksPerFrame)== S_OK)
		return hardwareTime; // struct anyone?
}

- (BMDTimeValue)timeInFrameReferenceClockScale:(BMDTimeScale)timeScale
{
	BMDTimeValue hardwareTime;
	BMDTimeValue timeInFrame;
	BMDTimeValue ticksPerFrame;
	if (_deckLinkInput->GetHardwareReferenceClock(&hardwareTime, &timeInFrame, &ticksPerFrame)== S_OK)
		return timeInFrame; // struct anyone?
}

- (BMDTimeValue)timeInFrameReferenceClockScale:(BMDTimeScale)timeScale
{
	BMDTimeValue hardwareTime;
	BMDTimeValue timeInFrame;
	BMDTimeValue ticksPerFrame;
	if (_deckLinkInput->GetHardwareReferenceClock(&hardwareTime, &timeInFrame, &ticksPerFrame)== S_OK)
		return ticksPerFrame; // struct anyone?
}
@end