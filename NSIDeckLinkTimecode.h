
#import "NSIUnknown.h"
#import "DeckLinkAPI.h"

typedef struct {
	uint8_t hours;
	uint8_t minutes;
	uint8_t seconds;
	uint8_t frames;
} NSBMDTimecodeComponents;

@interface NSIDeckLinkTimecode : NSIUnknown
{
	@private
	IDeckLinkTimecode* _timecode;
}

- (BMDTimecodeBCD)bcdTimecode;
- (NSBMDTimecodeComponents)componentTimecode;
- (NSString*)stringTimecode;
- (BMDTimecodeFlags)timecodeFlags;
- (BMDTimecodeUserBits)timecodeUserBits;

@end