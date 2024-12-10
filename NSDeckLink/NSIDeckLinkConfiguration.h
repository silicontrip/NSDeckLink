#import <Foundation/Foundation.h>
//#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIUnknown.h"

@interface NSIDeckLinkConfiguration : NSIUnknown 
{
	
}

- (NSNumber*)flagForAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (NSNumber*)intForAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (NSNumber*)floatForAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (NSString*)stringForAttributeID:(BMDDeckLinkConfigurationID)cfgID;

- (BOOL)setFlag:(BOOL)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (BOOL)setInt:(NSInteger)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (BOOL)setFloat:(double)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (BOOL)setString:(NSString*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;

@end
