# Set the name of your binary output file
BINARY_NAME=openai-cli

# Set the location of your source code files
SRC_LOCATION=./src/main

# Set the location of your build output directory
BUILD_LOCATION=./bin

# Set the flags to pass to the Go compiler
GO_FLAGS=-v

# Set the flags to pass to the linker
LINKER_FLAGS=-ldflags="-s -w"

# Set the platform-specific GOOS and GOARCH values for different platforms
WINDOWS_GOOS=windows
WINDOWS_GOARCH=amd64

LINUX_GOOS=linux
LINUX_GOARCH=amd64

MAC_NATIVE_GOOS=darwin
MAC_NATIVE_GOARCH=amd64

# Set the platform-specific extension for the binary output file
WINDOWS_EXT=.exe
LINUX_EXT=
MAC_EXT=

# Set the list of targets for each platform
WINDOWS_TARGET=$(BINARY_NAME)$(WINDOWS_EXT)
LINUX_TARGET=$(BINARY_NAME)$(LINUX_EXT)
MAC_TARGET=$(BINARY_NAME)$(MAC_EXT)

# Set the build command for each platform
WINDOWS_BUILD_CMD=GOOS=$(WINDOWS_GOOS) GOARCH=$(WINDOWS_GOARCH) go build $(GO_FLAGS) $(LINKER_FLAGS) -o $(BUILD_LOCATION)/$(WINDOWS_TARGET) $(SRC_LOCATION)
LINUX_BUILD_CMD=GOOS=$(LINUX_GOOS) GOARCH=$(LINUX_GOARCH) go build $(GO_FLAGS) $(LINKER_FLAGS) -o $(BUILD_LOCATION)/$(LINUX_TARGET) $(SRC_LOCATION)
MAC_NATIVE_BUILD_CMD=GOOS=$(MAC_NATIVE_GOOS) GOARCH=$(MAC_NATIVE_GOARCH) go build $(GO_FLAGS) $(LINKER_FLAGS) -o $(BUILD_LOCATION)/$(MAC_TARGET) $(SRC_LOCATION)

# Define the default target, which will build for the current platform
.DEFAULT_GOAL := $(OS_TARGET)

# Define the build targets
windows: $(WINDOWS_TARGET)
linux: $(LINUX_TARGET)
macos: $(MAC_TARGET)

# Default how to build the targets
$(WINDOWS_TARGET):
	$(WINDOWS_BUILD_CMD)

$(LINUX_TARGET):
	$(LINUX_BUILD_CMD)

$(MAC_TARGET):
	$(MAC_NATIVE_BUILD_CMD)

