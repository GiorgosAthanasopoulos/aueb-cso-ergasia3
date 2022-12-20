# Giorgos Athanasopoulos - p3210265
# Lampros Staikos - p
	.text
	.globl main
main:
	# System.out.print("Postfix (input): ");
	la $a0,msg1
	li $v0,4
	syscall
	
	do:
		# ch = (int) System.in.read();
		li $v0,12
		syscall
		sw $v0,ch
	
		# if (ch != ' ') {
		lw $t0,ch
		beq $t0,' ',while
		
		# number = 0;
		li $t0,0
		sw $t0,number
		
		nestedwhile:
			# while ((ch >= '0') && (ch <= '9')) {
			lb $t0,ch
			blt $t0,'0',endwhile
			bgt $t0,'9',endwhile
		
			# number = 10 * number + (ch - 48);
			lw $t0,number
			mul $t0,$t0,10
			lw $t1,ch
			add $t0,$t0,$t1
			sw $t0,number
		
			# ch = (int) System.in.read();
			li $v0,12
			syscall
			sw $v0,ch
		
			j nestedwhile
		
		endwhile:
			# if ((ch == '+') || (ch == '-') || (ch == '*') || (ch == '/')) {
			lb $t0,ch
			beq $t0,'+',validoperator
			beq $t0,'-',validoperator
			beq $t0,'*',validoperator
			beq $t0,'/',validoperator
			
			# else if (ch != '=')
			bne $t0,'=',while
			
			# push(number);
			lw $a0,number
			jal push
			
			validoperator:
				# x2 = pop();
				jal pop
				move $a2,$v0
			
				# x1 = pop();
				jal pop
				move $a0,$v0
			
				# result = calc(x1, ch, x2);
				lw $a1,ch
				jal calc
			
				# push(result);
				move $a0,$v0
				jal push
	
	# } while (ch != '=');
	while:
		lw $t0,ch
		bne $t0,'=',do
	
	# if (i == 1) 	
	lw $t0,i
	bne $t0,1,else
	
	# System.out.println("Postfix Evaluation: " + p[0]);
	la $a0,msg3
	li $v0,4
	syscall
	lw $a0,0($sp)
	li $v0,1
	syscall
	j exit
	
	else:
		# System.out.println("Invalid Postfix");
		la $a0,msg4
		li $v0,4
		syscall

	exit:
		li $v0,10
		syscall

pop:
	# if (i == 0) {
	lw $t0,i
	bne $t0,0,popelse
	
	# System.out.println("Invalid Postfix");
	la $a0,msg4
	li $v0,4
	syscall
	
	# System.exit(1);
	j exit
	
	popelse:
		# i--;
		lw $t0,i
		sub $t0,$t0,1
		sw $t0,i
		
		# return (p[i]);
		lw $v0,($sp)
		addi $sp,$sp,4
		
	jr $ra
		
push:
	# p[i] = result;
	sub $sp,$sp,4
	sw $a0,($sp)
	
	# i++;
	lw $t0,i
	addi $t0,$t0,1
	sw $t0,i
	
	jr $ra
	
calc:
	# case ch == '+'
	beq $a1,'+',plus
	# case ch == '-'
	beq $a1,'-', minus
	# case ch == '*'
	beq $a1,'*',star
	# case ch == '/
	beq $a1,'/',forwardslash
	
	# int total = 0;
	li $v0,0
	# return total (if ch is not valid)
	jr $ra

	plus:
		# total = x1 + x2;
		add $t0,$a0,$a2
		move $v0,$t0
		
		# break - return
		jr $ra
	minus:
		# total = x1 - x2;
		sub $t0,$a0,$a2
		move $v0,$t0
		
		# break - return
		jr $ra
	star:
		# total = x1 * x2;
		mul $t0,$a0,$a2
		move $v0,$t0
		
		# break - return
		jr $ra	
	forwardslash:
		# if (x2 != 0) {
		beq $a2,0,divbyzero
		
		# total = x1 / x2;
		div $t0,$a0,$a2
		move $v0,$t0
		
		# break - return
		jr $ra
		
		# else 
		divbyzero:
			# System.out.println("Divide by zero");
			la $a0,msg5
			li $v0,4
			syscall
		
			# System.exit(1);
			j exit
			
	.data
# mono global & main variables
i: .word 0
	
ch: .byte
number: .space 4
msg1: .asciiz "Postfix (input): "
msg2: .asciiz "Postfix Evaluation: "
msg3: .asciiz "Postfix Evaluation: "
msg4: .asciiz "Invalid Postfix"
msg5: .asciiz "Divide by zero"