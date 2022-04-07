#import "NSIDeckLinkAudioInputPacket.h"
#import "DeckLinkAPI.h"

@interface NSIDeckLinkAudioInput () {

} 

+ (NSIDeckLinkAudioInputPacket*)audioInputPacketWithIDeckLinkAudioInputPacket:(IDeckLinkAudioInputPacket *)packet;
- (instancetype)initWithIDeckLinkAudioInputPacket:(IDeckLinkAudioInputPacket *)packet;

@end