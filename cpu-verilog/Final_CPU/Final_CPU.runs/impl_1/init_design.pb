
o
Command: %s
53*	vivadotcl2>
*link_design -top CPU -part xc7a35tcsg324-12default:defaultZ4-113h px� 
g
#Design is defaulting to srcset: %s
437*	planAhead2
	sources_12default:defaultZ12-437h px� 
j
&Design is defaulting to constrset: %s
434*	planAhead2
	constrs_12default:defaultZ12-434h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2t
`c:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/cpu_clk/cpu_clk.dcp2default:default2
	Clock/clk2default:defaultZ1-454h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2l
Xc:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/RAM/RAM.dcp2default:default2!
DataMem/udram2default:defaultZ1-454h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2r
^c:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/prgrom/prgrom.dcp2default:default2
IFetch/urom2default:defaultZ1-454h px� 
h
-Analyzing %s Unisim elements for replacement
17*netlist2
15432default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
x
Netlist was created with %s %s291*project2
Vivado2default:default2
2017.42default:defaultZ1-479h px� 
V
Loading part %s157*device2#
xc7a35tcsg324-12default:defaultZ21-403h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
�
LRemoving redundant IBUF, %s, from the path connected to top-level port: %s 
35*opt2/
Clock/clk/inst/clkin1_ibufg2default:default2
fpga_clk2default:defaultZ31-35h px� 
�
�Could not create '%s' constraint because net '%s' is not directly connected to top level port. '%s' is ignored by %s but preserved for implementation tool.
528*constraints2 
IBUF_LOW_PWR2default:default2'
Clock/clk/clk_in12default:default2 
IBUF_LOW_PWR2default:default2
Vivado2default:default2�
yC:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.runs/impl_1/.Xil/Vivado-40000-LAPTOP-RPUCV7SL/dcp3/cpu_clk.edf2default:default2
2442default:default8@Z18-550h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2|
fc:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/cpu_clk/cpu_clk_board.xdc2default:default2$
Clock/clk/inst	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2|
fc:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/cpu_clk/cpu_clk_board.xdc2default:default2$
Clock/clk/inst	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2v
`c:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc2default:default2$
Clock/clk/inst	2default:default8Z20-848h px� 
�
%Done setting XDC timing constraints.
35*timing2v
`c:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc2default:default2
572default:default8@Z38-35h px� 
�
Deriving generated clocks
2*timing2v
`c:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc2default:default2
572default:default8@Z38-2h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2 
get_clocks: 2default:default2
00:00:082default:default2
00:00:122default:default2
1151.0662default:default2
567.5742default:defaultZ17-268h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2v
`c:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc2default:default2$
Clock/clk/inst	2default:default8Z20-847h px� 
�
Parsing XDC File [%s]
179*designutils2m
WC:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/constrs_1/new/const.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2m
WC:/Users/Hok Layheng/Desktop/Final_CPU/Final_CPU/Final_CPU.srcs/constrs_1/new/const.xdc2default:default8Z20-178h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
122default:default2
22default:default2
02default:default2
02default:defaultZ4-41h px� 
]
%s completed successfully
29*	vivadotcl2
link_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2!
link_design: 2default:default2
00:00:122default:default2
00:00:232default:default2
1151.1292default:default2
918.8122default:defaultZ17-268h px� 


End Record