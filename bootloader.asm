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
    cmp al, 'y'         ; Compara la tecla presionada con 'y'
    je start_game       ; Si es 'y', inicia el juego
    jmp wait_for_key    ; Si no es 'y', espera otra vez

start_game:
    ; Limpia la pantalla
    mov ax, 0x0003      ; 03h es la función de BIOS para limpiar la pantalla
    int 0x10            ; Llama a la interrupción de BIOS 10h (Video)
    
    call randomize_positions ; Generar posiciones aleatorias para los nombres
    call print_names         ; Imprimir los nombres en las posiciones generadas

    ; Bucle de espera de tecla
process_arrows:
    mov ah, 00h           ; Leer el código extendido de la tecla
    int 16h               ; Espera una tecla

    ; Verificar si la tecla es W, A, S o D
    cmp al, 'w'           ; Verificar si la tecla es 'w'
    je clear_screen_action

    cmp al, 'a'           ; Verificar si la tecla es 'a'
    je clear_screen_action

    cmp al, 's'           ; Verificar si la tecla es 's'
    je clear_screen_action

    cmp al, 'd'           ; Verificar si la tecla es 'd'
    je clear_screen_action

    jmp process_arrows    ; Continuar en el bucle de entrada de teclas

clear_screen_action:
    call clear_screen     ; Limpia la pantalla
    ; Reimprimir los nombres después de limpiar la pantalla
    call print_names
    jmp process_arrows    ; Volver al bucle de entrada de teclas

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

print_names:
    ; Definición de los nombres en arte ASCII
    name db '+   +  +++  +   +  +++  +  +', 0x0D, 0x0A
         db '+ +    +    +   +   +   ++ +', 0x0D, 0x0A
         db '++     ++   +   +   +   + ++', 0x0D, 0x0A
         db '+ +    +    +   +   +   + ++', 0x0D, 0x0A
         db '+   +  +++    +    +++  +  +', 0x0D, 0x0A, 0

    mov si, name
    call print_at_position ; Llama a la función para imprimir en una posición específica

    ret

print_at_position:
    ; Mueve el cursor a la posición (x_pos, y_pos)
    mov ah, 02h
    mov bh, 00h           ; Página 0
    mov dh, [y_pos1]      ; Fila (Y)
    mov dl, [x_pos1]      ; Columna (X)
    int 10h
    
    ; Mostrar el texto desde SI
    call print_string     ; Llama a la función de imprimir cadena
    ret

randomize_positions:
    ; Generar posiciones aleatorias para los nombres
    mov ah, 2Ch           ; Obtener el tiempo del sistema
    int 1Ah               ; Esto nos da un "pseudo-random" valor

    ; Usar el tiempo como semilla para x e y aleatorias
    mov [x_pos1], dl      ; Posición X de 'Juan'
    mov [y_pos1], dh      ; Posición Y de 'Juan'
    mov [x_pos2], dl      ; Posición X de 'Pedro'
    mov [y_pos2], dh      ; Posición Y de 'Pedro'

    ret

exit:
    ; Detener ejecución
    cli
    hlt

; Datos de los mensajes
welcome_msg db 'Bienvenido al juego "My name". Presiona y para empezar.', 0
game_msg db 'Iniciando el juego...', 0

x_pos1 db 10              ; Posición inicial X para 'Juan'
y_pos1 db 10              ; Posición inicial Y para 'Juan'
x_pos2 db 40              ; Posición inicial X para 'Pedro'
y_pos2 db 15              ; Posición inicial Y para 'Pedro'

times 510-($-$$) db 0     ; Rellenar con ceros hasta 510 bytes
dw 0xAA55                 ; Firma de arranque
