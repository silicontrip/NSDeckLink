#import <Foundation/Foundation.h>
#import <DeckLinkAPI/DeckLinkAPI.h>
#import "NSIUnknown.hh"
#import "NSIDeckLinkInputCallback.h"
#import "NSIDeckLinkDisplayMode.hh"
#import "NSIDeckLinkVideoInputFrame.hh"
#import "NSIDeckLinkAudioInputPacket.hh"


class IDeckLinkInputCallbackNS : public IDeckLinkInputCallback
{
	private:
	id	<NSIDeckLinkInputCallback> _inputcallback;
	//id _nsinputcallback;

	protected:
	int32_t m_refCount;

	// static const REFIID IID_IUnknown = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };

	~IDeckLinkInputCallbackNS ();
	
	public:
	IDeckLinkInputCallbackNS(id<NSIDeckLinkInputCallback> nsinputcallback);
	HRESULT VideoInputFormatChanged (/* in */ BMDVideoInputFormatChangedEvents notificationEvents, /* in */ IDeckLinkDisplayMode* newDisplayMode, /* in */ BMDDetectedVideoInputFormatFlags detectedSignalFlags);
	HRESULT VideoInputFrameArrived (/* in */ IDeckLinkVideoInputFrame* videoFrame, /* in */ IDeckLinkAudioInputPacket* audioPacket);

	HRESULT QueryInterface(REFIID iid, LPVOID *ppv);
	ULONG AddRef(void);
	ULONG Release(void);

};
