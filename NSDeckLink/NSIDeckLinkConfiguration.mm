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
		_configuration->AddRef();
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

- (BOOL)setFlag:(BOOL)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	return _configuration->SetFlag(cfgID, value) == S_OK;
		//NSLog(@"Error setting flag for attribute %d", cfgID);
}

- (BOOL)setInt:(NSInteger)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	// NSLog(@"setting int %ld for attribute %d",value, cfgID);
	return _configuration->SetInt(cfgID, value) == S_OK;
		//NSLog(@"Error setting int for attribute %d", cfgID);
}
- (BOOL)setFloat:(double)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	return _configuration->SetFloat(cfgID, value) == S_OK;
		//NSLog(@"Error setting float for attribute %d", cfgID);
}
- (BOOL)setString:(NSString*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID
{
	return _configuration->SetString(cfgID, (CFStringRef)value) == S_OK;
	//NSLog(@"Error setting string for attribute %d", cfgID);
}

@end
