#import "NSIDeckLink.hh"

@implementation NSIDeckLink

@synthesize displayName;
@synthesize modelName;

// CPP
+ (NSIDeckLink*)deckLinkWithIDeckLink:(IDeckLink*)decklink 
{
	return [[[NSIDeckLink alloc] initWithIDeckLink:decklink] autorelease];
}

- (instancetype)initWithIDeckLink:(IDeckLink*)decklink
{
	if (self = [super initWithIUnknown:decklink refiid:IID_IDeckLink])
	{
		CFStringRef display = NULL;
		CFStringRef model = NULL;

		_iDeckLink = decklink; //TODO: handle multiple matches
		// _iDeckLink->AddRef();
		// _refiid = IID_IDeckLink;

	 	if (_iDeckLink->GetDisplayName(&display) != S_OK)
			return nil;

		self.displayName = [(NSString*)display copy]; // release?

	 	if (_iDeckLink->GetModelName(&model) != S_OK)
			return nil;

		self.modelName = [(NSString*)model copy];
	}
	return self;
}

- (NSString*)description
{
	 return [NSString stringWithFormat:@"%@: %@, %@",[super description],displayName,modelName];
}


- (NSIDeckLinkProfileAttributes*)profileAttributes
{
	// IDeckLinkProfileAttributes *pavalue;
	// do we go via the C++ iUnknown call 
	// or with our own NSIUnknown
	LPVOID lp;
	HRESULT hr = _iDeckLink->QueryInterface(IID_IDeckLinkProfileAttributes,&lp);  // what is the retain count at this point. appears to be 2

	if (hr != S_OK)
		return nil;

	IDeckLinkProfileAttributes* idpa =(IDeckLinkProfileAttributes*)lp;
	// idpa->Release();

	return [NSIDeckLinkProfileAttributes attributesWithIDeckLinkProfileAttributes:idpa];
}

- (NSIDeckLinkConfiguration*)configuration
{
	//return (NSIDeckLinkConfiguration*)
	// [self queryInterface:IID_IDeckLinkConfiguration];
	LPVOID lp;
	if (_iDeckLink->QueryInterface(IID_IDeckLinkConfiguration,&lp) != S_OK)
		return nil;  
		
	// what is the retain count at this point. appears to be 2
	IDeckLinkConfiguration* idc = (IDeckLinkConfiguration*)lp;
	// idc->Release(); // retain = 1

	//NSLog(@"release reference: %u",idc->Release());

	return [NSIDeckLinkConfiguration configurationWithIDeckLinkConfiguration:idc];
}

- (NSIDeckLinkInput*)input
{

	LPVOID lp;
	if(_iDeckLink->QueryInterface(IID_IDeckLinkInput,&lp) != S_OK)
		return nil;  

	IDeckLinkInput* idi = (IDeckLinkInput*)lp;
	// idi->Release();

	return [NSIDeckLinkInput inputWithIDeckLinkInput:idi];
}

@end