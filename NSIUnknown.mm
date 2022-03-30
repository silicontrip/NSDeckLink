#import "NSIUnknown.hh"

@implementation NSIUnknown

- (void)release
{
	_refCount = _iunknown->Release();
}

- (NSUInteger)retainCount
{
	return _refCount;
}

- (id)retain
{
	_refCount = _iunknown->AddRef();
	return self;
}

/*
- (instancetype)init
{
	if (self = [super init])
	{
		_iunknown = new IUnknown();
		_uuid = CFUUIDCreateFromUUIDBytes(NULL, IID_IUnknown);  // where ?
	}
	return self;
}
*/

//CPP
+ (NSIUnknown *)iunknownWithIUnknown:(IUnknown *)iunknown
{
	return [[[NSIUnknown alloc] initWithIUnknown:iunknown] autorelease];
}

//CPP
- (instancetype)initWithIUnknown:(IUnknown*)iunknown
{
	if (self = [super init])
	{
		_iunknown = iunknown;
		// _uuid = CFUUIDCreateFromUUIDBytes(NULL, IID_IUnknown);  // where ?
	}
	return self;
}

- (void)dealloc
{
	//CFRelease(_uuid);
	_iunknown->Release();
	[super dealloc];
}

// is REFIID cpp?
- (void*)queryInterface:(REFIID)iid error:(NSError**)error
{
	LPVOID lp;
	HRESULT result = _iunknown->QueryInterface(iid, &lp);

	if (result != S_OK)
	{
		//*error = [NSError errorWithDomain:NSIUnknownErrorDomain code:result userInfo:nil];
		*error = [NSError errorWithDomain:@"NSIUnknown" code:result userInfo:nil];

		return nil;
	}

	_reserved = lp;
	return lp;
}

@end
