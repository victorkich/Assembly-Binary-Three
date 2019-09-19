# Create, Insert and Print 
  
 - ASSEMBLY BINARY THREE
 
 Equivalent create node in C
 ```
struct Node *CreateNode_asm (int key) {
    struct Node *newNode = (struct Node *)malloc(sizeof(struct Node));
    newNode->key = key;
    newNode->left = NULL;
    newNode->right = NULL;
    return newNode;    
} 
 ```
 
 Equivalent insert node in C
 
 ``` 
void Insert_i (struct BinarySerachTree *bst, int key) {
    struct Node *current;
    struct Node *parent;
    struct Node *newNode = CreateNode (key);
    if (bst->root == NULL)
        bst->root = newNode;
    else {
        current = bst->root;
        parent = NULL; 
        while (current != NULL) {
            parent = current;
            if (newNode->key > current->key) 
                current = current->right;
            else 
                current = current->left;
        }
        if (newNode->key > parent->key) 
            parent->right = newNode;
        else 
            parent->left = newNode;
    }   
    bst->size++;
} 
 ```
 
 Equivalent sorted print node in C

```
void PrintInOrder (struct Node root) {
    char buffer[] = %d ;
    if (root != NULL) {
        PrintInOrder (root-left);
        printf (buffer, root-key);
        PrintInOrder (root-right);
    }
}
```
 
