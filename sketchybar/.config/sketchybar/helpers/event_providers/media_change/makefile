SDK := $(shell xcrun --sdk macosx --show-sdk-path)
CC = clang
CFLAGS = -fobjc-arc -arch arm64 -isysroot $(SDK)
FRAMEWORKS = -framework Foundation -framework AppKit
TARGET = bin/media_change
SRCS = media_change.m

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) $(FRAMEWORKS) -o $(TARGET)

