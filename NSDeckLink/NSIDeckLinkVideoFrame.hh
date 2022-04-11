#import "NSIDeckLinkVideoFrame.h"
#import "NSIDeckLinkTimecode.hh"
#import "NSIDeckLinkVideoFrameAncillary.hh"
#import "NSIUnknown.hh"

@interface NSIDeckLinkVideoFrame ()
{
	@private
	IDeckLinkVideoFrame* _videoframe;
}

+ (NSIDeckLinkVideoFrame*)videoFrameWithIDeckLinkVideoFrame:(IDeckLinkVideoFrame*)videoframe;
- (instancetype)initWithIDeckLinkVideoFrame:(IDeckLinkVideoFrame*)videoframe;

@end