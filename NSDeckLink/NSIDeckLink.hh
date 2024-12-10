#import "NSIDeckLink.h"
#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIUnknown.hh"
#import "NSIDeckLinkProfileAttributes.hh"
#import "NSIDeckLinkConfiguration.hh"
#import "NSIDeckLinkInput.hh"

@interface NSIDeckLink ()
{
	@private
	// IDeckLinkProfileAttributes* _profileAttributes;
	// IDeckLinkConfiguration* _configuration;
	IDeckLink* _iDeckLink;
}

+ (NSIDeckLink*)deckLinkWithIDeckLink:(IDeckLink*)decklink;
- (instancetype)initWithIDeckLink:(IDeckLink*)decklink;

@end
