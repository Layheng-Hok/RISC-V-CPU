<div align=center>

# RISC-V CPU

Single Cycle Processor for RISC-V ISA Built in Verilog

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
│       │   │       └── const.xdc
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
