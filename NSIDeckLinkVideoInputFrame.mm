#import "NSIDeckLinkVideoInputFrame.hh"


@implementation
{

}

+ (NSIDeckLinkVideoInputFrame *)videoInputFrameWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame
{
	return [[[NSIDeckLinkVideoInputFrame alloc] initWithIDeckLink:videoInputFrame] autorelease];
}

- (instancetype)initWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame
{
	if (self = [super initWithIUnknown:videoInputFrame refiid:IID_IDeckLinkVideoInputFrame ])
	{
		_videoinputframe = videoInputFrame;
	}
	return self;
}

- (NSBMDStreamTime*)streamTime:(BMDTimeScale)timeScale
{
	BMDTimeValue frameTime;
	BMDTimeValue frameDuration;
	if (_videoinputframe->GetStreamTime(&frameTime, &frameDuration, timeScale) != S_OK)
		return nil;
	
	NSBMDStreamTime st;

	st.frameTime = frameTime;
	st.frameDuration = frameDuration;
	return st;

}

- (StreamTime*)hardwareReferenceTimestamp:(BMDTimeScale)timeScale
{
	BMDTimeValue frameTime;
	BMDTimeValue frameDuration;
	if (_videoinputframe->GetHardwareReferenceTimestamp(timeScale, &frameTime, &frameDuration) != S_OK)
		return nil;
	
	NSBMDStreamTime st;

	st.frameTime = frameTime;
	st.frameDuration = frameDuration;
	return st;

}

@end