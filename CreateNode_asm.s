/*
#struct Node *CreateNode_asm (int key) {
#    struct Node *newNode = (struct Node *)malloc(sizeof(struct Node));
#    newNode->key = key;
#    newNode->left = NULL;
#    newNode->right = NULL;
#    return newNode;    
#}
*/

#include <iregdef.h>       
	
    .text
    .globl  CreateNode_asm             # Torna a fun��o CreateNode_asm visivel para outros programas 
    .ent    CreateNode_asm             # Ponto de entrada da fun��o
    
CreateNode_asm:

    //Par�metros recebidos: a0 <- key
    
    //Aloca o espa�o para n�o perder dados quando chamar o malloc
    addi sp, sp, -24        # Aloca 24 bytes de memoria na pilha
    sw ra, 20(sp)           # Salva ra na pilha
    sw a0, 16(sp)           # Salva key na pilha

    //struct Node *newNode = (struct Node *)malloc(sizeof(struct Node));
    li a0,12                # Passa 12 bytes como parametro para o malloc
    jal malloc              # Chama o malloc

    //Administra os valores da pilha
    lw t0, 16(sp)           # t0 <- key
    lw ra, 20(sp)           # ra <- antigo ra

    //Seta os valores do newNode
    sw t0,0(v0)             # newNode->key = key;
    sw zero,4(v0)           # newNode->left = NULL;
    sw zero,8(v0)           # newNode->right = NULL;
    addi sp, sp, 24         # Desempilha a pilha
    
    //Retorna ao endere�o de execu��o do programa
    jr ra
   
.end CreateNode_asm