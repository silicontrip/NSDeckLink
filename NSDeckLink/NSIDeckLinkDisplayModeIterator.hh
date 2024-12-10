#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIDeckLinkDisplayModeIterator.h"
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
