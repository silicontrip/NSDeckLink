#import "NSIDeckLinkDisplayMode.hh"

@implementation NSIDeckLinkDisplayMode

+ (NSIDeckLinkDisplayMode*)displayModeWithDisplayMode:(IDeckLinkDisplayMode*)dm 
{
	return [[[NSIDeckLinkDisplayMode alloc] initWithDisplayMode:dm] autorelease];
}

- (instancetype)initWithIDeckLinkDisplayMode:(IDeckLinkDisplayMode)dm
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
	if (_displaymode->GetName(*name) == S_OK)
		return (NSString*)name;

	return nil;
}

- (BMDDisplayMode)displayMode
{
	return _displaymode->GetDisplayMode();
}
- (NSFrameRate)frameRate
{
	NSFrameRate frameRate;
	BMDTimeValue timeValue;
	BMDTimeScale timeScale;

	if (_displaymode->GetFrameRate(&timeValue,&timeScale) == S_OK)
	{
		// TODO: struct for frame rate, at some point.

	}
	return nil;
}
- (BMDFieldDominance)fieldDominance
{
	return _displaymode->GetFieldDominance();
}

- (BMDDisplayModeFlags)flags
{
	return _displaymode->GetFlags();
}

@end