
#import "NSIDeckLinkDisplayModeIterator.hh"

@implementation NSIDeckLinkDisplayModeIterator

+ (NSIDeckLinkDisplayModeIterator*)displayModeIteratorWithIDeckLinkDisplayModeIterator:(IDeckLinkDisplayModeIterator*)displayModeIterator
{
	return [[[NSIDeckLinkDisplayModeIterator alloc] initWithIDeckLinkDisplayModeIterator:displayModeIterator] autorelease];
}
- (instancetype)initWithIDeckLinkDisplayModeIterator:(IDeckLinkDisplayModeIterator*)displayModeIterator
{
	if (self = [super initWithIUnknown:displayModeIterator refiid:IID_IDeckLinkDisplayModeIterator])
	{
		_displayModeIterator = displayModeIterator;
	}
	return self;
}

-(NSIDeckLinkDisplayMode*)nextObject
{
	IDeckLinkDisplayMode* lp = NULL;

	if (_displayModeIterator->Next(&lp) != S_OK)
		return nil;

														    
	return [NSIDeckLinkDisplayMode displayModeWithIDeckLinkDisplayMode:lp];

}

- (NSArray<NSIDeckLinkDisplayMode*>*)allObjects 
{
	NSMutableArray* devices = [[[NSMutableArray alloc] init] autorelease];

	NSIDeckLinkDisplayMode* deckLink = nil;
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
		state->extra[0] = (long)_displayModeIterator;
		state->state = 1;
	}

	IDeckLinkDisplayMode* lp = NULL;
	IDeckLinkDisplayModeIterator *iter = (IDeckLinkDisplayModeIterator *)state->extra[0];

	if (iter->Next(&lp) != S_OK)
		return 0;	

	NSIDeckLinkDisplayMode* dl = [NSIDeckLinkDisplayMode displayModeWithIDeckLinkDisplayMode:lp];  
	state->itemsPtr = &dl;
	
	return 1;
}

@end