#import "NSIDeckLinkVideoFrameAncillary.hh"


@implementation NSIDeckLinkVideoFrameAncillary

+ (NSIDeckLinkVideoFrameAncillary*)videoFrameAncillaryWithIDeckLinkVideoFrameAncillary:(IDeckLinkVideoFrameAncillary*)ancillary 
{
	return [[[NSIDeckLinkVideoFrameAncillary alloc] initWithIDeckLinkVideoFrameAncillary:ancillary] autorelease];
}

- (instancetype)initWithIDeckLinkVideoFrameAncillary:(IDeckLinkVideoFrameAncillary*)ancillary 
{
	if (self = [super initWithIUnknown:ancillary refiid:IID_IDeckLinkVideoFrameAncillary]) {
		_ancillary = ancillary;
	}
	return self;
}

- (BMDPixelFormat)pixelFormat
{
	return _ancillary->GetPixelFormat();
}
- (BMDDisplayMode)displayMode
{
	return _ancillary->GetDisplayMode();
}
- (NSData*)dataForVerticalBlankingLine:(NSInteger)lineNumber
{
	void* data;
	if (_ancillary->GetBufferForVerticalBlankingLine(&data, lineNumber) != S_OK)
		return nil;
	
	//NSInteger dlen = _ancillary->GetBufferForVerticalBlankingLine(NULL, lineNumber);
	return [NSData dataWithBytesNoCopy:data length:0];  // this is not looking good
 }

@end