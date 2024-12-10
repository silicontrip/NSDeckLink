//
//  NSDeckLink.h
//  NSDeckLink
//
//  Created by Mark Heath on 11/4/22.
//

#import <Foundation/Foundation.h>

/*
typedef uint32_t BMDAudioSampleRate;
typedef uint32_t BMDAudioSampleType;
typedef uint32_t BMDDeckLinkAttributeID;
typedef uint32_t BMDDeckLinkConfigurationID;
typedef uint32_t BMDDetectedVideoInputFormatFlags;
typedef uint32_t BMDDisplayMode;
typedef uint32_t BMDDisplayModeFlags;
typedef uint32_t BMDDisplayModeSupport;
typedef uint32_t BMDFieldDominance;
typedef uint32_t BMDFrameFlags;
typedef uint32_t BMDPixelFormat;
typedef uint32_t BMDSupportedVideoModeFlags;
typedef uint32_t BMDTimecodeBCD;
typedef uint32_t BMDTimecodeFlags;
typedef uint32_t BMDTimecodeFormat;
typedef uint32_t BMDTimecodeUserBits;
typedef int64_t BMDTimeValue;
typedef int64_t BMDTimeScale;
typedef uint32_t BMDVideoConnection;
typedef uint32_t BMDVideoInputFlags;
typedef uint32_t BMDVideoInputFormatChangedEvents;
typedef uint32_t BMDVideoInputFormatChangedEvents;
*/

//! Project version number for NSDeckLink.
FOUNDATION_EXPORT double NSDeckLinkVersionNumber;

//! Project version string for NSDeckLink.
FOUNDATION_EXPORT const unsigned char NSDeckLinkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <NSDeckLink/PublicHeader.h>

#import <NSDeckLink/NSIUnknown.h>
#import <NSDeckLink/NSIDeckLink.h>
#import <NSDeckLink/NSIDeckLinkAudioInputPacket.h>
#import <NSDeckLink/NSIDeckLinkConfiguration.h>
#import <NSDeckLink/NSIDeckLinkDisplayMode.h>
#import <NSDeckLink/NSIDeckLinkDisplayModeIterator.h>
#import <NSDeckLink/NSIDeckLinkInput.h>
#import <NSDeckLink/NSIDeckLinkInputCallback.h>
#import <NSDeckLink/NSIDeckLinkIterator.h>
#import <NSDeckLink/NSIDeckLinkProfileAttributes.h>
#import <NSDeckLink/NSIDeckLinkScreenPreviewCallback.h>
#import <NSDeckLink/NSIDeckLinkTimecode.h>
#import <NSDeckLink/NSIDeckLinkVideoFrame.h>
#import <NSDeckLink/NSIDeckLinkVideoFrameAncillary.h>
#import <NSDeckLink/NSIDeckLinkVideoInputFrame.h>
