#import "NSIUnknown.h"
#import "NSIDeckLinkTimecode.h"
#import "DeckLinkAPI.h"
#import "NSIDeckLinkVideoFrameAncillary.h"

@interface NSIDeckLinkVideoFrame : NSIUnknown
{

}

- (NSInteger)width;
- (NSInteger)height;
- (NSInteger)rowBytes;
- (BMDPixelFormat)pixelFormat;
- (BMDFrameFlags)flags;
- (NSData*)bytes;
- (NSIDeckLinkTimecode*)timecodeFormat:(BMDTimecodeFormat)format;
- (NSIDeckLinkVideoFrameAncillary*)ancillaryData;

@end