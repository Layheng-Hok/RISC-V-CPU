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
	#0xfffffc69 tube32bit
	#0xfffffc70 tube16bit

	addi s11, zero, 1         # check if button is confirmed
	li s8, 0x0000ffff
	sw s8, 0xfffffc40(zero)   # initially all 16 LED are on

confirm_test:
     	lw s0, 0xfffffc22(zero)    # get button 
     	bne s0, s11,confirm_test
     	sw zero, 0xfffffc40(zero)  # all 16 LED off
     	sw zero, 0xfffffc70(zero)  # tube off
     
test_case_input:
     	lw s1, 0xfffffc10(zero)    # get test_num from switch 
     	lw s0, 0xfffffc20(zero)    # get button input
     	bne s0, s11, test_case_input
     	sw s1, 0xfffffc70(zero)    # display the test case number on tube 
     
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
     	lw s2, 0xfffffc10(zero) #input 8-bit 
     	lw s0, 0xfffffc24(zero) #confirm using input A button
     	bne s0, s11, test000
     
     	addi s3, zero, 8      # n = 8 
     	addi s4, zero, 0      # y = 0
     
     	srli s4, s2, 4        # y = s2 >> 4
     	beq s4, zero, shift_by_2   # if y == 0, jump to shift_by_2 
     	addi s3, s3, -4       # n = n - 4
     	add s2, zero, s4      # s2 = y
     
shift_by_2:
     	srli s4, s2, 2        # y = s2 >> 2
     	beq s4, zero, shift_by_1   # if y == 0, jump to shift_by _1
     	addi s3, s3, -2       # n = n - 2
     	add s2, zero, s4      # s2 = y
     
shift_by_1:
     	srli s4, s2, 1             # y = s2 >> 1
     	beq s4, zero, result       # if y == 0, jump to result
     	addi s3, s3, -2            # n = n - 2
     	j output_result

result:
     	sub s3, s3, s2             # n = n - x

output_result:
     	sw s3, 0xfffffc70(zero)    # display in tube
     	j confirm_test
    
test001:
     	lw s2, 0xfffffc00(zero)    # input 16-bit 
	lw a3, 0xfffffc24(zero)    # confirm using input A button
     	bne a3, s11, test001
     	add t0, s2, zero
     	li t1, 0x8000              # Load the 16-bit floating point number
     	addi s0, zero, 15
     	sra s0, t0, s0
     	addi s1, zero, 1
     	and t1, s0, s1             # Extract sign bit

     	beq t1, zero, dontFixSign
	li s0, 0x8000
     	sub t0, t0, s0

dontFixSign:
     	li t2, 10
     	sra t2, t0, t2       # Extract exponent bits
     	li t3, 0x03FF
     	and t3, t0, t3       # Extract fraction bits

     	li t4, 15            # Bias for 5-bit exponent (2^5 - 1)
     	li t5, 10

     	sub t2, t2, t4       #unbiased exponent
     	sub t5, t5, t2       # 10 - unbiased
     	sra t4, t3, t5

     	addi t6, t2, 0
     	addi t5, zero, 1
     	sll t5, t5, t6
     	add t5, t5, t4      # 10

     	li t0, 1111111111
     	sra t0, t0, t2
     	sll t3, t3, t2

     	and t0, t0, t3

     	beq t1, zero, DontMakeNegative
     	add s0, zero, t5
     	sub t5, t5, s0
     	sub t5, t5, s0
     	beq zero, zero, noRound

DontMakeNegative:
     	beq t0, zero, noRound
     	addi t5, t5, 1

noRound:
	sw t5, 0xfffffc70(zero) # display on tube
     	j confirm_test
     
test010:
     	lw s2, 0xfffffc00(zero) # input 16-bit 
     	lw a3, 0xfffffc24(zero) # confirm using input A button
     	bne a3, s11, test010
     
     	add t0, s2, zero
     	li t1, 0x8000            # Load the 16-bit floating point number
     	addi s0, zero, 15
     	sra s0, t0, s0
     	addi s1, zero, 1
     	and t1, s0, s1    # Extract sign bit
     	beq t1, zero, dontFixSign2
     	li s0, 0x8000
     	sub t0, t0, s0

