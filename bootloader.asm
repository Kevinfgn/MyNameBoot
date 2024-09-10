BITS 16                 ; Modo de 16 bits para la arquitectura x86
ORG 0x7C00              ; El bootloader se carga en la dirección de memoria 0x7C00

start:
    ; Limpia la pantalla
    mov ax, 0x0003      ; 03h es la función de BIOS para limpiar la pantalla
    int 0x10            ; Llama a la interrupción de BIOS 10h (Video)
    
    ; Mostrar mensaje de bienvenida
    mov si, welcome_msg ; Dirección del mensaje
    call print_string   ; Llama a la función para imprimir la cadena

    ; Esperar confirmación para iniciar
wait_for_key:
    mov ah, 0x00        ; Función 0 de BIOS para esperar una tecla
    int 0x16            ; Interrupción de BIOS 16h (Teclado)
    cmp al, 'Y'         ; Compara la tecla presionada con 'Y'
    je start_game       ; Si es 'Y', inicia el juego
    jmp wait_for_key    ; Si no es 'Y', espera otra vez

start_game:
    call clear_screen   ; Limpia la pantalla antes de iniciar el juego
    mov si, game_msg
    call print_string
    
hang:
    jmp hang            ; Bucle infinito para detener el bootloader después de iniciar el juego

; Función para imprimir una cadena de caracteres en pantalla
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

; Función para limpiar la pantalla
clear_screen:
    mov ax, 0x0003      ; 03h es la función de BIOS para limpiar la pantalla
    int 0x10            ; Llama a la interrupción de BIOS 10h (Video)
    ret

; Datos de los mensajes
welcome_msg db 'Bienvenido al juego "My name". Presiona Y para empezar.', 0
game_msg db 'Iniciando el juego...', 0

times 510-($-$$) db 0   ; Rellenar con ceros hasta 510 bytes
dw 0xAA55               ; Firma de arranque

