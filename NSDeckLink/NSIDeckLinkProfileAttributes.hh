#import "NSIDeckLinkProfileAttributes.h"
#import "NSIUnknown.hh"
#import <DeckLinkAPI/DeckLinkAPI.h>

@interface NSIDeckLinkProfileAttributes () 
{
	IDeckLinkProfileAttributes* _profileAttributes;
}

- (instancetype)initWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pa;
+ (NSIDeckLinkProfileAttributes*)attributesWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pa;

@end
