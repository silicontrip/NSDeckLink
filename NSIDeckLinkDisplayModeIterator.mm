
#import "NSIDeckLinkDisplayModeIterator.hh"

@implementation NSIDeckLinkDisplayModeIterator

+ (NSIDeckLinkDisplayModeIterator*)displayModeIteratorWithIDisplayModeIterator:(IDeckLinkDisplayModeIterator*)displayModeIterator
{
	return [[[NSIDeckLinkDisplayModeIterator alloc] initWithIDisplayModeIterator:displayModeIterator] autorelease];
}
- (instancetype)initWithIDisplayModeIterator:(IDeckLinkDisplayModeIterator*)displayModeIterator
{
	if (self = [super initWithIUnknown:displayModeIterator refiid:IID_IDeckLinkDisplayModeIterator])
	{
		_displayModeIterator = displayModeIterator;
	}
	return self;
}

-(NSIDeckLinkDisplayModeIterator*)nextObject
{
	IDeckLink* lp = NULL;

	if (_displayModeIterator->Next(&lp) == S_OK)
		return (NSIDeckLinkDisplayModeIterator*)[NSIDeckLinkDisplayModeIterator displayModeIteratorWithIDisplayModeIterator:lp];

	return nil;
}

- (NSArray<NSIDeckLinkDisplayModeIterator*>*)allObjects 
{
	NSMutableArray* devices = [[[NSMutableArray alloc] init] autorelease];

	NSIDeckLinkDisplayModeIterator* deckLink = nil;
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

	IDeckLinkDisplayMode* lp = NULL;
	IDeckLinkDisplayModeIterator *iter = (IDeckLinkDisplayModeIterator *)state->extra[0];

	if (ter->Next(&lp) != S_OK)
		return 0;	

	NSIDeckLinkDisplayMode* dl = [NSIDeckLinkDisplayMode displayModeWithIDeckLinkDisplayMode:lp];  
	state->itemsPtr = &dl;
	
	return 1;
}

@end