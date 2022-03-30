#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFPlugInCOM.h>
#import "NSIUnknown.h"

@interface NSIUnknown ()
{
	CFUUIDBytes _uuid;
	id _cfuuid;
	IUnknown *_iunknown;
	void* _reserved;
	ULONG _refCount;
}

- (id)initWithIUnknown:(IUnknown*)iunknown;
+ (NSIUnknown *)iunknownWithIUnknown:(IUnknown *)iunknown;



@end