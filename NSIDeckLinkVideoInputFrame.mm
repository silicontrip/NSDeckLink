#import "NSIDeckLinkVideoInputFrame.hh"


@implementation NSIDeckLinkVideoInputFrame
{

}

+ (NSIDeckLinkVideoInputFrame *)videoInputFrameWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame
{
	return [[[NSIDeckLinkVideoInputFrame alloc] initWithIDeckLinkVideoInputFrame:videoInputFrame] autorelease];
}

- (instancetype)initWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame
{
	if (self = [super initWithIUnknown:videoInputFrame refiid:IID_IDeckLinkVideoInputFrame ])
	{
		_videoinputframe = videoInputFrame;
	}
	return self;
}

- (NSBMDStreamTime)streamTime:(BMDTimeScale)timeScale
{
	BMDTimeValue frameTime;
	BMDTimeValue frameDuration;
	if (_videoinputframe->GetStreamTime(&frameTime, &frameDuration, timeScale) != S_OK)
	{
		NSBMDStreamTime st = {0, 0};
		return st;
	}

	NSBMDStreamTime st = {frameTime, frameDuration};
	return st;

}

- (NSBMDStreamTime)hardwareReferenceTimestamp:(BMDTimeScale)timeScale
{
	BMDTimeValue frameTime;
	BMDTimeValue frameDuration;
	if (_videoinputframe->GetHardwareReferenceTimestamp(timeScale, &frameTime, &frameDuration) != S_OK)
	{
		NSBMDStreamTime st = {0, 0};
		return st;
	}
	NSBMDStreamTime st = {frameTime, frameDuration};
	return st;

}

@end