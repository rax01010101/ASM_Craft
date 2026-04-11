default rel
; I LIKE TO EXTERN EVERYTHING IN EACH LINE, SCREW COMMAS AND SHI
extern SDL_Init
extern SDL_CreateWindow
extern SDL_GL_SetAttribute
extern SDL_GL_CreateContext
extern SDL_GL_SwapWindow
extern SDL_PollEvent
extern SDL_Quit
extern SDL_Delay
extern glViewport
extern glClearColor
extern glClear
extern glRotatef
extern glTranslatef
extern glLoadIdentity
extern glEnable
extern glMatrixMode
extern glFrustum
extern glEnableClientState
extern glVertexPointer
extern glColorPointer
extern glDrawArrays

global title
global GL_COLOR_BUFFER_BIT
global GL_DEPTH_BUFFER_BIT
global GL_QUADS
global GL_PROJECTION
global GL_MODELVIEW
global GL_VERTEX_ARRAY
global GL_COLOR_ARRAY
global GL_FLOAT
global GL_DEPTH_TEST
global SDL_INIT_VIDEO
global SDL_WINDOW_OPENGL
global SDL_QUIT
global SDL_GL_CONTEXT_MAJOR_VERSION
global SDL_GL_CONTEXT_MINOR_VERSION
global SDL_KEYDOWN
global SDLK_w
global SDLK_s
global SDLK_a
global SDLK_d
global SDLK_RIGHT
global SDLK_LEFT
global SDLK_UP
global SDLK_DOWN
global cube_vertices
global cube_colors
global camX
global camY
global camZ
global camYaw
global camPitch
global rotSpeed
global moveSpeed
global degToRad
global angle
global step
global one
global zero
global f_left
global f_right
global f_bottom
global f_top
global f_near
global f_far
global grass_r
global grass_g
global grass_b
global stone_r
global stone_g
global stone_b
global event
global chunk_vertices
global chunk_colors

section .data
    title db "Dihh. ok im not sorry",0

    GL_COLOR_BUFFER_BIT equ 0x00004000
    GL_DEPTH_BUFFER_BIT equ 0x00000100
    GL_QUADS            equ 0x0007
    GL_PROJECTION       equ 0x1701
    GL_MODELVIEW        equ 0x1700
    GL_VERTEX_ARRAY     equ 0x8074
    GL_COLOR_ARRAY      equ 0x8076
    GL_FLOAT            equ 0x1406
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

    cube_vertices:
        dd -0.5, -0.5,  0.5,  0.5, -0.5,  0.5,  0.5,  0.5,  0.5, -0.5,  0.5,  0.5
        dd -0.5, -0.5, -0.5, -0.5,  0.5, -0.5,  0.5,  0.5, -0.5,  0.5, -0.5, -0.5
        dd -0.5,  0.5, -0.5, -0.5,  0.5,  0.5,  0.5,  0.5,  0.5,  0.5,  0.5, -0.5
        dd -0.5, -0.5, -0.5,  0.5, -0.5, -0.5,  0.5, -0.5,  0.5, -0.5, -0.5,  0.5
        dd  0.5, -0.5, -0.5,  0.5,  0.5, -0.5,  0.5,  0.5,  0.5,  0.5, -0.5,  0.5
        dd -0.5, -0.5, -0.5, -0.5, -0.5,  0.5, -0.5,  0.5,  0.5, -0.5,  0.5, -0.5

    cube_colors:
        times 4 dd 1.0, 0.2, 0.2
        times 4 dd 0.2, 1.0, 0.2
        times 4 dd 0.2, 0.2, 1.0
        times 4 dd 1.0, 1.0, 0.2
        times 4 dd 1.0, 0.2, 1.0
        times 4 dd 0.2, 1.0, 1.0

    camX dd -8.0
    camY dd -18.0
    camZ dd -8.0
    camYaw dd 0.0
    camPitch dd 0.0
    rotSpeed dd 2.0
    moveSpeed dd 0.05
    degToRad dd 0.01745329
    angle dd 0.0
    step dd 0.8
    one dd 1.0
    zero dd 0.0

    f_left dq -0.1
    f_right dq 0.1
    f_bottom dq -0.075
    f_top dq 0.075
    f_near dq 0.1
    f_far dq 100.0

    grass_r dd 0.2
    grass_g dd 0.8
    grass_b dd 0.2
    
    stone_r dd 0.5
    stone_g dd 0.5
    stone_b dd 0.5

section .bss
    event resb 64
    align 64
    chunk_vertices resd 500000
    align 64
    chunk_colors   resd 500000
