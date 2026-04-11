default rel

GL_PROJECTION       equ 0x1701
GL_MODELVIEW        equ 0x1700
GL_VERTEX_ARRAY     equ 0x8074
GL_COLOR_ARRAY      equ 0x8076
GL_DEPTH_TEST       equ 0x0B71
SDL_INIT_VIDEO      equ 0x20
SDL_WINDOW_OPENGL   equ 0x00000002
SDL_QUIT            equ 0x100
SDL_GL_CONTEXT_MAJOR_VERSION equ 17
SDL_GL_CONTEXT_MINOR_VERSION equ 18
SDL_KEYDOWN          equ 0x300
SDLK_w      equ 119
SDLK_s      equ 115
SDLK_a      equ 97
SDLK_d      equ 100
SDLK_RIGHT  equ 1073741903
SDLK_LEFT   equ 1073741904
SDLK_UP     equ 1073741906
SDLK_DOWN   equ 1073741905

extern SDL_Init
extern SDL_GL_SetAttribute
extern SDL_CreateWindow
extern SDL_GL_CreateContext
extern SDL_PollEvent
extern SDL_GL_SwapWindow
extern SDL_Delay
extern SDL_Quit
extern glEnable
extern glEnableClientState
extern glViewport
extern glMatrixMode
extern glLoadIdentity
extern glFrustum
extern title
extern f_left
extern f_right
extern f_bottom
extern f_top
extern f_near
extern f_far
extern event
extern generate_chunk
extern render
extern move_forward
extern move_backward
extern move_left
extern move_right
extern rotate_left
extern rotate_right
extern rotate_up
extern rotate_down

global main

section .text
main:
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 32

    mov edi, SDL_INIT_VIDEO
    call SDL_Init

    mov edi, SDL_GL_CONTEXT_MAJOR_VERSION
    mov esi, 2
    call SDL_GL_SetAttribute
    mov edi, SDL_GL_CONTEXT_MINOR_VERSION
    mov esi, 1
    call SDL_GL_SetAttribute

    mov rdi, title
    mov rsi, 100
    mov rdx, 100
    mov rcx, 800
    mov r8, 600
    mov r9, SDL_WINDOW_OPENGL
    call SDL_CreateWindow
    test rax, rax
    jz fail
    mov r12, rax

    mov rdi, r12
    call SDL_GL_CreateContext
    
    mov edi, GL_DEPTH_TEST
    call glEnable

    mov edi, GL_VERTEX_ARRAY
    call glEnableClientState
    mov edi, GL_COLOR_ARRAY
    call glEnableClientState

    xor edi, edi
    xor esi, esi
    mov edx, 800
    mov ecx, 600
    call glViewport

    mov edi, GL_PROJECTION
    call glMatrixMode
    call glLoadIdentity
    movsd xmm0, [f_left]
    movsd xmm1, [f_right]
    movsd xmm2, [f_bottom]
    movsd xmm3, [f_top]
    movsd xmm4, [f_near]
    movsd xmm5, [f_far]
    call glFrustum
    mov edi, GL_MODELVIEW
    call glMatrixMode

    call generate_chunk

main_loop:
poll_loop:
    mov rdi, event
    call SDL_PollEvent
    test eax, eax
    jz do_render

    mov eax, [event]
    cmp eax, SDL_QUIT
    je cleanup
    cmp eax, SDL_KEYDOWN
    je handle_keydown
    jmp poll_loop

handle_keydown:
    mov eax, [event + 20]
    cmp eax, SDLK_w
    jne check_s
    call move_forward
    jmp poll_loop
check_s:
    cmp eax, SDLK_s
    jne check_a
    call move_backward
    jmp poll_loop
check_a:
    cmp eax, SDLK_a
    jne check_d
    call move_left
    jmp poll_loop
check_d:
    cmp eax, SDLK_d
    jne check_left
    call move_right
    jmp poll_loop
check_left:
    cmp eax, SDLK_LEFT
    jne check_right
    call rotate_left
    jmp poll_loop
check_right:
    cmp eax, SDLK_RIGHT
    jne check_up
    call rotate_right
    jmp poll_loop
check_up:
    cmp eax, SDLK_UP
    jne check_down
    call rotate_up
    jmp poll_loop
check_down:
    cmp eax, SDLK_DOWN
    jne poll_loop
    call rotate_down
    jmp poll_loop

do_render:
    call render
    mov rdi, r12
    call SDL_GL_SwapWindow
    mov edi, 16
    call SDL_Delay
    jmp main_loop

cleanup:
    call SDL_Quit
    mov rsp, rbp
    pop rbp
    ret

fail:
    call SDL_Quit
    mov rsp, rbp
    pop rbp
    ret
