#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFPlugInCOM.h>
//#import <CoreFoundation/CFUUID.h>
#import "NSIUnknown.h"

static const REFIID IID_IUnknown = CFUUIDGetUUIDBytes(IUnknownUUID);
bool operator==(const REFIID& lhs, const REFIID& rhs);

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

- (instancetype)initWithIUnknown:(IUnknown*)iunknown refiid:(REFIID)ref;
+ (NSIUnknown *)iunknownWithIUnknown:(IUnknown *)iunknown refiid:(REFIID)ref;

@end