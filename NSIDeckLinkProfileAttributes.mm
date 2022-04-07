#import "NSIDeckLinkProfileAttributes.hh"

@implementation NSIDeckLinkProfileAttributes

+ (NSIDeckLinkProfileAttributes*)attributesWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pa
{
	return [[[NSIDeckLinkProfileAttributes alloc] initWithIDeckLinkProfileAttributes:pa] autorelease];
}

- (instancetype)initWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pa
{
	if (self = [super initWithIUnknown:pa refiid:IID_IDeckLinkProfileAttributes])
	{
		_profileAttributes = pa;  // should we addref?
		NSLog(@"profile attributes addref count: %u",_profileAttributes->AddRef());
		//_profileAttributes->AddRef();
	}
	return self;
}

- (NSNumber*)flagForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	bool value;
	HRESULT hr = _profileAttributes->GetFlag(cfgID,&value);
	if (hr != S_OK)
		return nil;
	
	return [NSNumber numberWithBool:value];
}

- (NSNumber*)intForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	long long value;
	HRESULT hr = _profileAttributes->GetInt(cfgID,&value);
	if (hr != S_OK)
		return nil;

	return [NSNumber numberWithLongLong:value];

}

- (NSNumber*)floatForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	double value;
	HRESULT hr = _profileAttributes->GetFloat(cfgID,&value);
	if (hr != S_OK)
		return nil;

	return [NSNumber numberWithDouble:value];

}

- (NSString*)stringForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	CFStringRef stringvalue;
	HRESULT hr = _profileAttributes->GetString(cfgID,&stringvalue);
	if (hr != S_OK)
		return nil;

	return (NSString*)stringvalue;

}

@end