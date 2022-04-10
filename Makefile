
CFLAGS=-I../include/ -I/usr/local/include -g
LDFLAGS=-F/Library/Frameworks -framework Foundation -framework DeckLinkAPI
CC=g++

OBJS=IDeckLinkInputCallbackNS.o IDeckLinkScreenPreviewCallbackNS.o NSIDeckLink.o NSIDeckLinkAudioInputPacket.o NSIDeckLinkConfiguration.o NSIDeckLinkDisplayMode.o NSIDeckLinkDisplayModeIterator.o NSIDeckLinkInput.o NSIDeckLinkIterator.o NSIDeckLinkProfileAttributes.o NSIDeckLinkTimecode.o NSIDeckLinkVideoFrame.o NSIDeckLinkVideoFrameAncillary.o NSIDeckLinkVideoInputFrame.o NSIUnknown.o

%.air:%.metal
	metal -c $< -o $@

%.metallib:%.air
	metallib $< -o $@

%.o:%.m
	$(CC) $(CFLAGS) -c $^

%.o:%.mm
	$(CC) -g $(CFLAGS) -c $^

all: test

test: test.o $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS)  -o $@ $^
