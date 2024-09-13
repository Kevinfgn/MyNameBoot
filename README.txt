Para ejecutar el booteable se deben tener instalado lo siguiente en el sistema operativo linux.
1)NASM
2)QEMU
3)MAKE

Estos 3 se pueden instalar usando el siguiente comando: 
sudo apt update                       
sudo apt install nasm make qemu -y

Luego para comprobar su instalación se comprueba la instalación con los siguientes comandos.
nasm -v    
make -v       
qemu-system-x86_64 --version 

Para ejecutar el booteable se debe acceder a la carpeta donde se encuentra el MakeFile con el comando cd´
y ejecutar el siguiente comando en la termina

make run

Luego se debería ejecutar el booteable.




