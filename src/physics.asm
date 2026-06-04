default rel

extern camX
extern camY
extern camZ
extern chunk_blocks
extern printf

global physics_update
global jump

section .data
gravity    dd -0.007
jump_power dd 0.22
velY       dd 0.0
grounded   dd 0
one        dd 1.0
half       dd 0.5
player_h   dd 1.65

fmt db "CamY: %f | BlockXYZ: (%d, %d, %d) | Index: %lu | BlockValue: %d", 10, 0

section .text

physics_update:
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    movss xmm0, [velY]
    movss xmm1, [gravity]
    addss xmm0, xmm1
    movss [velY], xmm0

    mov dword [grounded], 0

    movss xmm2, [camX]
    movss xmm3, [camY]
    movss xmm4, [camZ]

    addss xmm3, xmm0

    movss xmm5, xmm3
    subss xmm5, [player_h]

    addss xmm2, [half]
    addss xmm5, [half]
    addss xmm4, [half]

    cvttss2si eax, xmm2
    cvttss2si ebx, xmm5
    cvttss2si ecx, xmm4

    mov dword [rsp + 0], eax
    mov dword [rsp + 4], ebx
    mov dword [rsp + 8], ecx
    movss [rsp + 12], xmm3

    movsxd r8, eax
    movsxd r9, ebx
    movsxd r10, ecx
    imul r8, 256
    imul r9, 16
    add r8, r9
    add r8, r10

    xor r9, r9
    cmp r8, 0
    jl .skip_read
    cmp r8, 4096
    jge .skip_read
    movzx r9d, byte [chunk_blocks + r8]

.skip_read:
    mov rdi, fmt
    cvtss2sd xmm0, [rsp + 12]

    mov rsi, [rsp + 0]
    movsxd rsi, esi

    mov edx, [rsp + 4]
    movsxd rdx, edx

    mov rcx, [rsp + 8]
    movsxd rcx, ecx

    mov eax, 1
    call printf

    mov eax, [rsp + 0]
    mov ebx, [rsp + 4]
    mov ecx, [rsp + 8]
    movss xmm3, [rsp + 12]

    cmp ebx, 0
    jl air
    cmp ebx, 15
    jg air

    cmp eax, 0
    jl air
    cmp eax, 15
    jg air

    cmp ecx, 0
    jl air
    cmp ecx, 15
    jg air

    movsxd rax, eax
    movsxd rsi, ebx
    movsxd rcx, ecx

    imul rax, 256
    imul rsi, 16
    add rax, rsi
    add rax, rcx

    movzx edi, byte [chunk_blocks + rax]
    test edi, edi
    jz air

    mov dword [grounded], 1
    mov dword [velY], 0

    movsxd rbx, ebx

    cvtsi2ss xmm0, rbx
    addss xmm0, [half]
    addss xmm0, [player_h]
    movss [camY], xmm0
    jmp done

air:
    movss [camY], xmm3

done:
    mov rsp, rbp
    pop rbp
    ret

jump:
    mov eax, [grounded]
    test eax, eax
    jz skip_jump

    movss xmm0, [jump_power]
    movss [velY], xmm0

skip_jump:
    ret
