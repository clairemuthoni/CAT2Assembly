# CAT2 Assembly Project

This repository contains assembly code for four tasks, organized into the following files:

## Files Overview

### Assembly Source Files
- **`question_1.asm`**: Contains the assembly code for the first task.
- **`question_2.asm`**: Contains the assembly code for the second task.
- **`question_3.asm`**: Contains the assembly code for the third task.
- **`question_4.asm`**: Contains the assembly code for the fourth task.

### Object Files
- Compiled versions of the source files (`*.o`) for tasks 1 to 4:
  - `question_1.o`
  - `question_2.o`
  - `question_3.o`
  - `question_4.o`

### Additional Notes
- **`question_4_explained.txt`**: Provides an explanation for the logic or design of `question_4.asm`.
- **`register_management.txt`**: Discusses strategies for efficient register usage within the project.

### Folders
Each question also has a dedicated folder (`question_1`, `question_2`, `question_3`, `question_4`), possibly for organizing associated resources or testing files.

---

## Usage Instructions

### Prerequisites
Ensure you have an assembler and linker installed on your system. Popular options include:
- **NASM**: For x86 architecture assembly.
- **GAS**: The GNU Assembler, part of the GNU Binutils package.

### Compilation
To compile an assembly file, use the following command:
```bash
nasm -f elf64 -o question_1.o question_1.asm
