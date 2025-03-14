# extern int asm_entry(int *arr, int size);

.section .text
.global asm_entry

asm_entry:
    # TODO: You have to implement the xor_trick function with assembly language
    # leave space for arguments
    # s0 = base address, s1 = i, t0 = offset
    # addi sp, sp, -4     # int ret
    # preserve s0 and s1, provided that they are used in the context later
    addi sp, sp, -20
    sd   s0, 12(sp)      # save s0
    sd   s1, 4(sp)      # save s1
    # sw   x0, (sp)       # ret = 0
    li   t2, 0
    sw   t2, 0(sp)      # ret = 0
    mv   s0, a0         # s0 = array base address
    li   s1, 0          # == add s1, x0, x0
for:
    bge  s1, a1, done   # if not i < n; then done
    slli t0, s1, 2      # t0 = i * 4
    add  t0, t0, s0     # address of array[i]
    lw   t1, (t0)       # t1 = array[i]
    lw   t2, (sp)
    xor  t2, t2, t1     # t2 ^= t1
    sw   t2, (sp)       # ret = t2
    addi s1, s1, 1      # i += 1
    j    for            
done:
    # return
    lw   a0, (sp)       # assign return value
    ld   s1, 4(sp)      # restore s1
    ld   s0, 12(sp)      # restore s0
    # addi sp, sp, 4      # clear stack
    addi sp, sp, 20
    jr   ra

# the main function will load the return value using `lw`
# 10286:       87aa                    mv      a5,a0
# 10288:       fef42423                sw      a5,-24(s0)
# if the return value is larger than 32 bits,
# the truncation will make the two values inconsistent
# so it is best to use lw to load, and sw to store the value
