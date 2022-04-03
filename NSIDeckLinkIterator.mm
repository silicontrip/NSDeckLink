#import "NSIDeckLinkIterator.hh"

@implementation NSIDeckLinkIterator 

-(NSIDeckLink*)nextObject
{
	IDeckLink* lp = NULL;
	//IDeckLink* deckLink = nil;

	if (_iDeckLinkIterator->Next(&lp) == S_OK)
		return (NSIDeckLink*)[NSIDeckLink deckLinkWithIDeckLink:lp];

	return nil;
}

+ (NSIDeckLinkIterator *)iterator
{
	return [[[NSIDeckLinkIterator alloc] init] autorelease];
}

// // CreateDeckLinkAPIInformationInstance

- (instancetype)init
{
	if (self = [super init])
	{
		_refiid = IID_IDeckLinkIterator;
		_iDeckLinkIterator = CreateDeckLinkIteratorInstance();
	}
	return self;
}

- (NSArray<NSIDeckLink*>*)allObjects 
{
	NSMutableArray* devices = [[[NSMutableArray alloc] init] autorelease];

	NSIDeckLink* deckLink = nil;
	while ((deckLink = [self nextObject]))
	{
		if (deckLink) {
			[devices addObject:deckLink];
		}
	}
	return [[devices copy] autorelease];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
	if(state->state == 0)
	{
		state->mutationsPtr = (unsigned long *)&_iunknown;
		state->extra[0] = (long)_iDeckLinkIterator;
		state->state = 1;
	}

	IDeckLink* lp = NULL;
	IDeckLinkIterator *iter = (IDeckLinkIterator *)state->extra[0];

	HRESULT rr = iter->Next(&lp);

	if (rr != S_OK)
	{
		return 0;
	}

	NSIDeckLink* dl = [NSIDeckLink deckLinkWithIDeckLink:lp];  
	state->itemsPtr = &dl;
	
	return 1;
}

@end