#import "NSIDeckLinkTimecode.h"

@interface NSIDeckLinkTimecode ()

{
	@private
	IDeckLinkTimecode* _timecode;
}

+ (NSIDeckLinkTimecode*)timecodeWithIDeckLinkTimecode:(IDeckLinkTimecode*)timecode;
- (instancetype)initWithIDeckLinkTimecode:(IDeckLinkTimecode*)timecode;

@end
