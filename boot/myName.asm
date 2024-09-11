BITS 16
ORG 0x8000          ; Dirección del sector de arranque

start:
    call set_console
    mov si, menu
    call print_string

main_loop:
    ; Lee la tecla presionada
    mov ah, 0x00
    int 0x16                ; Interrupción para leer el teclado

    ; Ejecuta acciones basadas en la tecla presionada
    cmp al, 'y'
    je start_application

    cmp al, 'p'
    je exit_program

    ; Vuelve al menú principal si la tecla no es reconocida
    jmp main_loop

start_application:
    call set_console
    ; Muestra el mensaje
    call kevin_up


process_arrows:
    mov ah, 00h           ; Leer el código extendido de la tecla
    int 16h               ; Espera una tecla

    ; Verificar si la tecla es W, A, S o D
    cmp al, 'w'        
    je kevin_up

    cmp al, 'a'           ; Verificar si la tecla es 'a'
    je kevin_left

    cmp al, 's'           ; Verificar si la tecla es 's'
    je kevin_down

    cmp al, 'd'           ; Verificar si la tecla es 'd'
    je kevin_right

    cmp al, 'r'
    je restart

    cmp al, 'p'
    je exit_program

    jmp process_arrows    ; Continuar en el bucle de entrada de teclas

 
set_console:
    ; Configura el modo de texto 80x25 con 16 colores
    mov ax, 0x03
    int 0x10
    ret

restart:
    jmp start

exit_program:
    ; Se queda en un bucle infinito para detener el programa
    call set_console
    mov si, mensajeFin
    call print_string
    cli
    hlt
    jmp $


print_string:
    mov ah, 0x0E        ; Función 0Eh de BIOS para imprimir caracteres
.next_char:
    lodsb               ; Cargar el siguiente carácter de DS:SI en AL
    cmp al, 0           ; Comprobar si es el final de la cadena
    je .done            ; Si es cero, final de la cadena
    int 0x10            ; Llamar a la interrupción de video
    jmp .next_char      ; Continuar con el siguiente carácter
.done:
    ret


kevin_left:
    call set_console
    KevinIzquie db '+++++', 0x0D,0x0A
                db '  ++ ', 0x0D,0x0A
                db ' +   ', 0x0D,0x0A
                db '+++++', 0x0D,0x0A
                db '     ', 0x0D,0x0A
                db '+   +', 0x0D,0x0A
                db '+++++', 0x0D,0x0A
                db '+   +', 0x0D,0x0A
                db '     ', 0x0D,0x0A
                db '++++ ', 0x0D,0x0A
                db '    +', 0x0D,0x0A
                db '++++ ', 0x0D,0x0A
                db '     ', 0x0D,0x0A
                db '+   +', 0x0D,0x0A
                db '+ + +', 0x0D,0x0A
                db '+++++', 0x0D,0x0A
                db '     ', 0x0D,0x0A
                db '+   +', 0x0D,0x0A
                db ' + + ', 0x0D,0x0A
                db '  +  ', 0x0D,0x0A
                db '+++++', 0x0D,0x0A,0    
    mov si ,KevinIzquie
    call print_string
    jmp process_arrows

kevin_up:
    call set_console
    KevinArriba db '+   +  +++  +   +  +++  +  +', 0x0D, 0x0A
                db '+ +    +    +   +   +   ++ +', 0x0D, 0x0A
                db '++     ++   +   +   +   + ++', 0x0D, 0x0A
                db '+ +    +    +   +   +   + ++', 0x0D, 0x0A
                db '+   +  +++    +    +++  +  +', 0x0D, 0x0A, 0
    mov si ,KevinArriba
    call print_string
    jmp process_arrows

kevin_right:
    call set_console
    kevinDerecha db '+++++', 0x0D,0x0A
                db '  +  ', 0x0D,0x0A
                db ' + + ', 0x0D,0x0A
                db '+   +', 0x0D,0x0A
                db '     ', 0x0D,0x0A
                db '+++++', 0x0D,0x0A
                db '+ + +', 0x0D,0x0A
                db '+   +', 0x0D,0x0A
                db '     ', 0x0D,0x0A
                db ' ++++', 0x0D,0x0A
                db '+    ', 0x0D,0x0A
                db ' ++++', 0x0D,0x0A
                db '     ', 0x0D,0x0A
                db '+   +', 0x0D,0x0A
                db '+ + +', 0x0D,0x0A
                db '+   +', 0x0D,0x0A
                db '     ', 0x0D,0x0A
                db '+++++', 0x0D,0x0A
                db '   + ', 0x0D,0x0A
                db ' ++  ', 0x0D,0x0A
                db '+++++', 0x0D,0x0A,0 
    mov si ,kevinDerecha
    call print_string
    jmp process_arrows


kevin_down:
    call set_console
    kevinVuelta db '+   +  +++    +    +++  +  +', 0x0D,0x0A
                db '+ +    +    +   +   +   + ++', 0x0D,0x0A
                db '++     ++   +   +   +   + ++', 0x0D,0x0A
                db '+ +    +    +   +   +   ++ +', 0x0D,0x0A
                db '+   +  +++  +   +  +++  +  +', 0x0D,0x0A,0              
    mov si ,kevinVuelta
    call print_string
    jmp process_arrows

mensajeFin db 'Se ha terminado el programa...', 0
menu db 'Hola! Presiona alguna tecla:', 0x0D, 0x0A
     db '- y: iniciar', 0x0D, 0x0A
     db '- p: detener', 0x0D, 0x0A, 0

times 995-($-$$) db 0   ; Rellenar con ceros hasta 510 bytes
dw 0xAA55              ; Firma del sector de arranque