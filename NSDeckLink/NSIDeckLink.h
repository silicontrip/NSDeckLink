#import <Foundation/Foundation.h>
#import "NSIUnknown.h"
#import "DeckLinkAPI.h"
#import "NSIDeckLinkProfileAttributes.h"
#import "NSIDeckLinkConfiguration.h"
#import "NSIDeckLinkInput.h"

@interface NSIDeckLink : NSIUnknown {}

@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* modelName;

//- (NSIDeckLinkOutput*)output;
- (NSIDeckLinkInput*)input;
- (NSIDeckLinkConfiguration*)configuration;
- (NSIDeckLinkProfileAttributes*)profileAttributes;
//- (NSIDeckLinkProfileAttributes*)attr;

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