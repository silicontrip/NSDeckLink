#import "NSIDeckLinkDisplayModeIterator.h"
#import "DeckLinkAPI.h"

@interface NSIDeckLinkDisplayModeIterator 
	@private
	IDeckLinkDisplayModeIterator* _displayModeIterator;	
}

+ (NSIDeckLinkDisplayModeIterator)displayModeIteratorWithIDisplayModeIterator:(IDeckLinkDisplayModeIterator*)displayModeIterator;]
- (instancetype)initWithIDisplayModeIterator:(IDeckLinkDisplayModeIterator*)displayModeIterator;

@end