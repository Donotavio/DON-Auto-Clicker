SRC_ASM=src/autoclick.asm
SRC_C=src/autoclick.c
OBJ_ASM=autoclick.o
OBJ_C=autoclick
EXEC_ASM=autoclick
EXEC_C=autoclick
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

# Function to check and install dependencies on Linux/macOS for Assembly
install_dependencies_linux_asm:
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

# Function to check and install dependencies on Linux/macOS for C
install_dependencies_linux_c:
	@if ! [ -x "$$(command -v gcc)" ]; then \
		echo "GCC is not installed."; \
		$(MAKE) confirm; \
		sudo apt-get install gcc || sudo yum install gcc || brew install gcc; \
	fi
	@if ! [ -x "$$(command -v brew)" ]; then \
		echo "Homebrew is not installed."; \
		$(MAKE) confirm; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@if ! [ -x "$$(command -v cliclick)" ]; then \
		echo "cliclick is not installed (for macOS)."; \
		$(MAKE) confirm; \
		brew install cliclick; \
	fi

# Function to check and install dependencies on Windows (via Chocolatey) for Assembly
install_dependencies_windows_asm:
	@if ! [ -x "$$(command -v nasm)" ]; then \
		echo "NASM is not installed."; \
		$(MAKE) confirm; \
		choco install nasm -y; \
	fi

# Function to check and install dependencies on Windows (via Chocolatey) for C
install_dependencies_windows_c:
	@if ! [ -x "$$(command -v gcc)" ]; then \
		echo "GCC is not installed."; \
		$(MAKE) confirm; \
		choco install mingw -y; \
	fi

# Compilation for Windows (Assembly)
windows_asm: install_dependencies_windows_asm
	nasm -f win32 $(SRC_ASM) -o $(OBJ_ASM)
	ld $(OBJ_ASM) -o $(EXEC_ASM).exe -luser32 -lkernel32

# Compilation for Windows (C)
windows_c: install_dependencies_windows_c
	gcc $(SRC_C) -o $(EXEC_C).exe

# Compilation for Linux/MacOS (Assembly)
linux_asm: install_dependencies_linux_asm
	nasm -f elf32 $(SRC_ASM) -o $(OBJ_ASM)
	ld -m elf_i386 $(OBJ_ASM) -o $(EXEC_ASM)

# Compilation for Linux/MacOS (C)
linux_c: install_dependencies_linux_c
	gcc $(SRC_C) -o $(EXEC_C) -lX11 -lXtst

# Clean up compiled files
clean:
	rm -f $(OBJ_ASM) $(EXEC_ASM) $(EXEC_ASM).exe $(EXEC_C) $(EXEC_C).exe

# Main function to detect the system, install dependencies, and compile automatically for Assembly
all_asm:
	@if [ "$(UNAME_S)" = "Linux" ] || [ "$(UNAME_S)" = "Darwin" ]; then \
		$(MAKE) linux_asm YES=$(YES_FLAG); \
	elif [ "$(UNAME_S)" = "Windows_NT" ]; then \
		$(MAKE) windows_asm YES=$(YES_FLAG); \
	else \
		echo "Unsupported OS: $(UNAME_S)"; \
		exit 1; \
	fi

# Main function to detect the system, install dependencies, and compile automatically for C
all_c:
	@if [ "$(UNAME_S)" = "Linux" ] || [ "$(UNAME_S)" = "Darwin" ]; then \
		$(MAKE) linux_c YES=$(YES_FLAG); \
	elif [ "$(UNAME_S)" = "Windows_NT" ]; then \
		$(MAKE) windows_c YES=$(YES_FLAG); \
	else \
		echo "Unsupported OS: $(UNAME_S)"; \
		exit 1; \
	fi

# Show help information
help:
	@echo "Usage: make [target] [OPTIONS]"
	@echo ""
	@echo "Targets:"
	@echo "  all_asm    Detect system, install dependencies, and compile automatically for Assembly."
	@echo "  all_c      Detect system, install dependencies, and compile automatically for C."
	@echo "  windows_asm Compile for Windows (Assembly)."
	@echo "  windows_c  Compile for Windows (C)."
	@echo "  linux_asm  Compile for Linux/macOS (Assembly)."
	@echo "  linux_c    Compile for Linux/macOS (C)."
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
