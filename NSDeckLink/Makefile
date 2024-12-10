# Compiler settings
CFLAGS=-I../../include -O2 -fmodules -fmodule-map-file=module.modulemap
CC=/usr/local/Cellar/llvm/19.1.4/bin/clang++
LFLAGS=-framework foundation -F /Library/Frameworks -framework DeckLinkAPI \
        -install_name @rpath/NSDeckLink.framework/NSDeckLink

# Object files
OBJ=IDeckLinkInputCallbackNS.o IDeckLinkScreenPreviewCallbackNS.o NSIDeckLink.o \
    NSIDeckLinkAudioInputPacket.o NSIDeckLinkConfiguration.o NSIDeckLinkDisplayMode.o \
    NSIDeckLinkDisplayModeIterator.o NSIDeckLinkInput.o NSIDeckLinkIterator.o \
    NSIDeckLinkProfileAttributes.o NSIDeckLinkTimecode.o NSIDeckLinkVideoFrame.o \
    NSIDeckLinkVideoFrameAncillary.o NSIDeckLinkVideoInputFrame.o NSIUnknown.o

# Output settings
FRAMEWORK_NAME=NSDeckLink
MODULEMAP=module.modulemap
FRAMEWORK_DIR=build/$(FRAMEWORK_NAME).framework
LIBRARY=$(FRAMEWORK_DIR)/Versions/A/$(FRAMEWORK_NAME)
HEADERS_DIR=$(FRAMEWORK_DIR)/Versions/A/Headers
RESOURCES_DIR=$(FRAMEWORK_DIR)/Versions/A/Resources
MODULE_DIR=$(FRAMEWORK_DIR)/Versions/A/Modules

# Public headers
HEADERS=NSIDeckLink.h \
        NSIDeckLinkAudioInputPacket.h NSIDeckLinkConfiguration.h NSIDeckLinkDisplayMode.h \
        NSIDeckLinkDisplayModeIterator.h NSIDeckLinkInput.h NSIDeckLinkIterator.h \
        NSIDeckLinkProfileAttributes.h NSIDeckLinkTimecode.h NSIDeckLinkVideoFrame.h \
        NSIDeckLinkVideoFrameAncillary.h NSIDeckLinkVideoInputFrame.h NSIUnknown.h

# Targets
all: $(FRAMEWORK_DIR)

$(FRAMEWORK_DIR): NSDeckLink
	@echo "Creating framework directory structure..."
	mkdir -p $(HEADERS_DIR)
	mkdir -p $(RESOURCES_DIR)
	mkdir -p $(MODULE_DIR)
	@echo "Copying library..."
	cp NSDeckLink $(LIBRARY)
	@echo "Copying headers..."
	cp $(HEADERS) $(HEADERS_DIR)
	@echo "Copying modulemap"
	cp $(MODULEMAP) $(MODULE_DIR)
	@echo "Creating symbolic links..."
	cd $(FRAMEWORK_DIR) && \
		ln -sf Versions/Current/NSDeckLink NSDeckLink && \
		rm -f Headers && ln -sf Versions/Current/Headers Headers && \
		rm -f Resources && ln -sf Versions/Current/Resources Resources && \
		rm -f Modules && ln -sf Versions/Current/Modules Modules && \
		cd Versions && \
		rm -f Current && ln -sf A Current

NSDeckLink: $(OBJ)
	@echo "Linking dynamic library..."
	$(CC) $(LFLAGS) -dynamiclib -o NSDeckLink $(OBJ)

%.o: %.mm
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "Cleaning up build files..."
	rm -rf build NSDeckLink $(OBJ)

.PHONY: all clean
