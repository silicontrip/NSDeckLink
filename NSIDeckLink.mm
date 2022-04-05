#import "NSIDeckLink.hh"

@implementation NSIDeckLink

@synthesize displayName;
@synthesize modelName;

/*
+ (NSIDeckLink*)deckLinkWithDisplayName:(NSString*)displayname
{
	return [[[NSIDeckLink alloc] initWithDisplayName:displayname] autorelease];
}

+ (NSIDeckLink*)deckLinkWithModelName:(NSString*)modelname
{
	return [[[NSIDeckLink alloc] initWithModelName:modelname] autorelease];
}

// there may be more than one matching
- (instancetype)initWithDisplayName:(NSString*)displayname
{
	if (self = [super init]) {
		IDeckLinkIterator* deckLinkIterator = CreateDeckLinkIteratorInstance();
		if (deckLinkIterator)
		{
			IDeckLink* deckLink = nil;
			while (deckLinkIterator->Next(&deckLink) == S_OK)
			{
				CFStringRef display=nil;
				HRESULT res = deckLink->GetDisplayName(&display);
				if (res == S_OK) {
					if ([displayname isEqualTo:(NSString*)display]) // what if more than one
					{
						deckLinkIterator->Release();
						return [[[NSIDeckLink alloc] initWithIDeckLink:deckLink] autorelease];
					}
				}
			}
			deckLinkIterator->Release();
		}
	}
	return nil;
}

- (instancetype)initWithModelName:(NSString*)modelname
{
	IDeckLinkIterator* deckLinkIterator = CreateDeckLinkIteratorInstance();
	if (deckLinkIterator)
	{
		IDeckLink* deckLink = nil;
		while (deckLinkIterator->Next(&deckLink) == S_OK)
		{
			CFStringRef model=nil;
			HRESULT res = deckLink->GetDisplayName(&model);
			if (res == S_OK) {
				if ([modelname isEqualTo:(NSString*)model])
				{
					deckLinkIterator->Release();
					return [self initWithIDeckLink:deckLink]; 
				}
			}
		}
		deckLinkIterator->Release();
	}
	return nil;
}
*/
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
	idpa->Release();

	return [NSIDeckLinkProfileAttributes attributesWithIDeckLinkProfileAttributes:idpa];
}

- (NSIDeckLinkConfiguration*)configuration
{
	//return (NSIDeckLinkConfiguration*)
	// [self queryInterface:IID_IDeckLinkConfiguration];
	LPVOID lp;
	HRESULT hr = _iDeckLink->QueryInterface(IID_IDeckLinkConfiguration,&lp);  

	if (hr != S_OK)
		return nil;

	IDeckLinkConfiguration* idc = (IDeckLinkConfiguration*)lp;
	idc->Release(); // retain = 1

	//NSLog(@"release reference: %u",idc->Release());
	// what is the retain count at this point.

	return [NSIDeckLinkConfiguration configurationWithIDeckLinkConfiguration:idc];
}

- (NSIDeckLinkInput*)input
{

	LPVOID lp;
	HRESULT hr = _iDeckLink->QueryInterface(IID_IDeckLinkInput,&lp);  

	if (hr != S_OK)
		return nil;

	IDeckLinkInput* idi = (IDeckLinkInput*)lp;
	idi->Release();

	return [NSIDeckLinkInput inputWithIDeckLinkInput:idi];
}

@end