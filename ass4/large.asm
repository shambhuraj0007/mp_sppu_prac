section .data
 msg: db 'the largest no is:',0
 len: equ $ -msg
 Arr: dd 0x1aaaaaa1, 0x22,0x11,0x33,0x444
 
 section .bss
   count: resb 1
   result: resb 15
   
section .text

global _start:

_start:
 
  mov eax,4
  mov ebx,1
  mov ecx,msg
  mov edx, len
   int 80h
   
   ;initialize count and setup loop
   
   mov byte[count],5
   mov eax,0
   mov esi,Arr
   
Loop1:
 ;compare current value at[esi] with the laggest found is eax
  cmp eax,[esi]
  jnc next
  mov eax,[esi]
 
 next:
  add esi,4
  dec byte[count]
  jnz Loop1
 
  mov ebx,eax
  mov esi,result
  mov byte[count],8
  mov cl,4
 
  L1:
    rol ebx,cl
    mov dl,bl
    and dl,0x0f
    cmp dl,9
    jbe L2
    add dl,7
   
  L2:
   add dl,30h
   mov[esi],dl
   inc esi
   dec byte[count]
   jnz L1
   
   mov byte[esi],0AH
   mov edx,esi
   sub edx,result
   mov ecx, result
   mov ebx,1
   mov eax,4
   int 80h
   
   mov eax,1
   mov ebx,0
   int 80h  
