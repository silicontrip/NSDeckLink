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
	if (self = [super init])
	{
		CFStringRef display = NULL;
		CFStringRef model = NULL;

		_iDeckLink = decklink; //TODO: handle multiple matches
		_iDeckLink->AddRef();
		_refiid = IID_IDeckLink;

	 	if (_iDeckLink->GetDisplayName(&display) != S_OK)
			return nil;

		self.displayName = [(NSString*)display copy];

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

// do these two both work
- (NSIDeckLinkProfileAttributes*)profileAttributes
{
	// IDeckLinkProfileAttributes *pavalue;
	// do we go via the C++ iUnknown call 
	// or with our own NSIUnknown
	LPVOID pav;
	HRESULT hr = _iDeckLink->QueryInterface(IID_IDeckLinkProfileAttributes,&pav);  // what is the retain count at this point.
	if (hr != S_OK)
		return nil;

	return [NSIDeckLinkProfileAttributes attributesWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pav];
}

- (NSIDeckLinkConfiguration*)configuration
{
	return (NSIDeckLinkConfiguration*)[self queryInterface:IID_IDeckLinkConfiguration];
}

@end