#input a and b display 8-bit binary (LED) 
.text 
#0xfffffc00 16 switches 
#0xfffffc10 left 8 switches
#0xfffffc20 test_case (V1)
#0xfffffc22 end_case / lights off (R11)
#0xfffffc24 input A button (R17)
#0xfffffc26 input B button (U4)
#0xfffffc40 16 LED
#0xfffffc50 8 LED (left)
#0xfffffc60 8 LED (right)
#0xfffffc70 tube

addi s11, zero, 1 # check if button is confirmed
li s8, 0x0000ffff
sw s8, 0xfffffc40(zero) # initially all 16 LED are on

confirm_test:
     lw s0, 0xfffffc22(zero)     # get button 
     bne s0, s11,confirm_test
     sw zero, 0xfffffc40(zero)   # all 16 LED off
     sw zero, 0xfffffc70(zero)   # tube off
     
test_case_input:
     lw s1, 0xfffffc10(zero)     # get test_num from switch 
     lw s0, 0xfffffc20(zero)     # get button input
     bne s0, s11, test_case_input
     sw s1, 0xfffffc70(zero)     # display test_case on tube
     
     addi s10, zero, 0
     beq s1, s10, test000
     addi s10, zero, 1
     beq s1, s10, test001
     addi s10, zero, 2
     beq s1, s10, test010
     addi s10, zero, 3
     beq s1, s10, test011
     addi s10, zero, 4
     beq s1, s10, test100
     addi s10, zero, 5
     beq s1, s10, test101
     addi s10, zero, 6
     beq s1, s10, test110
     addi s10, zero, 7
     beq s1, s10, test111
     
test000:
A000:
     lw s2, 0xfffffc10(zero) # input A from switch
     lw s0, 0xfffffc24(zero) # input A button
     bne s0, s11, A000
     sw s2, 0xfffffc50(zero) # display result in 8 LED left

B000:
     lw s3, 0xfffffc10(zero)
     lw s0, 0xfffffc26(zero) # input B button
     bne s0, s11, B000
     sw s3, 0xfffffc50(zero) # display result in 8 LED left
     jal confirm_test
     
test001:
     lb s2, 0xfffffc10(zero)
     lw s0, 0xfffffc24(zero)  # input button (use input A button) R17
     bne s0, s11, test001
     sw s2, 0xfffffc70(zero)  # display in tube
     sw s2, 0(zero)           # store for future usage
     jal confirm_test
     
test010:
     lbu s3, 0xfffffc10(zero)
     lw s0, 0xfffffc24(zero)   # input button (use input A button) R17
     bne s0, s11, test010
     sw s3, 0xfffffc70(zero)   # display in tube
     sw s3, 4(zero)            # store for future usage 
     jal confirm_test
     
test011:
     lw s2, 0(zero)   # input A from test001
     lw s3, 4(zero)   # input B from test010
     
     #sw s2, 0xfffffc50(zero)  #display A on left 8 LED
     #sw s3, 0xfffffc60(zero)  #display B on right 8 LED
     
     beq s2, s3, LED_on
     jal LED_off
     
test100:
     lw s2, 0(zero)
     lw s3, 4(zero)
     blt s2, s3, LED_on
     jal LED_off
     
test101:
     lw s2, 0(zero)
     lw s3, 4(zero)
     bge s2, s3, LED_on
     jal LED_off 
     
test110:
     lw s2, 0(zero)
     lw s3, 4(zero)
     bltu s2, s3, LED_on
     jal LED_off
     
test111:
     lw s2, 0(zero)
     lw s3, 4(zero)
     bgeu s2, s3, LED_on
     jal LED_off
     
LED_on: 
     li s9, 0x0000ffff
     sw s9, 0xfffffc60(zero) #16 LED on 
     jal confirm_test
     
LED_off:
     sw zero, 0xfffffc60(zero) #16 LED off
     jal confirm_test
