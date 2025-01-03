#import "NSIUnknown.hh"

@implementation NSIUnknown

- (void)release
{
	_refCount = _iunknown->Release();
	[super release];
}

- (NSUInteger)retainCount
{
	return _refCount;
}

- (id)retain
{

	[super retain];
	_refCount = _iunknown->AddRef();
	//NSLog(@"retain: %@ refcount: %u",self,_refCount);

	return self;
}

/*
- (instancetype)init
{
	if (self = [super init])
	{
		_iunknown = new IUnknown();
		_uuid = CFUUIDCreateFromUUIDBytes(NULL, IID_IUnknown);  // where ?
		_uuid = IUnknownUUID;
	}
	return self;
}
*/

//CPP
/*
+ (NSIUnknown *)iunknownWithIUnknown:(IUnknown *)iunknown
{
	return [[[NSIUnknown alloc] initWithIUnknown:iunknown] autorelease];
}
*/
// NSIUnknown iunknownWithIUnknown:refiid:

//CPP
+ (NSIUnknown *)iunknownWithIUnknown:(IUnknown*)iunknown refiid:(REFIID)ref
{
	return [[[NSIUnknown alloc] initWithIUnknown:iunknown refiid:ref] autorelease];
}


- (instancetype)initWithIUnknown:(IUnknown*)iunknown refiid:(REFIID)ref
{
	if (self = [super init])
	{
		_iunknown = iunknown;
		_refCount = _iunknown->AddRef();

		_refiid = ref;
		//_semaphore = dispatch_semaphore_create(1);
	}
	return self;
}

/*
- (void)dealloc
{
	//CFRelease(_uuid);
	//_iunknown->Release();
	[super dealloc];
}
*/

// hoping for some Objective-C magic to handle the COM interfaces
/*
- (BOOL)respondsToSelector:(SEL)what
{
	NSLog(@"responds: %@", NSStringFromSelector (what));
	return NO;
}

- (BOOL)resolveInstanceMethod:(SEL)what
{
	NSLog(@"resolve: %@", NSStringFromSelector (what));
	return NO;
}

- (void)forwardInvocation:(NSInvocation*)what
{
	NSLog(@"invocation: %@", NSStringFromSelector ([what selector]));
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)what
{
	NSMethodSignature* ss = [NSMethodSignature methodSignatureForSelector:@selector(queryInterfaceWithString:)];
	NSLog(@"signature: %@", NSStringFromSelector (what));
	return ss;
}
*/
// mischief managed

- (void*)queryInterfaceWithString:(NSString*)uuid
{
	CFUUIDRef cfuuid =  CFUUIDCreateFromString(NULL,(CFStringRef)uuid);
	CFAutorelease(cfuuid);
	return [self queryInterfaceWithUUID:cfuuid];
}

- (void*)queryInterfaceWithUUID:(CFUUIDRef)uuid
{
	return [self queryInterface:CFUUIDGetUUIDBytes(uuid)];
}

- (REFIID)iunknownType
{
	return _refiid;
}

- (NSString *)iunknownTypeString
{
	CFUUIDRef ruid = CFUUIDCreateFromUUIDBytes(NULL,_refiid);
	CFUUIDRef cfuuid = (CFUUIDRef)CFAutorelease(ruid);
	CFStringRef cfuuids = (CFStringRef)CFAutorelease(CFUUIDCreateString(NULL, cfuuid));

	return (NSString*)cfuuids;
}

// is REFIID cpp? no just a #define
//- (void*)queryInterface:(REFIID)iid error:(NSError**)error
- (NSIUnknown*)queryInterface:(REFIID)iid
{
	IUnknown* iunknown = NULL;

	// CFTtypeRef lp;
	// NSError* error = nil;
	HRESULT result = _iunknown->QueryInterface(iid, (void**)&iunknown);

	if (result != S_OK)
		return nil;

	return [[[NSIUnknown alloc] initWithIUnknown:iunknown refiid:iid] autorelease];

}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@: %@",[super description],[self iunknownTypeString]];
}

@end
