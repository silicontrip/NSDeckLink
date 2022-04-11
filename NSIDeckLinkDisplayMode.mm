#import "NSIDeckLinkDisplayMode.hh"

@implementation NSIDeckLinkDisplayMode

+ (NSIDeckLinkDisplayMode*)displayModeWithIDeckLinkDisplayMode:(IDeckLinkDisplayMode*)dm 
{
	return [[[NSIDeckLinkDisplayMode alloc] initWithIDeckLinkDisplayMode:dm] autorelease];
}

- (instancetype)initWithIDeckLinkDisplayMode:(IDeckLinkDisplayMode*)dm
{
	if ((self = [super initWithIUnknown:dm refiid:IID_IDeckLinkDisplayMode]))
	{
		_displaymode = dm; 
	}
	return self;
}

- (NSNumber*)width
{
	return [NSNumber numberWithLong:_displaymode->GetWidth()];
}
- (NSNumber*)height
{
	return [NSNumber numberWithLong:_displaymode->GetHeight()];
}

- (NSString*)name
{
	CFStringRef name;
	if (_displaymode->GetName(&name) != S_OK)
		return nil;

	return (NSString*)name;

}

- (BMDDisplayMode)displayMode
{
	return _displaymode->GetDisplayMode();
}
- (NSBMDFrameRate)frameRate
{
	BMDTimeValue timeValue;
	BMDTimeScale timeScale;

	if (_displaymode->GetFrameRate(&timeValue,&timeScale) != S_OK)
	{
		NSBMDFrameRate frameRate = {0,0};
		return frameRate;
	}

	NSBMDFrameRate frameRate = {timeValue, timeScale};

	return frameRate;
}

- (BMDFieldDominance)fieldDominance
{
	return _displaymode->GetFieldDominance();
}

- (BMDDisplayModeFlags)flags
{
	return _displaymode->GetFlags();
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@ \"%@\" %@x%@ %lld:%lld %u" , [super description], self.name, self.width, self.height, self.frameRate.timeValue, self.frameRate.timeScale, self.fieldDominance];
}

@end