/*
#void Insert_i (struct BinarySerachTree *bst, int key) {
#    struct Node *current;
#    struct Node *parent;
#    struct Node *newNode = CreateNode (key);
#    if (bst->root == NULL)
#        bst->root = newNode;
#    else {
#        current = bst->root;
#        parent = NULL; 
#        while (current != NULL) {
#            parent = current;
#            if (newNode->key > current->key) 
#                current = current->right;
#            else 
#                current = current->left;
#        }
#        if (newNode->key > parent->key) 
#            parent->right = newNode;
#        else 
#            parent->left = newNode;
#    }   
#    bst->size++;
#}
*/

#include <iregdef.h>  

    .text
    .globl  Insert_i_asm             # Torna a fun��o Insert_i_asm visivel para outros programas      
    .ent    Insert_i_asm             # Ponto de entrada da fun��o
    
Insert_i_asm:

    //Par�metros recebidos: a0  <- *bst  
    //                      a1  <- key
    
    //Aloca o espa�o para n�o perder dados quando chamar o malloc
    addi sp, sp, - 36       # Aloca 36 bytes de memoria na pilha
    sw a0, 16(sp)           # Salva a struct *bst na pilha
    sw a1, 20(sp)           # Salva a key na pilha
    sw ra, 24(sp)           # Salva ra na pilha
    sw zero, 28(sp)         # *current <- null
    sw zero, 32(sp)         # *parent  <- null
   
    //struct Node *current;
    li a0, 12               # Passa 12 bytes como parametro para o malloc
    jal malloc              # Chama malloc
   
    //Transfere o endere�o da struct current para a pilha
    add t2, v0, zero        # t2 <- struct *current
    sw t2, 28(sp)           # Salva na pilha a struct *current
    
    //struct Node *parent;
    li a0, 12               # Passa 12 bytes como parametro para o malloc
    jal malloc              # Chama malloc
   
    //Transfere o endere�o da struct parent para a pilha
    add t3, v0, zero        # t3 <- struct *parent
    sw t3, 32(sp)           # Salva na pilha a struct *parent
  
    //struct Node *newNode = CreateNode (key);
    lw a0, 20(sp)           # a0 <- key
    jal CreateNode_asm      # Chama fun��o passando key como par�metro
    
    //Retorna o endere�o do CreateNode para t4 
    add t4, v0, zero        # t4 <- struct *newNode = CreateNode (key)
   
    //Retorna os valores da pilha para vatiaveis temporarias e para o ra
    lw t0, 16(sp)           # t0 <- struct *bst
    lw t1, 20(sp)           # t1 <- key
    lw ra, 24(sp)           # ra <- ra antigo
    lw t2, 28(sp)           # t2 <- struct *current
    lw t3, 32(sp)           # t3 <- struct *parent

    addi sp, sp, 36         # Desempilha a pilha

    //Verifica se a �rvore esta vazia
if0:  
    lw t5, 4(t0)            # t5 = bst->root
    bne t5, 0, else0        # Pula se t5 != null
    sw t4, 4(t0)            # t5 = newNode;
    j endif0                # Encerra o if
   
    // A �rvore n�o esta vazia
else0:
    lw t2, 4(t0)            # current = bst->root;
    li t3, 0                # parent = NULL;
   
    //Procura pelo n� pai correto para inserir o novo n�
while:
    add t5, t2, zero        # t5 = current
    beq t5, zero, endwhile  # Pula se t5 == null
    add t3, t2, zero        # parent = current;

    //Atualiza o n� atual dependendo do newNode-> key
if1: 
    lw t5, 0(t4)            # t5 = newNode->key
    lw t6, 0(t2)            # t6 = current->key
    slt t7, t6, t5          # t7 = t6 > t5
    beq t7, 0, else1        # Pula se t7 == 0
    lw t5, 8(t2)            # t5 = current->right
    add t2, t5, zero        # current = t5;
    j while                 # Nova repeti��o
   
else1:
    lw t5, 4(t2)            # t5 = current->left
    add t2, t5, zero        # current = t5;
    j while                 # Nova repeti��o
   
endwhile:

    //N� pai encontrado. O novo n� � inserido como filho da esquerda ou da direita
if2:
    lw t5, 0(t4)            # t5 = newNode->key
    lw t6, 0(t3)            # t6 = parent->key
    slt t7, t6, t5          # t7 = t6 > t5
    beq t7, 0, else2        # Pula se t7 == 0
    sw t4, 8(t3)            # parent->right = newNode;
    j endif0                # Encerra o if
   
else2:
    sw t4, 4(t3)            # parent->left = newNode;

endif0:
    lw t5, 0(t0)            # t5 = bst->size
    addi t5, t5, 1          # t5++
    sw t5, 0(t0)            # bst->size = t5

    //Retorna ao endere�o de execu��o do programa
    jr ra                   
   
.end Insert_i_asm
