#import "NSIDeckLinkVideoFrame.hh"

@implementation NSIDeckLinkVideoFrame

+ (NSIDeckLinkVideoFrame*)videoFrameWithIDeckLinkVideoFrame:(IDeckLinkVideoFrame*)frame
{
	return [[[NSIDeckLinkVideoFrame alloc] initWithIDeckLinkVideoFrame:frame] autorelease];
}

- (instancetype)initWithIDeckLinkVideoFrame:(IDeckLinkVideoFrame*)frame
{

	if (self = [super initWithIUnknown:frame refiid:IID_IDeckLinkVideoFrame])
	{
		_videoframe = frame;
	}
	return self;
}

- (NSInteger)rowBytes
{
	return _videoframe->GetRowBytes();
}

- (NSInteger)width
{
	return _videoframe->GetWidth();
}

- (NSInteger)height
{
	return _videoframe->GetHeight();
}

- (BMDFrameFlags)flags
{
	return _videoframe->GetFlags();
}

- (BMDPixelFormat)pixelFormat
{
	return _videoframe->GetPixelFormat();
}

- (NSData*)bytes
{
	void* frameBytes;
	if (_videoframe->GetBytes(&frameBytes) != S_OK)
		return nil;
	
	return [NSData dataWithBytesNoCopy:frameBytes length:_videoframe->GetRowBytes() * _videoframe->GetHeight()];
}

- (NSIDeckLinkTimecode*)timecodeFormat:(BMDTimecodeFormat)format
{
	IDeckLinkTimecode* timecode = NULL;
	
	if (_videoframe->GetTimecode(format, &timecode) != S_OK)
		return nil;
	
	return [NSIDeckLinkTimecode timecodeWithIDeckLinkTimecode:timecode];
}

- (NSIDeckLinkVideoFrameAncillary*)ancillaryData
{
	IDeckLinkVideoFrameAncillary* ancillary = NULL;
	
	if (_videoframe->GetAncillaryData(&ancillary) != S_OK)
		return nil;
	
	return [NSIDeckLinkVideoFrameAncillary videoFrameAncillaryWithIDeckLinkVideoFrameAncillary:ancillary];
}

@end