# 🖱️ Auto Clicker in Assembly

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: Windows/Linux/macOS](https://img.shields.io/badge/Platform-Windows%2FLinux%2FmacOS-lightgrey.svg)](#)

## 🚀 Overview

Welcome to **Auto Clicker in Assembly**, a lightweight and super fast auto clicker built entirely in Assembly language! This project is designed for those who appreciate low-level programming and want to explore the power of Assembly while automating repetitive mouse-clicking tasks.

### ✨ Features

- **Multi-Platform Support**: Runs smoothly on Windows, Linux, and macOS.
- **User Configurable**: Define the duration, click rate (per minute or per second), and whether to run indefinitely.
- **Lightweight**: Written in Assembly, offering minimal overhead and maximum performance.
- **Open Source**: Released under the MIT License, so you can freely use, modify, and distribute the code.

## 💡 When to Use This Auto Clicker

The Auto Clicker in Assembly can be particularly useful in the following scenarios:

- **Automated Testing**: When you need to simulate mouse clicks at specific intervals to test UI elements or software behavior.
- **Repetitive Tasks**: For automating repetitive clicking tasks in games, data entry applications, or any software that requires frequent mouse clicks.
- **Stress Testing**: Use it to stress test software or hardware by simulating a high volume of clicks over a set period.
- **Assisting with Accessibility**: Automate clicks for users who may have difficulty performing repetitive mouse actions.
- **Learning and Experimentation**: Great for developers and learners interested in exploring low-level programming with Assembly and understanding how to manipulate mouse input programmatically.

Please use this tool responsibly and ensure that your use cases comply with any terms of service, licensing agreements, or ethical guidelines related to the software or environment where it will be deployed.

## 🛠️ Installation & Setup

### Requirements

To get started, you'll need the following tools installed:

- **NASM**: The Netwide Assembler, for compiling Assembly code.
- **LD**: A linker for creating executables.
- **xdotool** (for Linux/macOS): A command-line tool for simulating keyboard and mouse input.

### Compilation Instructions

#### Automatic Setup & Compilation

You can automatically detect your operating system, install dependencies, and compile the project with a single command:

```bash
make all
```

**Options**:
- `-y`, `--yes`: Automatically confirm all prompts during dependency installation.
- `-h`, `--help`: Display help information.

For example, to run the setup and compilation with automatic confirmation of prompts:

```bash
make all -y
```

#### Manual Compilation by Platform

If you prefer to manually compile the project for a specific platform:

**Windows**:
1. **Compile and link**:
    ```bash
    make windows
    ```
    or with automatic confirmation:
    ```bash
    make windows -y
    ```

**Linux/macOS**:
1. **Compile and link**:
    ```bash
    make linux
    ```
    or with automatic confirmation:
    ```bash
    make linux -y
    ```

#### Cleaning Up

To remove compiled files and reset the environment:

```bash
make clean
```

## 🎮 Usage

Upon running the program, you will be prompted to enter the following parameters:

1. **Duration**: Enter the number of seconds you want the auto clicker to run. Enter `0` to run indefinitely.
2. **Clicks Per Minute**: Specify how many clicks per minute you want. For example, enter `60` for 1 click per second.

### Example Scenarios

- **Run for 10 seconds with 60 clicks per minute**:
    - Duration: `10`
    - Clicks Per Minute: `60`

- **Run indefinitely with 120 clicks per minute (2 clicks per second)**:
    - Duration: `0`
    - Clicks Per Minute: `120`

## 🧩 Contributing

We welcome contributions from the community! Whether it's fixing a bug, adding a new feature, or improving documentation, your help is appreciated.

### Contribution Guidelines

1. **Fork the repository** on GitHub.
2. **Create a new branch**:
    ```bash
    git checkout -b feature-name
    ```
3. **Make your changes** and **commit** them using Conventional Commits:
    ```bash
    git commit -m "feat: add new click rate option"
    ```
    **Why Conventional Commits?**  
    Conventional Commits are important because they provide a consistent way of writing commit messages. This consistency helps in generating changelogs, automating versioning, and maintaining a clean project history. Following this convention is necessary for your contributions to be approved and merged.

    Some examples of Conventional Commits:
    - `feat: add option for infinite clicking`
    - `fix: correct calculation of click interval`
    - `docs: update README with new usage instructions`
4. **Push to your branch**:
    ```bash
    git push origin feature-name
    ```
5. **Create a Pull Request** on GitHub.

### Reporting Issues

If you encounter any issues or bugs, please [open an issue](https://github.com/yourusername/auto-clicker-assembly/issues) on GitHub. Be sure to include details such as your operating system, the steps to reproduce the issue, and any error messages.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💬 Join the Community

If you have any questions, suggestions, or just want to chat about Assembly programming, join the discussion on our [GitHub Discussions](https://github.com/yourusername/auto-clicker-assembly/discussions) page!
