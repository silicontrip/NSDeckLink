#include "DeckLinkAPI.h"
#import <Foundation/Foundation.h>

typedef struct {
	BMDTimeValue timeValue;
	BMDTimeScale timeScale;
} NSFrameRate;

@interface NSIDeckLinkDisplayMode : NSIUnknown
{

}

- (NSNumber*)width;
- (NSNumber*)height;
- (NSString*)name;
- (BMDDisplayMode)displayMode;
- (NSFrameRate)frameRate;
- (BMDFieldDominance)fieldDominance;
- (BMDDisplayModeFlags)flags;

@end