#import "NSIDeckLink.h"

int main(int argc, const char** argv)
{

	NSArray* list =[NSIDeckLink deckLinkDevices];

	NSLog(@"decklink: %@",list);
}
