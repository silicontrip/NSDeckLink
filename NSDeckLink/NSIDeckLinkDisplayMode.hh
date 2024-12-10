#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIDeckLinkDisplayMode.h"
#import "NSIUnknown.hh"

@interface NSIDeckLinkDisplayMode ()
{
	IDeckLinkDisplayMode* _displaymode;
}

+ (NSIDeckLinkDisplayMode*)displayModeWithIDeckLinkDisplayMode:(IDeckLinkDisplayMode*)dm;
- (instancetype)initWithIDeckLinkDisplayMode:(IDeckLinkDisplayMode*)dm;

@end
