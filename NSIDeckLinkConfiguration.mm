#import "NSIDeckLinkConfiguration.hh"

@implementation NSIDeckLinkConfiguration

+ (NSIDeckLinkConfiguration*)configurationWithIDeckLinkConfiguration:(IDeckLinkConfiguration*)pa
{
	return [[[NSIDeckLinkConfiguration alloc] initWithIDeckLinkConfiguration:pa] autorelease];
}

- (instancetype)initWithIDeckLinkConfiguration:(IDeckLinkConfiguration*)pa
{
	if (self = [super initWithIUnknown:pa refiid:IID_IDeckLinkConfiguration])
	{
		_configuration = pa;  // should we addref?
		//_configuration->AddRef();
	}
	return self;
}

- (NSNumber*)flagForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	bool value;
	HRESULT hr = _configuration->GetFlag(cfgID,&value);
	if (hr != S_OK)
		return nil;

	return [NSNumber numberWithBool:value];

}

- (NSNumber*)intForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	long long value;
	HRESULT hr = _configuration->GetInt(cfgID,&value);
	if (hr != S_OK)
		return nil;

	return [NSNumber numberWithLongLong:value];

}

- (NSNumber*)floatForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	double value;
	HRESULT hr = _configuration->GetFloat(cfgID,&value);
	if (hr != S_OK)
		return nil;

	return [NSNumber numberWithDouble:value];

}

- (NSString*)stringForAttributeID:(BMDDeckLinkAttributeID)cfgID
{
	CFStringRef stringvalue;
	HRESULT hr = _configuration->GetString(cfgID,&stringvalue);
	if (hr != S_OK)
		return nil;

	return (NSString*)stringvalue;

}

- (void)setFlag:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	if (_configuration->SetFlag(cfgID, [value boolValue]) != S_OK)
		NSLog(@"Error setting flag for attribute %d", cfgID);
}

- (void)setInt:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	if (_configuration->SetInt(cfgID, [value longLongValue]) != S_OK)
		NSLog(@"Error setting int for attribute %d", cfgID);
}
- (void)setFloat:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	if (_configuration->SetFloat(cfgID, [value doubleValue]) != S_OK)
		NSLog(@"Error setting float for attribute %d", cfgID);
}
- (void)setString:(NSString*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	if (_configuration->SetString(cfgID, (CFStringRef)value) != S_OK)
		NSLog(@"Error setting string for attribute %d", cfgID);
}

@end