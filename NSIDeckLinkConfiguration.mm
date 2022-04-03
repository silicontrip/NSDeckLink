#import "NSIDeckLinkConfiguration.hh"

@implementation NSIDeckLinkConfiguration

+ (NSIDeckLinkConfiguration*)configurationWithIDeckLinkConfiguration:(IDeckLinkConfiguration*)pa
{
	return [[[NSIDeckLinkConfiguration alloc] initWithIDeckLinkConfiguration:pa] autorelease];
}

- (instancetype)initWithIDeckLinkConfiguration:(IDeckLinkConfiguration*)pa
{
	if (self = [super init])
	{
		_configuration = pa;  // should we addref?
		_configuration->AddRef();
	}
	return self;
}

- (NSNumber*)flagForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	bool value;
	HRESULT hr = _configuration->GetFlag(cfgID,&value);
	if (hr == S_OK)
		return [NSNumber numberWithBool:value];

	return nil;
}

- (NSNumber*)intForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	long long value;
	HRESULT hr = _configuration->GetInt(cfgID,&value);
	if (hr == S_OK)
		return [NSNumber numberWithLongLong:value];

	return nil;
}

- (NSNumber*)floatForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	double value;
	HRESULT hr = _configuration->GetFloat(cfgID,&value);
	if (hr == S_OK)
		return [NSNumber numberWithDouble:value];

	return nil;
}

- (NSString*)stringForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	CFStringRef stringvalue;
	HRESULT hr = _configuration->GetString(cfgID,&stringvalue);
	if (hr == S_OK)
		return (NSString*)stringvalue;

	return nil;
}

- (void)setFlag:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	HRESULT hr = _configuration->SetFlag(cfgID, [value boolValue]);
	if (hr != S_OK)
		NSLog(@"Error setting flag for attribute %d", cfgID);
}

- (void)setInt:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	HRESULT hr = _configuration->SetInt(cfgID, [value longLongValue]);
	if (hr != S_OK)
		NSLog(@"Error setting int for attribute %d", cfgID);
}
- (void)setFloat:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	HRESULT hr = _configuration->SetFloat(cfgID, [value doubleValue]);
	if (hr != S_OK)
		NSLog(@"Error setting float for attribute %d", cfgID);
}
- (void)setString:(NSString*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	HRESULT hr = _configuration->SetString(cfgID, (CFStringRef)value);
	if (hr != S_OK)
		NSLog(@"Error setting string for attribute %d", cfgID);
}


@end