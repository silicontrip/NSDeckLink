#import <Foundation/Foundation.h>
#import "NSIUnknown.h"
//#import <DeckLinkAPI/DeckLinkAPI.h>

typedef uint32_t BMDDeckLinkAttributeID;

@interface NSIDeckLinkProfileAttributes : NSIUnknown {}

//- (BOOL)flagForAttributeID:(BMDDeckLinkAttributeID)aid;
- (NSNumber*)flagForAttributeID:(BMDDeckLinkAttributeID)cfgID;
- (NSNumber*)intForAttributeID:(BMDDeckLinkAttributeID)cfgID;
- (NSNumber*)floatForAttributeID:(BMDDeckLinkAttributeID)cfgID;
- (NSString *)stringForAttributeID:(BMDDeckLinkAttributeID)cfgID;

@end
