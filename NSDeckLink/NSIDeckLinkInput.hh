#import "NSIDeckLinkInput.h"
#import "NSIUnknown.hh"
#import "NSIDeckLinkDisplayModeIterator.hh"
#import "NSIDeckLinkDisplayMode.hh"
#import "IDeckLinkInputCallbackNS.hh"
#import "IDeckLinkScreenPreviewCallbackNS.hh"


@interface NSIDeckLinkInput ()
{
	IDeckLinkInput *_decklinkinput;
}

+ (NSIDeckLinkInput*)inputWithIDeckLinkInput:(IDeckLinkInput*)deckLinkInput;
- (instancetype)initWithIDeckLinkInput:(IDeckLinkInput*)deckLinkInput;


@end