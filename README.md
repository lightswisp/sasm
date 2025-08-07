# sasm

Small assembly language interpreter written in Ruby. Supports registers, labels, conditional jumps, arithmetic operations, and basic I/O.

## Features
- Register-based operations
- Labels and function calls (`call`, `ret`)
- Stack operations (`push`, `pop`)
- Conditional jumps based on comparisons
- Basic arithmetic and output

## Supported Instructions

### Data Movement
| Instruction | Operands       | Description                          |
|-------------|----------------|--------------------------------------|
| `mov`       | `reg, imm/reg` | Move immediate value or register value to destination register |
| `push`      | `imm/reg`      | Push value onto stack                |
| `pop`       | `reg`          | Pop value from stack into register   |

### Arithmetic Operations
| Instruction | Operands       | Description                          |
|-------------|----------------|--------------------------------------|
| `inc`       | `reg`          | Increment register by 1             |
| `dec`       | `reg`          | Decrement register by 1             |
| `add`       | `reg, imm/reg` | Add source to destination register   |
| `sub`       | `reg, imm/reg` | Subtract source from destination register |
| `mul`       | `reg, imm/reg` | Multiply register by source          |
| `div`       | `reg, imm/reg` | Divide register by source            |

### Control Flow
| Instruction | Operands       | Description                          |
|-------------|----------------|--------------------------------------|
| `call`      | `label`        | Call subroutine at label             |
| `ret`       |                | Return from subroutine               |
| `end`       |                | Terminate program                    |

### Comparison and Jumps
| Instruction | Operands       | Description                          |
|-------------|----------------|--------------------------------------|
| `cmp`       | `reg, imm/reg` | Compare values and set flags         |
| `je`        | `label`        | Jump if equal (flags == 0)           |
| `jne`       | `label`        | Jump if not equal (flags != 0)       |
| `jg`        | `label`        | Jump if greater (flags > 0)          |
| `jge`       | `label`        | Jump if greater or equal (flags >= 0)|
| `jl`        | `label`        | Jump if less (flags < 0)             |
| `jle`       | `label`        | Jump if less or equal (flags <= 0)   |

### I/O
| Instruction | Operands       | Description                          |
|-------------|----------------|--------------------------------------|
| `msg`       | `str, reg...`  | Output string and register values    |

## Usage

1. Save your assembly code in a file (e.g., `program.asm`)
2. Run the interpreter:
   ```bash
   ruby interpreter.rb program.asm
