#include "DeckLinkAPI.h"
#include "IDeckLinkScreenPreviewCallbackNS.hh"
#import "NSIDeckLinkScreenPreviewCallback.h"
#import "NSIDeckLinkVideoFrame.hh"


/* Interface IDeckLinkInputCallback - Frame arrival callback. */

// there is a Cocoa varient of this class

IDeckLinkScreenPreviewCallbackNS::~IDeckLinkScreenPreviewCallbackNS () {
	[_nsscreenpreviewcallback release];
} // call Release method to drop reference count

// IUnknown methods

HRESULT IDeckLinkScreenPreviewCallbackNS::QueryInterface(REFIID iid, LPVOID *ppv)
{
	HRESULT result = S_OK;

	if (ppv == nullptr)
		return E_INVALIDARG;

	// Obtain the IUnknown interface and compare it the provided REFIID
	if (iid == IID_IUnknown)
	{
		*ppv = this;
		AddRef();
	}
	else if (iid == IID_IDeckLinkInputCallback)
	{
		*ppv = (IDeckLinkInputCallback*)this;
		AddRef();
	}
	else
	{
		*ppv = nullptr;
		result = E_NOINTERFACE;
	}

	return result;
}

ULONG IDeckLinkScreenPreviewCallbackNS::AddRef(void)
{
	return ++m_refCount;
}

ULONG IDeckLinkScreenPreviewCallbackNS::Release(void)
{
	ULONG newRefValue = --m_refCount;
	
	if (newRefValue == 0)
		delete this;

	return newRefValue;
}

IDeckLinkScreenPreviewCallbackNS::IDeckLinkScreenPreviewCallbackNS(id<NSIDeckLinkScreenPreviewCallback> nsscreenpreviewcallback) {
	_nsscreenpreviewcallback = nsscreenpreviewcallback;
	[_nsscreenpreviewcallback retain];
}

HRESULT IDeckLinkScreenPreviewCallbackNS::DrawFrame(IDeckLinkVideoFrame *theFrame)
{
	NSIDeckLinkVideoFrame *nsframe = [[NSIDeckLinkVideoFrame alloc] initWithIDeckLinkVideoFrame:theFrame];

	if([_nsscreenpreviewcallback drawFrame:nsframe])
	{
		[nsframe release];
		return S_OK;
	}
	else
	{
		[nsframe release];
		return E_FAIL;
	}
}
