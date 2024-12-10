#import "NSIUnknown.h"
#import "NSIDeckLinkDisplayModeIterator.h"
#import "NSIDeckLinkInputCallback.h"
#import "NSIDeckLinkDisplayMode.h"
#import "NSIDeckLinkScreenPreviewCallback.h"

//#import <DeckLinkAPI/DeckLinkAPI.h>

typedef struct {
	BMDTimeValue hardwareTime;
	BMDTimeValue timeInFrame;
	BMDTimeValue ticksPerFrame;
} NSBMDHardwareReferenceClock;

@interface NSIDeckLinkInput : NSIUnknown
{
}

- (NSIDeckLinkDisplayModeIterator*)displayModeIterator;
- (BOOL)setCallback:(id<NSIDeckLinkInputCallback>)callback;
- (NSIDeckLinkDisplayMode*)displayMode:(BMDDisplayMode)displayMode;
//- (BOOL)supportsVideoModeConnection:(BMDVideoConnection)connection mode:(BMDDisplayMode)mode pixelFormat:(BMDPixelFormat)pixelFormat flags:(BMDSupportedVideoModeFlags)flags;
//- (BOOL)supportsVideoConnection:(BMDVideoConnection)connection mode:(BMDDisplayMode)requestedMode pixelFormat:(BMDPixelFormat)requestedPixelFormat conversion:(BMDVideoInputConversionMode)conversion  flags:(BMDSupportedVideoModeFlags)flags;
- (BOOL)supportsVideoModeConnection:(BMDVideoConnection)connection mode:(BMDDisplayMode)mode pixelFormat:(BMDPixelFormat)pixelFormat conversionMode:(BMDVideoOutputConversionMode)conversionMode flags:(BMDSupportedVideoModeFlags)flags actualMode:(BMDDisplayMode*)actualMode;
- (BOOL)setScreenPreviewCallback:(id<NSIDeckLinkScreenPreviewCallback>)previewCallback;
- (BOOL)enableVideoInputMode:(BMDDisplayMode)displayMode format:(BMDPixelFormat)pixelFormat flags:(BMDVideoInputFlags)inputFlags;
- (BOOL)disableVideoInput;
- (NSUInteger)availableVideoFrameCount;
- (BOOL)enableAudioInputSampleRate:(BMDAudioSampleRate)sampleRate sampleType:(BMDAudioSampleType)sampleType channelCount:(unsigned int)channelCount;
- (BOOL)disableAudioInput;
- (NSUInteger)availableAudioSampleFrameCount;

// allocators seem to be a Core Foundation thing not an NS Foundation thing
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

- (NSBMDHardwareReferenceClock)hardwareReferenceClockScale:(BMDTimeScale)timeScale;

// - (BMDTimeValue)hardwareTimeReferenceClockScale:(BMDTimeValue*)timeScale;
// - (BMDTimeValue)timeInFrameReferenceClockScale:(BMDTimeValue*)timeScale;
// - (BMDTimeValue)ticksPerFrameReferenceClockScale:(BMDTimeValue*)timeScale;

@end
