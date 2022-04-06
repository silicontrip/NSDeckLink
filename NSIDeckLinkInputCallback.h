#import "NSIDeckLinkAudioInputPacket.h"
#import "NSIDeckLinkVideoInputFrame.h"

@protocol NSIDeckLinkInputCallback 

- (HRESULT)videoInputFrameArrived:(NSIDeckLinkVideoInputFrame*)videoFrame audio:(NSIDeckLinkAudioInputPacket *)audioPacket;
- (HRESULT)videoInputFormatChangedEvent:(BMDVideoInputFormatChangedEvents*)notificationEvents displayMode:(NSIDeckLinkDisplayMode*)newDisplayMode flags:(BMDDetectedVideoInputFormatFlags*)detectedSignalFlags;

@end