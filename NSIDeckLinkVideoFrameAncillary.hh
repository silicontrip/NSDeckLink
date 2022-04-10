
#import "NSIDeckLinkVideoFrameAncillary.h"
#import "NSIUnknown.hh"

@interface NSIDeckLinkVideoFrameAncillary ()
{
	IDeckLinkVideoFrameAncillary* _ancillary;
}

+ (NSIDeckLinkVideoFrameAncillary *)videoFrameAncillaryWithIDeckLinkVideoFrameAncillary:(IDeckLinkVideoFrameAncillary *)iDeckLinkVideFrameAncillary;
- (instancetype)initWithIDeckLinkVideoFrameAncillary:(IDeckLinkVideoFrameAncillary *)iDeckLinkVideFrameAncillary;

@end
