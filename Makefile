SRC=src/autoclick.asm
OBJ=autoclick.o
EXEC=autoclick
YES_FLAG := $(YES)

# Determine the operating system
UNAME_S := $(shell uname -s)

# Check for user confirmation unless the YES variable is set
confirm:
	@if [ "$(YES_FLAG)" = "yes" ]; then \
		echo "Auto-confirming all prompts."; \
	else \
		echo "Are you sure you want to proceed? (y/n)"; \
		read answer; \
		if [ "$$answer" != "y" ]; then \
			echo "Aborting."; \
			exit 1; \
		fi; \
	fi

# Function to check and install dependencies on Linux/macOS
install_dependencies_linux:
	@if ! [ -x "$$(command -v nasm)" ]; then \
		echo "NASM is not installed."; \
		$(MAKE) confirm; \
		sudo apt-get install nasm || sudo yum install nasm || brew install nasm; \
	fi
	@if ! [ -x "$$(command -v xdotool)" ]; then \
		echo "xdotool is not installed."; \
		$(MAKE) confirm; \
		sudo apt-get install xdotool || brew install xdotool; \
	fi

# Function to check and install dependencies on Windows (via Chocolatey)
install_dependencies_windows:
	@if ! [ -x "$$(command -v nasm)" ]; then \
		echo "NASM is not installed."; \
		$(MAKE) confirm; \
		choco install nasm -y; \
	fi

# Compilation for Windows
windows: install_dependencies_windows
	nasm -f win32 $(SRC) -o $(OBJ)
	ld $(OBJ) -o $(EXEC).exe -luser32 -lkernel32

# Compilation for Linux/MacOS
linux: install_dependencies_linux
	nasm -f elf32 $(SRC) -o $(OBJ)
	ld -m elf_i386 $(OBJ) -o $(EXEC)

# Clean up compiled files
clean:
	rm -f $(OBJ) $(EXEC) $(EXEC).exe

# Main function to detect the system, install dependencies, and compile automatically
all:
	@if [ "$(UNAME_S)" = "Linux" ] || [ "$(UNAME_S)" = "Darwin" ]; then \
		$(MAKE) linux YES=$(YES_FLAG); \
	elif [ "$(UNAME_S)" = "Windows_NT" ]; then \
		$(MAKE) windows YES=$(YES_FLAG); \
	else \
		echo "Unsupported OS: $(UNAME_S)"; \
		exit 1; \
	fi

# Show help information
help:
	@echo "Usage: make [target] [OPTIONS]"
	@echo ""
	@echo "Targets:"
	@echo "  all        Detect system, install dependencies, and compile automatically."
	@echo "  windows    Compile for Windows."
	@echo "  linux      Compile for Linux/macOS."
	@echo "  clean      Clean up compiled files."
	@echo "  help       Show this help message."
	@echo ""
	@echo "Options:"
	@echo "  YES=yes    Auto-confirm all prompts."
	@echo "  -h, --help Show help information."

# Check for options
check_options:
	@if [ "$(filter -h,$(MAKECMDGOALS))" ] || [ "$(filter --help,$(MAKECMDGOALS))" ]; then \
		$(MAKE) help; \
		exit 0; \
	fi

# Include check_options in every command
%: check_options
	@:
