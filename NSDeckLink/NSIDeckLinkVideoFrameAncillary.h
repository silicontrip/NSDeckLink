#import "DeckLinkAPI.h"
#import "NSIUnknown.h"

@interface NSIDeckLinkVideoFrameAncillary : NSIUnknown
{

}

- (BMDPixelFormat)pixelFormat;
- (BMDDisplayMode)displayMode;
- (NSData*)dataForVerticalBlankingLine:(NSInteger)lineNumber;

@end