#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFPlugInCOM.h>
#import <CoreFoundation/CFUUID.h>
#import "NSIUnknown.h"

@interface NSIUnknown ()
{
	// CFUUIDBytes _uuid;
	// id _cfuuid;
	@protected
	REFIID _refiid;
	IUnknown *_iunknown; // internal CPP IUnknown
	void* _reserved;
	ULONG _refCount;
}

- (id)initWithIUnknown:(IUnknown*)iunknown refiid:(REFIID)ref;
+ (NSIUnknown *)iunknownWithIUnknown:(IUnknown *)iunknown refiid:(REFIID)ref;


@end