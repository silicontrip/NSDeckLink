#import "NSIDeckLinkProfileAttributes.h"

@interface NSIDeckLinkProfileAttributes () 
{
	IDeckLinkProfileAttributes* _profileAttributes;
}

- (instancetype)initWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pa;
+ (NSIDeckLinkProfileAttributes*)attributesWithIDeckLinkProfileAttributes:(IDeckLinkProfileAttributes*)pa;

@end