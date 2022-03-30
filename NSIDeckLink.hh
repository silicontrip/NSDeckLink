#import "NSIDeckLink.h"
#import "DeckLinkAPI.h"
#import "DeckLinkAPIDiscovery.h"
#import "NSIUnknown.h"

@interface NSIDeckLink ()
{
	@private
	IDeckLinkProfileAttributes* _profileAttributes;
	IDeckLinkConfiguration* _configuration;
	IDeckLink* _iDeckLink;
}

- (instancetype)initWithIDeckLink:(IDeckLink*)decklink;

@end