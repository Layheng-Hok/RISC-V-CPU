<div align=center>

# RISC-V CPU

Single-Cycle Processor for RISC-V ISA Built in Verilog

SUSTech 2024 Spring's Project of Course `CS202 - Computer Organization` Led By Professor [Jin ZHANG](https://jinzhang-sustech.github.io/)

<div align="center">
    <img src="./project_info/resources/risc-v-cpu.png" alt="risc-v cpu">
</div>

</div>

## Project Directory
```
RISC-V CPU
├── assembly_test-risc_v
│   ├── scenario1.asm                                  # assembly code for testing scenario 1
│   ├── scenario1_hex.coe                              # assembly code for testing scenario 1 in hex
│   ├── scenario2.asm                                  # assembly code for testing scenario 2
│   └── scenario2_hex.coe                              # assembly code for testing scenario 2 in hex                              
├── cpu-verilog
│   └── Final_CPU
│       ├── Final_CPU.cache
│       ├── Final_CPU.hw
│       ├── Final_CPU.ip_user_files
│       ├── Final_CPU.runs
│       ├── Final_CPU.sim
│       ├── Final_CPU.srcs
│       │   ├── constrs_1
│       │   │   └── new
│       │   │       └── const.xdc                      # constraint file
│       │   ├── sim_1
│       │   └── sources_1
│       │       ├── ip
│       │       │   ├── RAM
│       │       │   │   ├── dmem32word.coe             # word-addressable data mem
│       │       │   ├── cpu_clk
│       │       │   │   ├── cpu_clk.v
│       │       │   └── prgrom
│       │       │       ├── scenario1.coe              # inst mem for testing scenario 1
│       │       │       ├── scenario2.coe              # inst mem for testing scenario 2
│       │       └── new                                # cpu implementation code
│       │           ├── ALU.v
│       │           ├── CPU.v
│       │           ├── Clock.v
│       │           ├── Controller.v
│       │           ├── DataMem.v
│       │           ├── Decoder.v
│       │           ├── IFetch.v
│       │           ├── IOReader.v
│       │           ├── Led.v
│       │           ├── MemOrIO.v
│       │           ├── Switch.v
│       │           ├── Tube.v
│       │           └── clock_divider.v
│       ├── Final_CPU.xpr                              # main vivado project file
├── project_info
└── README.md
```
*Note*: This is a simplified project directory tree. The detailed directory tree can be found [here](./project_info/directory-tree.txt).

## CPU Architecture Design
### Basic CPU Info
- `Clock Frequency` 23Mhz
- `CPI` 1
- `Structure` Havard Architecture
- `Addressing Unit` 32 bits for data read and write
- `Size of Instruction Space and Data Space` 64 KB (2^14 * 4 bytes)
- `Base Address of Stack Space` 0x7fffeffc
- `Registers Info` 32 registers with each has a bit width of 32 bits

### CPU Datapath
<div align="center">
    <img src="./project_info/resources/cpu-datapath.png" alt="risc-v cpu">
</div>

### Supported RISC-V Instructions
#### R-type Instructions
| Instruction | Encoding              | Usage Method                |
|-------------|-----------------------|-----------------------------|
| ADD         | 7'b0110011 + funct3:000 + funct7:0000000 | `add rd, rs1, rs2`          |
| SUB         | 7'b0110011 + funct3:000 + funct7:0100000 | `sub rd, rs1, rs2`          |
| AND         | 7'b0110011 + funct3:111 + funct7:0000000 | `and rd, rs1, rs2`          |
| OR          | 7'b0110011 + funct3:110 + funct7:0000000 | `or rd, rs1, rs2`           |
| SLL         | 7'b0110011 + funct3:001 + funct7:0000000 | `sll rd, rs1, rs2`          |
| SRA         | 7'b0110011 + funct3:101 + funct7:0100000 | `sra rd, rs1, rs2`          |

#### I-type Instructions
| Instruction | Encoding              | Usage Method                |
|-------------|-----------------------|-----------------------------|
| ADDI        | 7'b0010011 + funct3:000 | `addi rd, rs1, imm`         |
| ANDI        | 7'b0010011 + funct3:111 | `andi rd, rs1, imm`         |
| ORI         | 7'b0010011 + funct3:110 | `ori rd, rs1, imm`          |
| XORI        | 7'b0010011 + funct3:100 | `xori rd, rs1, imm`         |
| SRLI        | 7'b0010011 + funct3:101 + funct7:0000000 | `srli rd, rs1, imm`         |
| LW          | 7'b0000011 + funct3:010 | `lw rd, offset(rs1)`        |
| LB          | 7'b0000011 + funct3:000 | `lb rd, offset(rs1)`        |
| LBU         | 7'b0000011 + funct3:100 | `lbu rd, offset(rs1)`       |

#### S-type Instructions
| Instruction | Encoding              | Usage Method                |
|-------------|-----------------------|-----------------------------|
| SW          | 7'b0100011 + funct3:010 | `sw rs2, offset(rs1)`       |

#### B-type Instructions
| Instruction | Encoding              | Usage Method                |
|-------------|-----------------------|-----------------------------|
| BEQ         | 7'b1100011 + funct3:000 | `beq rs1, rs2, offset`      |
| BNE         | 7'b1100011 + funct3:001 | `bne rs1, rs2, offset`      |
| BLT         | 7'b1100011 + funct3:100 | `blt rs1, rs2, offset`      |
| BGE         | 7'b1100011 + funct3:101 | `bge rs1, rs2, offset`      |
| BLTU        | 7'b1100011 + funct3:110 | `bltu rs1, rs2, offset`     |
| BGEU        | 7'b1100011 + funct3:111 | `bgeu rs1, rs2, offset`     |

#### J-type Instructions
| Instruction | Encoding              | Usage Method                |
|-------------|-----------------------|-----------------------------|
| JAL         | 7'b1101111            | `jal rd, offset`            |

#### U-type Instructions
| Instruction | Encoding              | Usage Method                |
|-------------|-----------------------|-----------------------------|
| LUI         | 7'b0110111            | `lui rd, imm`               |

## Contribution
| Contributor | CPU Design & Implementation | Assembly Code (RISC-V) | Report |
| --- |:---:|:---:|:---:|
| [Jaouhara ZERHOUNI KHAL](https://github.com/Jouwy) | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| [Layheng HOK](https://github.com/Layheng-Hok) | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| [Harrold TOK Kwan Hang](https://github.com/Barracudapi) | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark:|
