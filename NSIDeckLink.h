#import <CoreFoundation/CFPlugInCOM.h>
#import <CoreFoundation/CFUUID.h>
#import <Foundation/Foundation.h>
#import "NSIUnknown.h"
#import "DeckLinkAPI.h"
#import "NSIDeckLinkProfileAttributes.h"
#import "NSIDeckLinkConfiguration.h"

@interface NSIDeckLink : NSIUnknown {}

@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* modelName;

//+ (instancetype)deckLinkWithDisplayName:(NSString*)displayname;
//+ (instancetype)deckLinkWithModelName:(NSString*)modelname;

//- (instancetype)initWithDisplayName:(NSString*)displayname;
//- (instancetype)initWithModelName:(NSString*)modelname;

//- (NSIDeckLinkOutput*)output;
//- (NSIDeckLinkInput*)input;
- (NSIDeckLinkConfiguration*)configuration;
- (NSIDeckLinkProfileAttributes*)profileAttributes;
//- (NSIDeckLinkStatus*)status;
//- (NSIDeckLinkKeyer*)keyer;
//- (NSIDeckLinkDeckControl*)deckControl;
//- (NSIDeckLinkHDMIInputEDID*)HDMIInputEDID;
//- (NSIDeckLinkNotification*)notification;
//- (NSIDeckLinkEncoderInput*)encoderInput;
//- (NSIDeckLinkProfileManager*)profileManager;
//- (NSIDeckLinkProfile*)profile;
//- (NSIBMDStreamingDeviceInput)streamingDeviceInput;

@end