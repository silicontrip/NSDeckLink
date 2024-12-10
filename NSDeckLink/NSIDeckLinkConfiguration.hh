#import "NSIDeckLinkConfiguration.h"
#import "NSIUnknown.hh"
#import <DeckLinkAPI/DeckLinkAPI.h>



@interface NSIDeckLinkConfiguration () 
{
	IDeckLinkConfiguration* _configuration;
}

- (instancetype)initWithIDeckLinkConfiguration:(IDeckLinkConfiguration*)pa;
+ (NSIDeckLinkConfiguration*)configurationWithIDeckLinkConfiguration:(IDeckLinkConfiguration*)pa;

@end
