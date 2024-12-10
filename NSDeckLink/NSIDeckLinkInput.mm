#import "NSIDeckLinkInput.hh"

@implementation NSIDeckLinkInput
{

}

// I dont think we can init this class as it's internal class is made by a call to the decklink object


+ (NSIDeckLinkInput *)inputWithIDeckLinkInput:(IDeckLinkInput*)deckLinkInput
{
	return [[[NSIDeckLinkInput alloc] initWithIDeckLinkInput:deckLinkInput] autorelease];
}

- (instancetype)initWithIDeckLinkInput:(IDeckLinkInput*)input
{
    if (self = [super initWithIUnknown:input refiid:IID_IDeckLinkInput])
	{
		_decklinkinput = input;
	}
	return self;
}

// want to come up with a better way to report failures

- (BOOL)supportsVideoModeConnection:(BMDVideoConnection)connection mode:(BMDDisplayMode)mode pixelFormat:(BMDPixelFormat)pixelFormat conversionMode:(BMDVideoOutputConversionMode)conversionMode flags:(BMDSupportedVideoModeFlags)flags actualMode:(BMDDisplayMode*)actualMode
{
	//BMDDisplayMode actualMode = NULL;
	bool supported = NO;

	// BMDDisplayMode actualMode;

	//    virtual HRESULT DoesSupportVideoMode (/* in */ BMDVideoConnection connection /* If a value of 0 is specified, the caller does not care about the connection */,
// /* in */ BMDDisplayMode requestedMode, 
// /* in */ BMDPixelFormat requestedPixelFormat, 
// /* in */ BMDSupportedVideoModeFlags flags, /* out */ bool* supported) = 0;

// new in BMD 12.7 
// virtual HRESULT DoesSupportVideoMode (
//	/* in */ BMDVideoConnection connection /* If a value of bmdVideoConnectionUnspecified is specified, the caller does not care about the connection */, 
//	/* in */ BMDDisplayMode requestedMode,
//	/* in */ BMDPixelFormat requestedPixelFormat, 
//	/* in */ BMDVideoOutputConversionMode conversionMode, 
//	/* in */ BMDSupportedVideoModeFlags flags, 
//	/* out */ BMDDisplayMode* actualMode, 
//	/* out */ bool* supported) = 0;


	if (_decklinkinput->DoesSupportVideoMode(connection, mode, pixelFormat, conversionMode, flags, actualMode, &supported) != S_OK)
		return NO;
	
	return supported;
}

- (NSIDeckLinkDisplayModeIterator*)displayModeIterator
{
	IDeckLinkDisplayModeIterator* iterator = NULL;
	
	if (_decklinkinput->GetDisplayModeIterator(&iterator) != S_OK)
		return nil;
	
	return [NSIDeckLinkDisplayModeIterator displayModeIteratorWithIDeckLinkDisplayModeIterator:iterator];
}

- (NSIDeckLinkDisplayMode*)displayMode:(BMDDisplayMode)displayMode
{
	IDeckLinkDisplayMode* deckLinkDisplayMode = NULL;
	
	if (_decklinkinput->GetDisplayMode(displayMode, &deckLinkDisplayMode) != S_OK)
		return nil;
	
	return [NSIDeckLinkDisplayMode displayModeWithIDeckLinkDisplayMode:deckLinkDisplayMode];
}

- (BOOL)setCallback:(id<NSIDeckLinkInputCallback>)callback
{

	// IUnknown* iunknown = NULL;
	// CFTtypeRef lp;
	// NSError* error = nil;
	//HRESULT result = _iunknown->QueryInterface(iid, (void**)&iunknown);

	// encapsulate the NSIDeckLinkInputCallback in the C++ IDeckLinkInputCallback subclass

	IDeckLinkInputCallbackNS* cb = 	new IDeckLinkInputCallbackNS(callback);

	// _decklinkinput->QueryInterface(IID_IDeckLinkInputCallback);
	
	return _decklinkinput->SetCallback(cb) == S_OK;
}

- (BOOL)startStreams
{
	return _decklinkinput->StartStreams() == S_OK;
}

- (BOOL)stopStreams
{
	return _decklinkinput->StopStreams() == S_OK;
}

- (BOOL)flushStreams
{
	return _decklinkinput->FlushStreams() == S_OK;
}

- (BOOL)pauseStreams
{
	return _decklinkinput->PauseStreams() == S_OK;
}

//EnableAudioInput (BMDAudioSampleRate sampleRate, BMDAudioSampleType sampleType, uint32_t channelCount);
//- (BOOL)enableAudioInput:(BMDAudioSampleRate)rate sampleType:(BMDAudioSampleType)type channelCount:(uint32_t)count
//{
//	return _decklinkinput->EnableAudioInput(rate, type, count) == S_OK;
//}

