default rel

extern camX
extern camY
extern camZ
extern camYaw
extern camPitch
extern moveSpeed
extern rotSpeed
extern degToRad
extern chunk_vertices
extern chunk_colors
extern cube_vertices
extern grass_r
extern grass_g
extern grass_b
extern stone_r
extern stone_g
extern stone_b

global generate_chunk
global move_forward
global move_backward
global move_left
global move_right
global rotate_left
global rotate_right
global rotate_up
global rotate_down

section .text

generate_chunk:
	lea rdi, [chunk_vertices]
    lea rax, [chunk_colors]
    xor r13d, r13d
loop_x:
    xor r14d, r14d
loop_y:
    xor r15d, r15d
loop_z:
    cmp r14d, 15
    je set_grass
    
    movss xmm2, [stone_r]
    movss xmm3, [stone_g]
    movss xmm4, [stone_b]
    jmp vertex_loop_start

set_grass:
    movss xmm2, [grass_r]
    movss xmm3, [grass_g]
    movss xmm4, [grass_b]

vertex_loop_start:
    mov r8, 0
vertex_loop:
    mov r9, r8
    imul r9, 12
    
    movss xmm0, [cube_vertices + r9]
    cvtsi2ss xmm1, r13d
    addss xmm0, xmm1
    movss [rdi], xmm0
    
    movss xmm0, [cube_vertices + r9 + 4]
    cvtsi2ss xmm1, r14d
    addss xmm0, xmm1
    movss [rdi + 4], xmm0
    
    movss xmm0, [cube_vertices + r9 + 8]
    cvtsi2ss xmm1, r15d
    addss xmm0, xmm1
    movss [rdi + 8], xmm0

    movss [rax], xmm2
    movss [rax + 4], xmm3
    movss [rax + 8], xmm4

    add rdi, 12
    add rax, 12
    inc r8
    cmp r8, 24
    jl vertex_loop

    inc r15d
    cmp r15d, 16
    jl loop_z
    inc r14d
    cmp r14d, 16
    jl loop_y
    inc r13d
    cmp r13d, 16
    jl loop_x
    ret

rotate_left:
    movss xmm0, [camYaw]
    subss xmm0, [rotSpeed]
    movss [camYaw], xmm0
    ret

rotate_right:
    movss xmm0, [camYaw]
    addss xmm0, [rotSpeed]
    movss [camYaw], xmm0
    ret

rotate_up:
    movss xmm0, [camPitch]
    subss xmm0, [rotSpeed]
    movss [camPitch], xmm0
    ret

rotate_down:
    movss xmm0, [camPitch]
    addss xmm0, [rotSpeed]
    movss [camPitch], xmm0
    ret

move_forward:
    fld dword [camYaw]
    fmul dword [degToRad]
    fsincos
    fmul dword [moveSpeed]
    fld dword [camZ]
    faddp st1, st0
    fstp dword [camZ]
    fmul dword [moveSpeed]
    fld dword [camX]
    fsubrp st1, st0
    fstp dword [camX]
    ret

move_backward:
    fld dword [camYaw]
    fmul dword [degToRad]
    fsincos
    fmul dword [moveSpeed]
    fld dword [camZ]
    fsubrp st1, st0
    fstp dword [camZ]
    fmul dword [moveSpeed]
    fld dword [camX]
    faddp st1, st0
    fstp dword [camX]
    ret

move_left:
    fld dword [camYaw]
    fmul dword [degToRad]
    fsincos
    fmul dword [moveSpeed]
    fld dword [camX]
    faddp st1, st0
    fstp dword [camX]
    fmul dword [moveSpeed]
    fld dword [camZ]
    faddp st1, st0
    fstp dword [camZ]
    ret

move_right:
    fld dword [camYaw]
    fmul dword [degToRad]
    fsincos
    fmul dword [moveSpeed]
    fld dword [camX]
    fsubrp st1, st0
    fstp dword [camX]
    fmul dword [moveSpeed]
    fld dword [camZ]
    fsubrp st1, st0
    fstp dword [camZ]
    ret
