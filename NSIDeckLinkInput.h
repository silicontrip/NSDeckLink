#import "NSIUnknown.h"
#import "NSIDeckLinkDisplayModeIterator.h"
#import "NSIDeckLinkInputCallback.h"
#import "NSIDeckLinkDisplayMode.h"

@interface NSIDeckLinkInput : NSIUnknown
{
}

- (NSIDeckLinkDisplayModeIterator*)displayModeIterator;
- (void)setCallback:(NSIDeckLinkInputCallback*)callback;
- (NSIDeckLinkDisplayMode*)displayMode:(BMDDisplayMode)displayMode;
- (BOOL)supportsVideoConnection:(BMDVideoConnection)connection mode:(BMDDisplayMode)requestedMode pixelFormat:(BMDPixelFormat)requestedPixelFormat conversion:(BMDVideoInputConversionMode)conversion  flags:(BMDSupportedVideoModeFlags)flags;
- (void)setScreenPreviewCallback:(NSIDeckLinkScreenPreviewCallback*)previewCallback;
- (BOOL)enableVideoInputMode:(BMDDisplayMode)displayMode format:(BMDPixelFormat)pixelFormat flags:(BMDVideoInputFlags)inputFlags;
- (BOOL)disableVideoInput;
- (NSUInteger)availableVideoFrameCount;
- (BOOL)enableAudioInputSampleRate:(BMDAudioSampleRate)sampleRate type:(BMDAudioSampleType)sampleType count:(NSUInteger)channelCount;
- (BOOL)disableAudioInput;
- (NSUInteger)availableAudioSampleFrameCount;

// allocators seem to be a Core Foundation thing
// setVideoInputFrameMemoryAllocator:(NSIDeckLinkMemoryAllocator*)theAllocator;

- (BOOL)startStreams;
- (BOOL)stopStreams;
- (BOOL)flushStreams;
- (BOOL)pauseStreams;

// this one is annoying
/*
- (void) getHardwareReferenceClockScale:(BMDTimeScale)timeScale
hardwareTime:(BMDTimeValue*)hardwareTime 
timeInFrame:(BMDTimeValue*)timeInFrame 
ticksPerFrame:(BMDTimeValue*)ticks;
*/

- (BMDTimeValue)hardwareTimeReferenceClockScale:(BMDTimeValue*)timeScale;
- (BMDTimeValue)timeInFrameReferenceClockScale:(BMDTimeValue*)timeScale;
- (BMDTimeValue)ticksPerFrameReferenceClockScale:(BMDTimeValue*)timeScale;

@end