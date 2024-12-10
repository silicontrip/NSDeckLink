#import "NSIDeckLinkVideoFrameAncillary.h"
#import "NSIUnknown.hh"
#import <DeckLinkAPI/DeckLinkAPI.h>


@interface NSIDeckLinkVideoFrameAncillary ()
{
	IDeckLinkVideoFrameAncillary* _ancillary;
}

+ (NSIDeckLinkVideoFrameAncillary *)videoFrameAncillaryWithIDeckLinkVideoFrameAncillary:(IDeckLinkVideoFrameAncillary *)iDeckLinkVideFrameAncillary;
- (instancetype)initWithIDeckLinkVideoFrameAncillary:(IDeckLinkVideoFrameAncillary *)iDeckLinkVideFrameAncillary;

@end
