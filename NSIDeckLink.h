#import <CoreFoundation/CFPlugInCOM.h>
#import <CoreFoundation/CFUUID.h>
#import <Foundation/Foundation.h>
#import "NSIUnknown.h"


@interface NSIDeckLink : NSIUnknown {}

@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* modelName;

+ (NSArray<NSDictionary<NSString *,NSString *>*>*)deckLinkDevices;

+ (instancetype)deckLinkWithDisplayName:(NSString*)displayname;
+ (instancetype)deckLinkWithModelName:(NSString*)modelname;
- (instancetype)initWithDisplayName:(NSString*)displayname;
- (instancetype)initWithModelName:(NSString*)modelname;

@end