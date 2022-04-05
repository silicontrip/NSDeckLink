#import "NSIDeckLinkInput.h"

@interface NSIDeckLinkInput ()
{
	IDeckLinkInput *_deckLinkInput;
}

+ (NSIDeckLinkInput*)deckLinkInputWithDeckLinkInput:(IDeckLinkInput*)deckLinkInput;
- (instancetype)initWithDeckLinkInput:(IDeckLinkInput*)deckLinkInput;

@end