# extern void entry(int *arr, int t, int *arr2)

.section .text
.global asm_dp

asm_dp:
    # TODO: You have to implement dynamic programming with assembly code
    # HINT: You might need to use "slli(shift left)" to implement multiplication
    # HINT: You might need to be careful of calculating the memory address you store in your register
    # a0 - address of arr
    # a1 - t
    # a2 - address of arr2

    # t0 - outer counter
    # t1 - inner counter

    # s0 - inner limit
    # s1 - arr index
    # s2 - dp_array index
    addi sp, sp, -32
    sd   s0, 24(sp)
    sd   s1, 16(sp)
    sd   s2, 8(sp)
    sd   s3, (sp)
    li   s0, 6
    addi a1, a1, 1
    li   t0, 1
outer_for:
    bge  t0, a1, outer_done     # i < t + 1
    li   t1, 0                  # int j
inner_for:
    bge  t1, s0, inner_done     # j < 6
    slli s1, t1, 3              # j * 2
    add  t2, a0, s1             # (arr + j * 2)
    lw   t3, (t2)
    sub  t4, t0, t3             # i - *(arr + j * 2)
    blt  t4, x0, invalid
    addi t5, t2, 4              # arr + j * 2 + 1
    slli s2, t0, 2
    add  t2, a2, s2             # t2 = dp_array[i]
    slli t4, t4, 2
    add  t3, a2, t4             # &(dp_array[i - *(arr + j * 2)])
    lw   s1, (t3)
    lw   s2, (t5)
    lw   t4, (t2)
    add  s3, s1, s2             # dp_array[i - *(arr + j * 2)] + *(arr + j * 2 + 1)
    bge  t4, s3, invalid
    sw   s3, (t2)
invalid:
    addi t1, t1, 1
    j    inner_for
inner_done:
    addi t0, t0, 1
    j    outer_for
outer_done:
    # no need to set a0
    ld   s3, (sp)
    ld   s2, 8(sp)
    ld   s1, 16(sp)
    ld   s0, 24(sp)
    addi sp, sp, 32
    jr   ra
