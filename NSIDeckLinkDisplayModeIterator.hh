#import "NSIDeckLinkDisplayModeIterator.h"
#import "DeckLinkAPI.h"
#import "NSIUnknown.hh"
#import "NSIDeckLinkDisplayMode.hh"

@interface NSIDeckLinkDisplayModeIterator ()
{
	@private
	IDeckLinkDisplayModeIterator* _displayModeIterator;	
}
+ (NSIDeckLinkDisplayModeIterator*)displayModeIteratorWithIDeckLinkDisplayModeIterator:(IDeckLinkDisplayModeIterator*)displayModeIterator;
- (instancetype)initWithIDeckLinkDisplayModeIterator:(IDeckLinkDisplayModeIterator*)displayModeIterator;

@end