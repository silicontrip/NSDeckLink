#include "DeckLinkAPI.h"
#import <Foundation/Foundation.h>

typedef struct {
	BMDTimeValue timeValue;
	BMDTimeScale timeScale;
} NSBMDFrameRate;

@interface NSIDeckLinkDisplayMode : NSIUnknown
{

}

- (NSNumber*)width;
- (NSNumber*)height;
- (NSString*)name;
- (BMDDisplayMode)displayMode;
- (NSBMDFrameRate)frameRate;
- (BMDFieldDominance)fieldDominance;
- (BMDDisplayModeFlags)flags;

@end