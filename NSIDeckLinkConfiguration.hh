#import "NSIDeckLinkConfiguration.h"

@interface NSIDeckLinkConfiguration () 
{
	IDeckLinkConfiguration* _configuration;
}

- (instancetype)initWithIDeckLinkConfiguration:(IDeckLinkConfiguration*)pa;
+ (NSIDeckLinkConfiguration*)configurationWithIDeckLinkConfiguration:(IDeckLinkConfiguration*)pa;

@end