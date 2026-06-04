default rel

GL_COLOR_BUFFER_BIT equ 0x00004000
GL_DEPTH_BUFFER_BIT equ 0x00000100
GL_QUADS            equ 0x0007
GL_FLOAT            equ 0x1406

extern glClearColor
extern glClear
extern glLoadIdentity
extern glRotatef
extern glTranslatef
extern glColorPointer
extern glVertexPointer
extern glDrawArrays
extern camX
extern camY
extern camZ
extern camYaw
extern camPitch
extern chunk_vertices
extern chunk_colors
extern one
extern zero
extern angle
extern step
extern chunk_vertex_count

global render

section .text

render:
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 32

    xorps xmm0, xmm0
    xorps xmm1, xmm1
    xorps xmm2, xmm2
    movss xmm3, [one]
    call glClearColor

    mov edi, GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    call glClear

    call glLoadIdentity

    movss xmm0, [camPitch]
    movss xmm1, [one]
    movss xmm2, [zero]
    movss xmm3, [zero]
    call glRotatef

    movss xmm0, [camYaw]
    movss xmm1, [zero]
    movss xmm2, [one]
    movss xmm3, [zero]
    call glRotatef

    xorps xmm0, xmm0
    subss xmm0, [camX]

    xorps xmm1, xmm1
    subss xmm1, [camY]

    xorps xmm2, xmm2
    subss xmm2, [camZ]

    call glTranslatef

    lea rcx, [chunk_colors]
    mov edi, 3
    mov esi, GL_FLOAT
    xor edx, edx
    call glColorPointer

    lea rcx, [chunk_vertices]
    mov edi, 3
    mov esi, GL_FLOAT
    xor edx, edx
    call glVertexPointer

    mov edi, GL_QUADS
    xor esi, esi
    mov edx, [chunk_vertex_count]
    call glDrawArrays

    movss xmm0, [angle]
    addss xmm0, [step]
    movss [angle], xmm0

    mov rsp, rbp
    pop rbp
    ret
