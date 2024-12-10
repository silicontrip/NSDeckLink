// #include <DeckLink/DeckLinkAPI.h>
#import "NSIDeckLinkScreenPreviewCallback.h"
#import "NSIUnknown.hh"

class IDeckLinkScreenPreviewCallbackNS : public IDeckLinkScreenPreviewCallback
{
	protected:
	id<NSIDeckLinkScreenPreviewCallback> _nsscreenpreviewcallback;
	int32_t m_refCount;
	
	~IDeckLinkScreenPreviewCallbackNS ();
	
	public:
    HRESULT DrawFrame (/* in */ IDeckLinkVideoFrame* theFrame);
    IDeckLinkScreenPreviewCallbackNS(id<NSIDeckLinkScreenPreviewCallback> callback);

	HRESULT QueryInterface(REFIID iid, LPVOID *ppv);
	ULONG AddRef(void);
	ULONG Release(void);

};
