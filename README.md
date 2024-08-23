# Auto Clicker in Assembly

This project provides a multi-platform auto clicker written in Assembly language. The clicker can be configured to run for a specific duration or indefinitely and allows the user to set the number of clicks per minute.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Features
- Configurable duration (in seconds or infinite)
- Configurable click rate (clicks per minute)
- Multi-platform support: Windows, Linux, and macOS

## Requirements
- NASM (Netwide Assembler)
- LD (Linker)
- xdotool (for Linux/MacOS)

## Compilation and Execution

### Windows
```bash
nasm -f win32 src/autoclick.asm -o autoclick.obj
ld autoclick.obj -o autoclick.exe -luser32 -lkernel32
autoclick.exe
```

### Linux/MacOS
````bash
nasm -f elf32 src/autoclick.asm -o autoclick.o
ld -m elf_i386 autoclick.o -o autoclick
./autoclick
````

## Contributing
Feel free to contribute by opening issues or submitting pull requests.