dontFixSign2:
     	li t2, 10
     	sra t2, t0, t2       # Extract exponent bits
     	li t3, 0x03FF
     	and t3, t0, t3     # Extract fraction bits

     	li t4, 15               # Bias for 5-bit exponent (2^5 - 1)
     	li t5, 10

     	sub t2, t2, t4 #unbiased exponent
     	sub t5, t5, t2 # 10 - unbiased
     	sra t4, t3, t5

     	addi t6, t2, 0
     	addi t5, zero, 1
     	sll t5, t5, t6
     	add t5, t5, t4 #10

     	li t0, 1111111111
     	sra t0, t0, t2
     	sll t3, t3, t2

     	and t0, t0, t3

     	beq t1, zero, noRound2
     	add s0, zero, t5
     	sub t5, t5, s0
     	sub t5, t5, s0
     	li s0, 1
     	sub t5, t5, s0

noRound2:
     	sw t5, 0xfffffc70(zero) # display on tube 
     	j confirm_test
     
test011:
     	lw s2, 0xfffffc00(zero) # input 16-bit 
     	lw a3, 0xfffffc24(zero) # confirm using input A button  
     	bne a3, s11, test011
     
     	add t0, s2, zero 
     	li t1, 0x8000         # Load the 16-bit floating point number
     	addi s0, zero, 15
     	sra s0, t0, s0
     	addi s1, zero, 1
     	and t1, s0, s1    # Extract sign bit

     	beq t1, zero, dontFixSign3
     	li s0, 0x8000
     	sub t0, t0, s0

dontFixSign3:
     	li t2, 10
     	sra t2, t0, t2       # Extract exponent bits
     	li t3, 0x03FF
     	and t3, t0, t3     # Extract fraction bits

     	li t4, 15               # Bias for 5-bit exponent (2^5 - 1)
     	li t5, 10

     	sub t2, t2, t4 #unbiased exponent
     	sub t5, t5, t2      # 10 - unbiased
     	sra t4, t3, t5

     	addi t6, t2, 0
     	addi t5, zero, 1
     	sll t5, t5, t6
     	add t5, t5, t4        #10

    	beq t1, zero, DontMakeNegative3
     	add s0, zero, t5
	sub t5, t5, s0
     	sub t5, t5, s0

     	li t0, 1
     	sll t3, t3, t2
     	addi t2, zero, 9
     	srl t3, t3, t2

     	and t0, t0, t3
     	beq t0, zero, roundUp
     	addi t5, t5, -1
     
     	sw t5, 0xfffffc70(zero)
     	j confirm_test

DontMakeNegative3:
     	li t0, 1
     	sll t3, t3, t2
     	addi t2, zero, 9
     	srl t3, t3, t2

     	and t0, t0, t3
     	beq t0, zero, roundDown
     	addi t5, t5, 1
     
     	sw t5, 0xfffffc70(zero)
     	j confirm_test

roundDown:
     	sw t5, 0xfffffc70(zero)
     	j confirm_test

roundUp:
     	sw t5, 0xfffffc70(zero)
     	j confirm_test

test100:
A000:
     	lbu s2, 0xfffffc10(zero) # input A from switch
     	lw s0, 0xfffffc24(zero) # input A button
     	bne s0, s11, A000
	sw s2, 0xfffffc50(zero) # display input A on tube 

B000:
     	lbu s3, 0xfffffc10(zero) # input B from switch 
     	lw s0, 0xfffffc26(zero) # input B button
     	bne s0, s11, B000
     	sw s3, 0xfffffc50(zero) # display button B on tube
     
     	add s4, zero, zero
     	add s4, s3, s2          # sum1
     	addi t0, zero, 256
     	bge s4, t0, handle_overflow
     	jal invert_sum
     
handle_overflow:
     	srli t1, s4, 8         # t1 = sum1[8] (shift right by 8 bits)
     	andi t2, s4, 255       # t2 = sum1[7:0] (keep only lower 8 bits)
     	add s4, t1, t2         # s4 = sum1[7:0] + sum1[8]
     	jal invert_sum
     
invert_sum:
     	not s4, s4
     	andi s4, s4, 255       # ensure result is within 8-bit range
     	sw s4, 0xfffffc70(zero)
     	j confirm_test
     
