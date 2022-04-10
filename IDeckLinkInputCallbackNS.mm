#import "IDeckLinkInputCallbackNS.hh"

/* Interface IDeckLinkInputCallback - Frame arrival callback. */


IDeckLinkInputCallbackNS::~IDeckLinkInputCallbackNS () 
{
//	NSLog(@"class: %@",[_nsinputcallback class]);

	[_inputcallback release];
	//[_nsinputcallback retain];

} // call Release method to drop reference count

// IUnknown methods

HRESULT IDeckLinkInputCallbackNS::QueryInterface(REFIID iid, LPVOID *ppv)
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

ULONG IDeckLinkInputCallbackNS::AddRef(void)
{
	return ++m_refCount;
}

ULONG IDeckLinkInputCallbackNS::Release(void)
{
	ULONG newRefValue = --m_refCount;
	
	if (newRefValue == 0)
		delete this;

	return newRefValue;
}

IDeckLinkInputCallbackNS::IDeckLinkInputCallbackNS(id<NSIDeckLinkInputCallback> nsinputcallback) {
	_inputcallback = nsinputcallback;
	[_inputcallback retain];
}

HRESULT IDeckLinkInputCallbackNS::VideoInputFormatChanged (/* in */ BMDVideoInputFormatChangedEvents notificationEvents, /* in */ IDeckLinkDisplayMode* newDisplayMode, /* in */ BMDDetectedVideoInputFormatFlags detectedSignalFlags)
{
	NSIDeckLinkDisplayMode* dldm = [NSIDeckLinkDisplayMode displayModeWithIDeckLinkDisplayMode:newDisplayMode];
	if ([_inputcallback videoInputFormatChangedEvent:notificationEvents displayMode:dldm signalFlags:detectedSignalFlags])
		return S_OK;
	return E_FAIL;
}

HRESULT IDeckLinkInputCallbackNS::VideoInputFrameArrived (/* in */ IDeckLinkVideoInputFrame* videoFrame, /* in */ IDeckLinkAudioInputPacket* audioPacket)
{
	NSIDeckLinkVideoInputFrame* dlvif = [NSIDeckLinkVideoInputFrame videoInputFrameWithIDeckLinkVideoInputFrame:videoFrame];
	NSIDeckLinkAudioInputPacket* dlaip = [NSIDeckLinkAudioInputPacket audioInputPacketWithIDeckLinkAudioInputPacket:audioPacket];

	if ([_inputcallback videoInputFrameArrived:dlvif audio:dlaip])
		return S_OK;
	return E_FAIL;
}

