.text
.global _start

_start:
    l1 t0, 1 ; init LFSR state
    li a0, 1 ; shifted taps mask
    li t2, 4 ; w[2] mask

_next:
    sw t0, 0x20(zero)
    andi t1, t0, 1 ; get w[0]
    srli t0, t0, 1
    beq  t1, zero, _next
    xor  t0, t0, a0
    or   t0, t0, t2 ; w[2] <= 1
    beq zero, zero, _next