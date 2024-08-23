SRC=src/autoclick.asm
OBJ=autoclick.o
EXEC=autoclick

# Compilation for Windows
windows:
	nasm -f win32 $(SRC) -o $(OBJ)
	ld $(OBJ) -o $(EXEC).exe -luser32 -lkernel32

# Compilation for Linux/MacOS
linux:
	nasm -f elf32 $(SRC) -o $(OBJ)
	ld -m elf_i386 $(OBJ) -o $(EXEC)

# Clean up compiled files
clean:
	rm -f $(OBJ) $(EXEC) $(EXEC).exe
