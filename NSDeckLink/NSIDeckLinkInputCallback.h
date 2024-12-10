#import "NSIDeckLinkAudioInputPacket.h"
#import "NSIDeckLinkVideoInputFrame.h"
//#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIDeckLinkDisplayMode.h"

@protocol NSIDeckLinkInputCallback <NSObject>

- (HRESULT)videoInputFrameArrived:(NSIDeckLinkVideoInputFrame*)videoFrame audio:(NSIDeckLinkAudioInputPacket *)audioPacket;
- (HRESULT)videoInputFormatChangedEvent:(BMDVideoInputFormatChangedEvents)notificationEvents displayMode:(NSIDeckLinkDisplayMode*)newDisplayMode signalFlags:(BMDDetectedVideoInputFormatFlags)detectedSignalFlags;

@end
