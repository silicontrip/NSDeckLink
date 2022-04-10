#import "NSIDeckLinkAudioInputPacket.hh"

@implementation NSIDeckLinkAudioInputPacket

+ (NSIDeckLinkAudioInputPacket*)audioInputPacketWithIDeckLinkAudioInputPacket:(IDeckLinkAudioInputPacket *)packet {
	return [[[NSIDeckLinkAudioInputPacket alloc] initWithIDeckLinkAudioInputPacket:packet] autorelease];
}
- (instancetype)initWithIDeckLinkAudioInputPacket:(IDeckLinkAudioInputPacket *)packet {
	if (self = [super initWithIUnknown:packet refiid:IID_IDeckLinkAudioInputPacket]) {
		_audioinputpacket = packet;
	}
	return self;
}

- (NSInteger)sampleFrameCount
{
	return _audioinputpacket->GetSampleFrameCount();
}

- (BMDTimeValue)packetTimeWithScale:(BMDTimeScale)scale
{
	BMDTimeValue value;
	if (_audioinputpacket->GetPacketTime (&value, scale) != S_OK)
		return 0;
	 
	return value;
	
}

- (NSData*)bytes
{
	void* data;
	if ( _audioinputpacket->GetBytes(&data) != S_OK) 
		return nil;
		
	NSInteger dlen = _audioinputpacket->GetSampleFrameCount();
	return [NSData dataWithBytesNoCopy:data length:dlen];
	
}

@end