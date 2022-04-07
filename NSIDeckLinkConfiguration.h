#import <Foundation/Foundation.h>
#import "NSIUnknown.h"
#import "DeckLinkAPI.h"

@interface NSIDeckLinkConfiguration : NSIUnknown 
{
	
}

- (NSNumber*)flagForAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (NSNumber*)intForAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (NSNumber*)floatForAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (NSString*)stringForAttributeID:(BMDDeckLinkConfigurationID)cfgID;

- (void)setFlag:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (void)setInt:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (void)setFloat:(NSNumber*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (void)setString:(NSString*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;

@end