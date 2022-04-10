#import "NSIDeckLinkTimecode.hh"

@implementation NSIDeckLinkTimecode


+ (NSIDeckLinkTimecode*)timecodeWithIDeckLinkTimecode:(IDeckLinkTimecode*)timecode
{
	return [[[NSIDeckLinkTimecode alloc] initWithIDeckLinkTimecode:timecode] autorelease];
}

- (instancetype)initWithIDeckLinkTimecode:(IDeckLinkTimecode*)timecode
{
	if (self = [super initWithIUnknown:timecode refiid:IID_IDeckLinkTimecode])
	{
		_timecode = timecode;
	}
	return self;
}

- (BMDTimecodeBCD)bcdTimecode
{
	return _timecode->GetBCD();
}

- (NSBMDTimecodeComponents)componentTimecode
{
	
	uint8_t h;
	uint8_t m;
	uint8_t s;
	uint8_t f;

	if (_timecode->GetComponents(&h,&m,&s,&f) != S_OK)
	{
		NSBMDTimecodeComponents components = { h, m, s, f};
		return components;
	}
	
	NSBMDTimecodeComponents components = { h, m, s, f};

	return components;
}

- (BMDTimecodeFlags)timecodeFlags
{
	return _timecode->GetFlags();
}

- (BMDTimecodeUserBits)timecodeUserBits
{
	BMDTimecodeUserBits userBits;

	if ( _timecode->GetTimecodeUserBits(&userBits) != S_OK )
		return 0;

	return userBits;
}

- (NSString *)stringTimecode
{
	CFStringRef string = NULL;
	
	if (_timecode->GetString(&string) != S_OK)
		return nil;
	
	return (NSString*)string;
}

@end