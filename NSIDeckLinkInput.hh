#import "NSIDeckLinkInput.h"

@interface NSIDeckLinkInput ()
{
	IDeckLinkInput *_deckLinkInput;
}

+ (NSIDeckLinkInput*)inputWithDeckLinkInput:(IDeckLinkInput*)deckLinkInput;
- (instancetype)initWithDeckLinkInput:(IDeckLinkInput*)deckLinkInput;


@end