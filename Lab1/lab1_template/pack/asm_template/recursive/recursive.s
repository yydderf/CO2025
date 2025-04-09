# extern int fibo_asm(int term)

.section .text
.global fibo_asm

fibo_asm:
    # TODO: You have to implement fibonacci with assembly language
    # HINT: You might need to use "jal(jump and link)" to finish the task
    addi sp, sp, -12
    sw   a0, 8(sp)
    sw   ra, 4(sp)
    sw   x0, 0(sp)
    addi t1, x0, 1
    bgt  a0, t1, else       # e > 1
    addi sp, sp, 12
    jr ra
else:
    addi a0, a0, -1
    jal  fibo_asm
    sw   a0, 0(sp)
    lw   a0, 8(sp)
    addi a0, a0, -2
    jal  fibo_asm
    lw   t2, 0(sp)
    add  a0, a0, t2
    lw   ra, 4(sp)
    addi sp, sp, 12
    jr   ra
