#import "NSIDeckLink.h"


@interface NSIDeckLinkIterator : NSIUnknown <NSFastEnumeration>
{

}

+ (NSIDeckLinkIterator *)iterator;
- (instancetype)init;
- (NSIDeckLink*)nextObject;
- (NSArray<NSIDeckLink*>*)allObjects;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;

@end