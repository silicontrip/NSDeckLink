#import "NSIDeckLinkVideoInputFrame.h"
#import "NSIUnknown.hh"


@interface NSIDeckLinkVideoInputFrame () 
{
	IDeckLinkVideoInputFrame * _videoinputframe;
}

+ (NSIDeckLinkVideoInputFrame*)videoInputFrameWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame;
- (instancetype)initWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame;

@end