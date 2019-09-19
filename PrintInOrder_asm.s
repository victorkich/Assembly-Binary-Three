
#void PrintInOrder (struct Node root) {
#    char buffer[] = %d ;
#    if (root != NULL) {
#        PrintInOrder (root-left);
#        printf (buffer, root-key);
#        PrintInOrder (root-right);
#    }
#}


#include iregdef.h

.data
    intFormat
    .asciiz %d 
    .text
    .globl  PrintInOrder_asm             # Torna a fun��o PrintInOrder_asm visivel para outros programas 
    .ent    PrintInOrder_asm             # Ponto de entrada da fun��o

PrintInOrder_asm

    Cria o char buffer[] = %d ;
    la t0, intFormat        # t0 - %d 
    
    Guarda o endere�o de retorno, o primeiro argumento na pilha e o buffer
    addi sp, sp, -28        # Aloca 28 bytes de memoria na pilha
    sw t0, 24(sp)           # Salva o buffer[] na pilha
    sw ra, 20(sp)           # Salva ra na pilha
    sw a0, 16(sp)           # Salva a struct Node root na pilha

    Carrega os valores do n� para os registradores temporarios t0, t1 e t2
    lw t0, 0(a0)            # t0 - key
    lw t1, 4(a0)            # t1 - left
    lw t2, 8(a0)            # t2 - right

    add t0, t0, t1          # root = key + left
    add t0, t0, t2          # root = root + right

    if(root != NULL)
    beq t0, zero, end       # Pula se root == 0

    PrintInOrder (root-left);
    lw a0, 4(a0)            # a0 - Node (left)
    jal PrintInOrder_asm    # Chama a recurs�o

    printf (buffer, root-key);
    lw a1, 16(sp)           # a1 - Node
    lw a1, 0(a1)            # a1 - Node (key)
    lw a0, 24(sp)           # a0 - buffer[]
    jal printf              # printf(%d , Node-Key);

    PrintInOrder (root-right);
    lw a0, 16(sp)           # a0 - Node
    lw a0, 8(a0)            # a0 - Node (right)
    jal PrintInOrder_asm    # Chama a recurs�o 

end
    lw ra, 20(sp)           # Retorna o endere�o de retorno para o ra
    addi sp, sp, 28         # Desempilha a pilha
    
    Retorna ao endere�o de execu��o do programa
    jr ra

.end PrintInOrder_asm