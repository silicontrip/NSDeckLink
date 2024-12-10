#import <Foundation/Foundation.h>
//#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIUnknown.h"
#import "NSIDeckLinkVideoFrame.h"

typedef struct {
	BMDTimeValue frameTime;
	BMDTimeValue frameDuration;
} NSBMDStreamTime;

@interface NSIDeckLinkVideoInputFrame : NSIDeckLinkVideoFrame
{

}

- (NSBMDStreamTime)streamTime:(BMDTimeScale)timeScale;
- (NSBMDStreamTime)hardwareReferenceTimestamp:(BMDTimeScale)timeScale;

@end
