#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIDeckLinkAudioInputPacket.h"
#import "NSIUnknown.hh"

@interface NSIDeckLinkAudioInputPacket () 
{
	IDeckLinkAudioInputPacket* _audioinputpacket;
} 

+ (NSIDeckLinkAudioInputPacket*)audioInputPacketWithIDeckLinkAudioInputPacket:(IDeckLinkAudioInputPacket *)packet;
- (instancetype)initWithIDeckLinkAudioInputPacket:(IDeckLinkAudioInputPacket *)packet;

@end
