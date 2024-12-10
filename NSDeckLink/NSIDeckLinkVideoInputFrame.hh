#import "NSIDeckLinkVideoInputFrame.h"
#import "NSIUnknown.hh"
#import "NSIDeckLinkVideoFrame.hh"

@interface NSIDeckLinkVideoInputFrame () 
{
	IDeckLinkVideoInputFrame * _videoinputframe;
}

+ (NSIDeckLinkVideoInputFrame*)videoInputFrameWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame;
- (instancetype)initWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame;

@end
