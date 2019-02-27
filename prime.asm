;a program to display the all primes less than or equal to the specified input integer
;functions.asm includes some useful API for basic functions:
 ;  sprint(eax),sprintLF(eax)     eax : the address of the specified string to be displayed.
 ;  atoi(eax)                     eax : the address of the ascii characters to be transformed,and the result is also remained in it.
 ;  iprintf(eax),iprintfLF(eax)   eax : the value to be dispalyed.
%include        'functions.asm'
%define PerByte 8
 %define INPUTARRAYLENGTH 10
 %define Max 1000
 %define true '1'
 %define false '0'
SECTION .data
welcomeString        db      'Please enter a number which at the range of 1-10000000: ',0h ; message string asking user for input
resultString         db      'the whole primers which less than ', 0h              ; message string to use after user has input an valid integer
StringFor0           db      'Invalid input: 0 ):',0h
StringFor1           db      'There is no primer less or equal than 1,and 1 is not a primer.',0h ;
StringFor2Big0       db      'Sorry,the number ',0h
StringFor2Big1       db      ' is too big to analyze ):',0h
StringForZeroError       db      'Zero Error occurs',0h
StringForError       db      'Zero Error occurs',0h
colon                db      ':',0h  ;a colon
space                db      ' ',0h  ;a space
FlagBytes:      times Max db true,0h
 
SECTION .bss
inputInt:     resb  INPUTARRAYLENGTH                     ; reserve a space in memory for the users input string

 
SECTION .text
global  main
 
main:
    mov     eax, welcomeString  ;display the welcome String
    call    sprint
    mov     edx, INPUTARRAYLENGTH        ; number of bytes to read
    mov     ecx, inputInt         ; reserved space to store our input (known as a buffer)
    mov     ebx, 0          ; write to the STDIN file
    mov     eax, 3          ; invoke SYS_READ (kernel opcode 3)
    int     80h
 
    mov     eax, inputInt   ; move our buffer into eax (Note: input contains a linefeed)
    call    atoi            ; ascii to int ,both stored in eax
    push    eax             ; prerserve the integer
    
    ;begin test for input integer
    cmp     eax,0 ;test for 0
    jne     .testFor1
    mov     eax,StringFor0
    call  sprintLF
    call quit
   
.testFor1:
    cmp     eax,1 ;test for 1
    jne     .testForTooBig
    mov     eax,StringFor1
    call    sprintLF
    call    quit

.testForTooBig:
    cmp     eax,Max ;test for too big
    jle     .continue
    mov     eax,StringFor2Big0
    call    sprint
    pop     eax
    call    iprint
    mov     eax,StringFor2Big1
    call    sprintLF
    call    quit
   
.continue:
            
    mov     eax, resultString ;print the result
    call    sprint
    pop     eax              ; restore the integer to eax
    push    eax             ; preserve the integer
    mov     ebx, eax        ; copy the integer to ebx
    call    iprint

    mov     eax,colon       ;print a ":"
    call    sprintLF

    mov esi,2  ;begin with 2

    
  .main: 
    mov eax,ebx         ;when beginning every loop,firstly restore the integer to eax
    cmp eax,esi         ;copmare the eax to the integer
    je  .resultAnalyze   ;if equals goto resultAnalyze
    ;test if the value in esi is already excluded,if true go to loop_end_work
    mov edx,[FlagBytes+PerByte*esi]
    cmp edx,false
    je  .loop_end_work
    mov edx,0
    div esi
    mov ecx,eax ; keep the result in ecx
    
    ; push eax
    ; mov eax,colon
    ; call sprint
    ; mov eax,ecx
    ; call iprintLF
    ; pop eax
 .child_loop:
    cmp ecx,1 ;compare the result with 1 
    jle .loop_end_work ;if le ,goto the loop end,notices that it is accpeted by default.
    mov eax,esi ;multiple work
    mul ecx
    mov edx,false ;exclude the following integers.
    mov [FlagBytes+PerByte*eax],edx
    dec ecx 
    jmp .child_loop ;begin next child loop

  .loop_end_work:
    inc esi
    jmp  .main 
   
.resultAnalyze: ;analyze the flag bytes to selct the primes.
   mov eax,ebx ;restore the integer
  ; call iprintLF
   mov ebx,2 ;test from 2
   .loopTest:
   cmp eax,ebx
   jl .exit
   push eax 
   mov eax,ebx
   mov edx,PerByte
   mul edx
   add eax,FlagBytes
   call atoi
   cmp eax,0
   je .skipPrint
   push eax
   mov eax,ebx
   call iprint
   mov eax,space
   call sprint
   pop eax
   .skipPrint:
    pop eax
    inc ebx
   jmp .loopTest
   
    ; mov     eax,FlagBytes+10000*PerByte
    ; call    atoi
    ; call    iprintLF

    ; mov eax,false
    ; mov [FlagBytes+10000*PerByte],eax
    ; mov     eax,FlagBytes+10000*PerByte
    ; call    atoi
    ; call    iprintLF
 .exit:
    call    quit