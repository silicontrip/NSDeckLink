#import "NSIDeckLinkVideoFrame.h"

@interface NSIDeckLinkVideoFrame ()
{
	@private
	IDeckLinkVideoFrame* _videoframe;
}

+ (NSIDeckLinkVideoFrame*)videoFrameWithIDeckLinkVideoFrame:(IDeckLinkVideoFrame*)videoframe;
- (instancetype)initWithVideoFrame:(IDeckLinkVideoFrame*)videoframe;

@end