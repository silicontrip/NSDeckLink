#import "NSIDeckLinkVideoFrameAncillary.h"

@interface NSIDeckLinkVideoFrameAncillary ()
{
	IDeckLinkVideoFrameAncillary* _ancillary;
}


+ (NSIDeckLinkVideoFrameAncillary *)videoFrameAncillaryWithIDeckLinkVideFrameAncillary:(IDeckLinkVideoFrameAncillary *)iDeckLinkVideFrameAncillary;
- (instancetype)initWithIDeckLinkVideFrameAncillary:(IDeckLinkVideoFrameAncillary *)iDeckLinkVideFrameAncillary;

@end