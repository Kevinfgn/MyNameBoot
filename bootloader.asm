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
    cmp al, 'y'         ; Compara la tecla presionada con 'Y'
    je start_game       ; Si es 'Y', inicia el juego
    jmp wait_for_key    ; Si no es 'Y', espera otra vez

   
start_game:
    
    ; Limpia la pantalla
    mov ax, 0x0003      ; 03h es la función de BIOS para limpiar la pantalla
    int 0x10            ; Llama a la interrupción de BIOS 10h (Video)
    


    call randomize_positions
    

    call print_names

    mov ah, 0x00           ; Llamada para esperar una tecla
    int 0x16
    
    ; Procesar teclas de flechas
    jmp process_arrows


    
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
    name db '+   +  +++  +   +  +++  +  +', 0x0D,0x0A
         db '+ +    +    +   +   +   ++ +', 0x0D,0x0A
         db '++     ++   +   +   +   + ++', 0x0D,0x0A
         db '+ +    +    +   +   +   + ++', 0x0D,0x0A
         db '+   +  +++    +    +++  +  +', 0x0D,0x0A,0

    mov si, name
    call print_at_position

    ret

process_arrows:
    mov ah, 00h           ; Leer el código extendido de la tecla
    int 16h

    cmp al, 'a'           ; Flecha izquierda
    je move_left
    
    cmp al, 'd'           ; Flecha derecha
    je move_right

    cmp al, 'w'           ; Flecha arriba
    je print_names

    cmp al, 's'           ; Flecha abajo
    je move_down

    cmp al, 'p'           ; Si la tecla es 'p', salir
    je exit

    jmp process_arrows

move_left:

    left_name db '+++++', 0x0D,0x0A
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

    mov si, left_name
    call print_at_position
    jmp process_arrows

move_right:
        right_name db '+++++', 0x0D,0x0A
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

    mov si, right_name
    call print_at_position
    jmp process_arrows

move_down:
    down_name db '+   +  +++    +    +++  +  +', 0x0D,0x0A
              db '+ +    +    +   +   +   + ++', 0x0D,0x0A
              db '++     ++   +   +   +   + ++', 0x0D,0x0A
              db '+ +    +    +   +   +   ++ +', 0x0D,0x0A
              db '+   +  +++  +   +  +++  +  +', 0x0D,0x0A,0

    mov si, down_name  
    call print_at_position   
    jmp process_arrows

print_at_position:
    ; Mueve el cursor a la posición (x_pos, y_pos)
    mov ah, 02h
    mov bh, 00h           ; Página 0
    mov dh, [y_pos1]      ; Fila (Y)
    mov dl, [x_pos1]      ; Columna (X)
    int 10h
    
    ; Mostrar el texto desde SI
    call print_string;mov ah, 0x0E           ; Función para escribir caracteres

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
y_pos2 db 15              ; Posición inicial Y para 'Pedro


times 510-($-$$) db 0   ; Rellenar con ceros hasta 510 bytes
dw 0xAA55               ; Firma de arranque