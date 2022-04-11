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

- (void)setFlag:(BOOL)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (void)setInt:(NSInteger)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (void)setFloat:(double)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;
- (void)setString:(NSString*)value forAttributeID:(BMDDeckLinkConfigurationID)cfgID;

@end