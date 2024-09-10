BITS 16
ORG 0x8000          ; Dirección del sector de arranque

start:

    call set_console
    ; Muestra el menú principal
    call show_main_menu

main_loop:

    ; Lee la tecla presionada
    mov ah, 0x00
    int 0x16                ; Interrupción para leer el teclado

    ; Ejecuta acciones basadas en la tecla presionada
    cmp al, 'i'
    je start_application

    cmp al, 'r'
    je restart

    cmp al, 'd'
    je exit_program

    ; Vuelve al menú principal si la tecla no es reconocida
    jmp main_loop

start_application:
    call set_console
    ; Muestra el mensaje
    mov si, KevinArriba
    call print_name

    ; Regresa al menú principal después de mostrar el mensaje
    jmp main_loop

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

menu db 'Presione alguna tecla:', 0x0D, 0x0A
     db '- i: iniciar', 0x0D, 0x0A
     db '- r: reiniciar', 0x0D, 0x0A
     db '- d: detener', 0x0D, 0x0A, 0

KevinArriba db '+   +  +++  +   +  +++  +  +', 0x0D, 0x0A
            db '+ +    +    +   +   +   ++ +', 0x0D, 0x0A
            db '++     ++   +   +   +   + ++', 0x0D, 0x0A
            db '+ +    +    +   +   +   + ++', 0x0D, 0x0A
            db '+   +  +++    +    +++  +  +', 0x0D, 0x0A, 0

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

mensajeFin db 'Se ha terminado el programa...', 0

times 732-($-$$) db 0   ; Rellenar con ceros hasta 510 bytes
dw 0xAA55              ; Firma del sector de arranque
