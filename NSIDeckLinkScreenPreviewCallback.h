#import "DeckLinkAPI.h"
#import "NSIDeckLinkVideoFrame.h"

@protocol NSIDeckLinkScreenPreviewCallback

- (BOOL)drawFrame:(NSIDeckLinkVideoFrame*)videoFrame;

@end