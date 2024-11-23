# CAT2 Assembly Project

This repository contains assembly code for four tasks, each addressing a specific problem or functionality. The project highlights fundamental principles of low-level programming and efficient CPU resource management.

---

## Files Overview

### Assembly Source Files
- **`question_1.asm`**: 
  - **Purpose**: Implements basic arithmetic operations, showcasing register management and operation sequencing.
  - **Challenges**: Balancing register use while avoiding overwriting intermediate results.
- **`question_2.asm`**: 
  - **Purpose**: Solves a more complex computation problem using loops and conditionals.
  - **Challenges**: Managing loop counters and ensuring correct branching logic.
- **`question_3.asm`**: 
  - **Purpose**: Performs data manipulation and storage tasks, including memory access and storage operations.
  - **Challenges**: Ensuring memory alignment and handling potential access violations.
- **`question_4.asm`**: 
  - **Purpose**: Implements a real-world scenario requiring advanced logic and register coordination.
  - **Challenges**: Optimizing execution time while maintaining clarity and correctness.

### Additional Files
- **Compiled Object Files (`*.o`)**: Pre-compiled versions of the source code.
- **`question_4_explained.txt`**: Detailed explanation of the logic in `question_4.asm`.
- **`register_management.txt`**: Insights into efficient register usage in assembly.

---

## Usage Instructions

### Prerequisites
1. Install an assembler and linker (e.g., **NASM** or **GAS**).
2. Ensure a terminal or shell environment (Linux/WSL recommended) is set up for compiling and executing assembly programs.

### Compilation
To compile any `.asm` file, use the following command:
```bash
nasm -f elf64 -o <output-file>.o <input-file>.asm