test101:
    	lw s2, 0xfffffc00(zero) # input 16-bit 
     	lw s0, 0xfffffc24(zero)
     	bne s0, s11, test101
     
     	li t4, 8
     	add t0, zero, s2
     	li t3, 0x0000f000
     	and t3, t3, t0
     	beq t3, zero, bit

     	li t1, 0x000000ff
     	li t2, 0x0000ff00

     	and t1, t0, t1
     	and t2, t0, t2

     	slli t1, t1, 8
     	sra t2, t2, t4

     	add t1, t1, t2
     	beq zero, zero, done

bit:
     	li t1, 0x0000000f
     	li t2, 0x0000ff00

     	and t1, t0, t1
     	and t2, t0, t2

     	slli t1, t1, 8 	
     	sra t2, t2, t4

     	add t1, t1, t2
done:
     	sw t1, 0xfffffc69(zero)
     	j confirm_test

test110:
     	lbu s2, 0xfffffc10(zero)  # input 8-bit 
     	lw s0, 0xfffffc24(zero)
     	bne s0, s11, test110
     
	add a0, zero, s2
	add t4, zero, zero	  # reset counter
     	addi s1, zero, 1	  # s1 = 1 (const)
     	jal fib1
     	
     	sw t4, 0xfffffc69(zero)
     	j confirm_test

fib1:
     	addi sp, sp,-8		  # adjust stack for 2 items
     	sw ra, 4(sp)	  	  # save the return address
     	sw a0, 0(sp)		  # save the argument n
     	addi t4, t4, 2		  # count item pushes

     	blt a0, s1, set_to_1_1	  # test for n<1
     	add t0, zero, zero	  # else set t0 to 0

fib_cont1:	
     	beq t0, zero, fib_helper1  # if n >= 1,go to fib_helper
				
     	addi a0, zero, 1	  # else return 1 / fib(0) = 1
     	addi sp, sp, 8		  # pop 2 items off stack
     	addi t4, t4, 2		  # count item pops
     	jr ra			  # return to caller
	
set_to_1_1:
     	addi t0, zero, 1	  # if n<1, set t0 to 1
     	beq zero, zero, fib_cont1

fib_helper1:  	
    	addi a0, a0, -1		  # n >= 1; argument gets fib(n-1)
     	jal fib1              	  # call fib with(n-1)	
	
     	add t1, t2, zero	  # t1 = f(n-2)
     	add t2, a0, zero	  # t2 = f(n-1)
     	add a0, t2, t1		  # compute f(n) = f(n-1) + f(n-2)
	
     	lw ra, 4(sp)		  # return from jal: restore the return address
     	addi sp, sp, 8		  # adjust stack pointer to pop 2 items
     	addi t4, t4, 2		  # count item pops
     	jr ra			  # return to the caller
     
test111:
     	lbu s2, 0xfffffc10(zero)  # input 8-bit 
     	lw s0, 0xfffffc24(zero)
     	bne s0, s11, test111

     	add a0, zero, s2
     	addi s1, zero, 1	  # s1 = 1 (const)
     	jal fib2
     
     	j confirm_test

fib2:
     	addi sp, sp,-8		  # adjust stack for 2 items
     	sw ra, 4(sp)	  	  # save the return address
     	sw a0, 0(sp)		  # save the argument n
     	addi t4, t4, 2		  # count item pushes

     	blt a0, s1, set_to_1_2	  # test for n<1
     	add t0, zero, zero	  # else set t0 to 0

fib_cont2:	
     	beq t0, zero, fib_helper2  # if n >= 1,go to fib_helper
				
     	addi a0, zero, 1	  # else return 1 / fib(0) = 1
     	addi sp, sp, 8		  # pop 2 items off stack
     	addi t4, t4, 2		  # count item pops
     	jr ra			  # return to caller
	
set_to_1_2:
     	addi t0, zero, 1	  # if n<1, set t0 to 1
     	beq zero, zero, fib_cont2

fib_helper2:  	
     	addi a0, a0, -1		  # n >= 1; argument gets fib(n-1)
     	jal fib2              	  # call fib with(n-1)	
	
     	add t1, t2, zero	  # t1 = fib(n-2)
     	add t2, a0, zero	  # t2 = fib(n-1)
     	add a0, t2, t1		  # compute f(n) = fib(n-1) + fib(n-2)

	sw t1, 0xfffffc69(zero)   # output fib(n-2)
	
     	lw ra, 4(sp)		  # return from jal: restore the return address
     	addi sp, sp, 8		  # adjust stack pointer to pop 2 items
     	addi t4, t4, 2		  # count item pops
     	jr ra			  # return to the caller
