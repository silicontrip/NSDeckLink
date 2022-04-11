#import "DeckLinkAPI.h"
#import "NSIDeckLinkVideoFrame.h"

@protocol NSIDeckLinkScreenPreviewCallback <NSObject>

- (BOOL)drawFrame:(NSIDeckLinkVideoFrame*)videoFrame;

@end