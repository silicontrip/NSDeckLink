#include "DeckLinkAPI.h"
#import "NSIDeckLinkInputCallback.h"


/* Interface IDeckLinkInputCallback - Frame arrival callback. */

class IDeckLinkInputCallbackNS : public IDeckLinkInputCallback
{
	protected:
	~IDeckLinkInputCallback () {
		[_nsinputcallback release];
	} // call Release method to drop reference count
	NSIDeckLinkInputCallback* _nsinputcallback;

public:

	IDeckLinkInputCallback(NSIDeckLinkInputCallback* nsinputcallback) {
		_nsinputcallback = nsinputcallback;
		[_nsinputcallback retain];
	}

	HRESULT VideoInputFormatChanged (/* in */ BMDVideoInputFormatChangedEvents notificationEvents, /* in */ IDeckLinkDisplayMode* newDisplayMode, /* in */ BMDDetectedVideoInputFormatFlags detectedSignalFlags)
	{
		NSIDeckLinkDisplayMode* dldm = [NSIDeckLinkDisplayMode displayModeWithIDeckLinkDisplayMode:newDisplayMode];
		if ([_nsinputcallback videoInputFormatChangedEvent:notificationEvents displayMode:dldm signalFlags:detectedSignalFlags])
			return S_OK;
		return E_FAIL;
	}

	HRESULT VideoInputFrameArrived (/* in */ IDeckLinkVideoInputFrame* videoFrame, /* in */ IDeckLinkAudioInputPacket* audioPacket)
	{
		NSIDeckLinkVideoInputFrame* dlvif = [NSIDeckLinkVideoInputFrame videoInputFrameWithIDeckLinkVideoInputFrame:videoFrame];
		NSIDeckLinkAudioInputPacket* dlaip = [NSIDeckLinkAudioInputPacket audioPacketWithIDeckLinkAudioInputPacket:audioPacket];

		if ([_nsinputcallback videoInputFrameArrived:dlvif audio:dlaip])
			return S_OK;
		return E_FAIL;
	}

};