#import "NSIDeckLink.hh"

@implementation NSIDeckLink

@synthesize displayName;
@synthesize modelName;

+ (NSArray<NSDictionary<NSString *,NSString *>*>*)deckLinkDevices
{
	NSMutableArray* devices = [[[NSMutableArray alloc] init] autorelease];
	IDeckLinkIterator* deckLinkIterator = CreateDeckLinkIteratorInstance();
	if (deckLinkIterator)
	{
		IDeckLink* deckLink = nil;
		while (deckLinkIterator->Next(&deckLink) == S_OK)
		{
			CFStringRef model=nil;
			HRESULT modelRes = deckLink->GetModelName(&model);

			CFStringRef display=nil;
			HRESULT displayRes = deckLink->GetDisplayName(&display);

			if ((modelRes == S_OK) && (displayRes == S_OK))
			{
				NSDictionary<NSString *,NSString *>* deckLinkEntry = @{ @"ModelName": (NSString*)model, @"DisplayName": (NSString*)display};
				[devices addObject:deckLinkEntry];
			}
			deckLink->Release();
		}
		deckLinkIterator->Release();
	}
	return [[devices copy] autorelease];
}



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

- (instancetype)initWithIDeckLink:(IDeckLink*)decklink
{
	if (self = [super init])
	{
		CFStringRef display = NULL;
		CFStringRef model = NULL;
		
		_iDeckLink = decklink; //TODO: handle multiple matches
		_iDeckLink->AddRef();

	 	if (_iDeckLink->GetDisplayName(&display) != S_OK)
			return nil;

		self.displayName = [(NSString*)display copy];
		// [_displayName retain]; // needed?

	 	if (_iDeckLink->GetModelName(&model) != S_OK)
			return nil;
		self.modelName = [(NSString*)model copy];
	}
	return self;
}

@end