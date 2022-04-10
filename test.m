#import "NSIDeckLink.h"
#import "NSIDeckLinkIterator.h"
#import "NSIDeckLinkInput.h"
#import "NSIDeckLinkDisplayModeIterator.h"
#import "NSIDeckLinkDisplayMode.h"

int main(int argc, const char** argv)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSIDeckLinkIterator* dli = [NSIDeckLinkIterator iterator];
	NSIDeckLink* decklink = [[dli allObjects] firstObject];

	if(decklink)
	{
		NSIDeckLinkProfileAttributes* attr = [decklink profileAttributes];
		NSLog(@"serial port \"%@\"",[attr stringForAttributeID:BMDDeckLinkSerialPortDeviceName]);

		NSIDeckLinkConfiguration* dlc = [decklink configuration];
		[dlc setInt:@(bmdVideoConnectionHDMI) forAttributeID:bmdDeckLinkConfigVideoInputConnection];

		NSIDeckLinkInput* dli = [decklink input];
		NSIDeckLinkDisplayModeIterator* dldmi = [dli displayModeIterator];

		for (NSIDeckLinkDisplayMode* dldm in dldmi)
		{
			NSLog(@"display mode: %@",dldm);
		}

	}

	[pool release];
	//NSLog(@"decklink: %@",list);
}
