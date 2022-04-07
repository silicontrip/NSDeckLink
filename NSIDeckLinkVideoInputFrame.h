#import <Foundation/Foundation.h>
#import "DeckLinkAPI.h"

typedef struct {
	BMDTimeValue frameTime;
	BMDTimeValue frameDuration;
} NSBMDStreamTime;

@interface NSIDeckLinkVideoInputFrame : NSIUnknown
{

}

- (NSBMDStreamTime*)streamTime:(BMDTimeScale)timeScale;
- (NSBMDStreamTime*)hardwareReferenceTimestamp:(BMDTimeScale)timeScale;

@end