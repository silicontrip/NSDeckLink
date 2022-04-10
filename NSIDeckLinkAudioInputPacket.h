#import "DeckLinkAPI.h"
#import "NSIUnknown.h"

@interface NSIDeckLinkAudioInputPacket : NSIUnknown
{

}

- (NSInteger)sampleFrameCount;
- (NSData*)bytes;
- (BMDTimeValue)packetTimeWithScale:(BMDTimeScale)timeScale;

@end