// EnableVideoInput (BMDDisplayMode displayMode, BMDPixelFormat pixelFormat, BMDVideoInputFlags flags);
- (BOOL)enableVideoInput:(BMDDisplayMode)mode format:(BMDPixelFormat)format flags:(BMDVideoInputFlags)flags
{
	return _decklinkinput->EnableVideoInput(mode, format, flags) == S_OK;
}

- (BOOL)setScreenPreviewCallback:(id<NSIDeckLinkScreenPreviewCallback>)previewCallback
{
	// encapsulate the NSIDeckLinkInputCallback in the C++ IDeckLinkInputCallback subclass

	IDeckLinkScreenPreviewCallbackNS* screenPreview = new IDeckLinkScreenPreviewCallbackNS(previewCallback);
	return _decklinkinput->SetScreenPreviewCallback(screenPreview) == S_OK;
	// TODO: Will leak if set callback fails.
}

- (BOOL)enableVideoInputMode:(BMDDisplayMode)displayMode format:(BMDPixelFormat)pixelFormat flags:(BMDVideoInputFlags)inputFlags
{
	return _decklinkinput->EnableVideoInput(displayMode, pixelFormat, inputFlags) == S_OK;
}

- (BOOL)disableVideoInput
{
	return _decklinkinput->DisableVideoInput() == S_OK;
}

- (NSUInteger)availableVideoFrameCount
{
	uint32_t frameCount;
	if (_decklinkinput->GetAvailableVideoFrameCount(&frameCount) != S_OK)
		return 0;

	return frameCount;
}

- (BOOL)enableAudioInputSampleRate:(BMDAudioSampleRate)sampleRate sampleType:(BMDAudioSampleType)sampleType channelCount:(unsigned int)channelCount
{
	return _decklinkinput->EnableAudioInput(sampleRate, sampleType, channelCount) == S_OK;
}

- (BOOL)disableAudioInput
{
	return _decklinkinput->DisableAudioInput() == S_OK;
}

- (NSUInteger)availableAudioSampleFrameCount
{
	uint32_t frameCount;
	if (_decklinkinput->GetAvailableAudioSampleFrameCount(&frameCount))
		return frameCount;

	return 0;
}

- (NSBMDHardwareReferenceClock)hardwareReferenceClockScale:(BMDTimeScale)timeScale
{
	//NSBMDHardwareReferenceClock clock;

	BMDTimeValue hardwareTime;
	BMDTimeValue timeInFrame;
	BMDTimeValue ticksPerFrame;

	if (_decklinkinput->GetHardwareReferenceClock(timeScale, &hardwareTime, &timeInFrame, &ticksPerFrame)!= S_OK)
	{
		NSBMDHardwareReferenceClock clock = {0,0,0};
		return clock;
	}
	NSBMDHardwareReferenceClock	clock = {hardwareTime, timeInFrame, ticksPerFrame};
	return clock;
}


// allocator is something I would expect to see in Core Foundation code.
// setVideoInputFrameMemoryAllocator:(NSIDeckLinkMemoryAllocator*)theAllocator;

// - (BMDTimeValue)hardwareTimeReferenceClockScale:(BMDTimeScale)timeScale
// {
// 	BMDTimeValue hardwareTime;
// 	BMDTimeValue timeInFrame;
// 	BMDTimeValue ticksPerFrame;
// 	if (_decklinkinput->GetHardwareReferenceClock(&hardwareTime, &timeInFrame, &ticksPerFrame)== S_OK)
// 		return hardwareTime; // struct anyone?
// }
// 
// - (BMDTimeValue)timeInFrameReferenceClockScale:(BMDTimeScale)timeScale
// {
// 	BMDTimeValue hardwareTime;
// 	BMDTimeValue timeInFrame;
// 	BMDTimeValue ticksPerFrame;
// 	if (_decklinkinput->GetHardwareReferenceClock(&hardwareTime, &timeInFrame, &ticksPerFrame)== S_OK)
// 		return timeInFrame; // struct anyone?
// }
// 
// - (BMDTimeValue)timeInFrameReferenceClockScale:(BMDTimeScale)timeScale
// {
// 	BMDTimeValue hardwareTime;
// 	BMDTimeValue timeInFrame;
// 	BMDTimeValue ticksPerFrame;
// 	if (_decklinkinput->GetHardwareReferenceClock(&hardwareTime, &timeInFrame, &ticksPerFrame)== S_OK)
// 		return ticksPerFrame; // struct anyone?
// }


@end
