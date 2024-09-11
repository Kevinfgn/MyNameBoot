BITS 16
ORG 0x8000          ; Dirección del sector de arranque

start:

    call set_console
    ; Muestra el menú principal
    ;call show_main_menu
    mov si, welcome_msg ; Dirección del mensaje
    call print_string   ; Llama a la función para imprimir la cadena

main_loop:

    mov si, menu
    call print_string

    ; Lee la tecla presionada
    mov ah, 0x00
    int 0x16                ; Interrupción para leer el teclado

    ; Ejecuta acciones basadas en la tecla presionada
    cmp al, 'y'
    je start_application

    cmp al, 'r'
    je restart

    cmp al, 'p'
    je exit_program

    ; Vuelve al menú principal si la tecla no es reconocida
    jmp main_loop

start_application:
    call set_console
    ; Muestra el mensaje
    mov si, KevinArriba
    call print_name

    ; Regresa al menú principal después de mostrar el mensaje
    jmp process_arrows


process_arrows:
    mov ah, 00h           ; Leer el código extendido de la tecla
    int 16h               ; Espera una tecla

    ; Verificar si la tecla es W, A, S o D
    cmp al, 'w'           ; Verificar si la tecla es 'w'
    je kevin_up

    cmp al, 'a'           ; Verificar si la tecla es 'a'
    je kevin_left

    cmp al, 's'           ; Verificar si la tecla es 's'
    je kevun_down

    cmp al, 'd'           ; Verificar si la tecla es 'd'
    je kevin_right

    jmp process_arrows    ; Continuar en el bucle de entrada de teclas




print_name:
    mov bx, 0
    mov dh, 0x08
    mov dl, 0x03
    jmp .move_cursor

    .repeat:
        lodsb               ; Cargar el siguiente byte de DS:SI en AL
        cmp al, 0
        je .done
        call print_char
        cmp al, 0x0A
        je .move_cursor
        jmp .repeat

    .move_cursor:
        mov ah, 0x02
        int 0x10
        add dh, 0x01
        jmp .repeat

    .done:
        ret

print_char:
    mov ah, 0x0E
    mov bh, 0
    mov bl, 0x07
    int 0x10
    ret
    
show_main_menu:
    ; Muestra el menú principal
    mov si, menu
    call print_menu
    jmp main_loop

print_menu:
    mov bx, 0

    .repeat:
        lodsb               ; Cargar el siguiente byte de DS:SI en AL
        cmp al, 0
        je .done
        call print_char
        jmp .repeat

    .done:
        ret

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
    call print_menu
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



menu db 'Presione alguna tecla:', 0x0D, 0x0A
     db '- i: iniciar', 0x0D, 0x0A
     db '- r: reiniciar', 0x0D, 0x0A
     db '- d: detener', 0x0D, 0x0A, 0
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

kevin_left:
    call set_console
    KevinIzquie   db '+++++', 0x0D,0x0A
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


kevin_right:
    call set_console
    kevinDerecha  db '+++++', 0x0D,0x0A
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


kevun_down:
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
welcome_msg db 'Bienvenido al juego "My name". Presiona y para empezar.', 0
times 980-($-$$) db 0   ; Rellenar con ceros hasta 510 bytes
dw 0xAA55              ; Firma del sector de arranque
