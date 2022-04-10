#import "NSIDeckLinkProfileAttributes.h"
#import "NSIUnknown.hh"

@interface NSIDeckLinkProfileAttributes () 
{
	IDeckLinkProfileAttributes* _profileAttributes;
}

- (instancetype)initWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pa;
+ (NSIDeckLinkProfileAttributes*)attributesWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pa;

@end