//#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIUnknown.h"

@interface NSIDeckLinkAudioInputPacket : NSIUnknown
{

}

- (NSInteger)sampleFrameCount;
- (NSData*)bytes;  // will deprecate this
- (void)bytes:(void**)data;
- (NSData*)bytesWithSampleSize:(NSUInteger)sampleSize;
- (BMDTimeValue)packetTimeWithScale:(BMDTimeScale)timeScale;

@end
