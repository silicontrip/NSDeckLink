#import "NSIDeckLinkDisplayMode.h"

@interface NSIDeckLinkDisplayMode ()
{
	IDeckLinkDisplayMode* _displaymode;
}

+ (NSIDeckLinkDisplayMode*)displayModeWithIDeckLinkDisplayMode:(IDeckLinkDisplayMode*)dm;
- (instancetype)initWithIDeckLinkDisplayMode:(IDeckLinkDisplayMode*)dm;

@end