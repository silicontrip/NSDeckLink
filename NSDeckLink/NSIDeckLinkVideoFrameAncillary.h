//#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIUnknown.h"

@interface NSIDeckLinkVideoFrameAncillary : NSIUnknown
{

}

- (BMDPixelFormat)pixelFormat;
- (BMDDisplayMode)displayMode;
- (NSData*)dataForVerticalBlankingLine:(unsigned int)lineNumber;

@end
