#import <Foundation/Foundation.h>
#import "NSIDeckLinkDisplayMode.h"

@interface NSIDeckLinkDisplayModeIterator : NSIUnknown <NSFastEnumeration>
{

}

- (NSIDeckLinkDisplayMode*)nextObject;
- (NSArray<NSIDeckLinkDisplayMode*>*)allObjects;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;

@end