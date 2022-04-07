#import "NSIDeckLinkVideoInputFrame.h"

@interface NSIDeckLinkVideoInputFrame () 
{
	IDeckLinkVideoInputFrame * _videoinputframe;
}

+ (NSIDeckLinkVideoInputFrame*)videoInputFrameWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame;
- (instancetype)initWithIDeckLinkVideoInputFrame:(IDeckLinkVideoInputFrame*)videoInputFrame;

@end