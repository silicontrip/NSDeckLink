#import "DeckLinkAPI.h"

@interface NSIDeckLinkAudioInputPacket : NSIUnknown
{

}

- (NSInteger)sampleFrameCount;
- (NSData*)bytes;
- (BMDTimeValue)packetTimeWithScale:(BMDTimeScale)timeScale;

@end