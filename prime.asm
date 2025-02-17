;a program to display the all primes less than or equal to the specified input integer

;to change the Biggest number that can be analyzed,
;just change the Max and MaxInput defination,then recompile it.

;functions.asm includes some useful API for basic functions:
;  sprint(eax),sprintLF(eax)     eax : the address of the specified string to be displayed.
;  atoi(eax)                     eax : the address of the ascii characters to be transformed,
                                     ; and the result is also remained in it.
;  iprint(eax),iprintLF(eax)   eax : the value to be dispalyed.
;  quit()  

%include  'functions.asm'
%define   PerByte 8
%define   INPUTARRAYLENGTH 10
%define   Max 50000000
%define   MaxInput 10000000
%define   true '1'
%define   false '0'

SECTION .data
welcomeString        db      'Please enter a number which at the range of 1-10000000: ',0h 
; message string asking user for input

resultString         db      'the whole primers which less than ', 0h
 ; message string to use after user has input an valid integer   

StringFor0           db      'Invalid input: 0 ):',0h
StringFor1           db      'There is no primer less or equal than 1,and 1 is not a primer.',0h ;
StringFor2Big0       db      'Sorry,the number ',0h
StringFor2Big1       db      ' is too big to analyze ):',0h
StringForZeroError   db      'Zero Error occurs',0h
StringForError       db      'Zero Error occurs',0h
StringForCount0      db      'There are ',0h
StringForCount1      db      ' primes at all (:',0h
StringIsPrime        db      ' is a prime.',0h
StringIsNotPrime     db      ' is not a prime.',0h
colon                db      ':',0h              
space                db      ' ',0h  
FlagBytes: times Max db      true,0h
 
SECTION .bss
inputInt:  resb  INPUTARRAYLENGTH ; reserve a space in memory for the users input string
 
SECTION .text
global  main
 
main:
   mov   eax, welcomeString       ; display the welcome String
   call  sprint
   mov   edx, INPUTARRAYLENGTH    ; number of bytes to read
   mov   ecx, inputInt            ; reserved space to store our input (known as a buffer)
   mov   ebx, 0                   ; write to the STDIN file
   mov   eax, 3                   ; invoke SYS_READ (kernel opcode 3)
   int   80h
 
   mov   eax, inputInt            ; move our buffer into eax (Note: input contains a linefeed)
   call  atoi                     ; ascii to int ,both stored in eax
   push  eax                      ; preserve the integer
    
   ; begin test for input integer
   cmp   eax, 0                   ;test for 0
   jne   .testFor1
   mov   eax,StringFor0
   call  sprintLF
   call  quit
   
.testFor1:
   cmp   eax, 1                   ;test for 1
   jne   .testForTooBig
   mov   eax, StringFor1
   call  sprintLF
   call  quit

.testForTooBig:
   cmp   eax, MaxInput                 ; test for too big
   jle   .continue
   mov   eax, StringFor2Big0
   call  sprint
   pop   eax
   call  iprint
   mov   eax, StringFor2Big1
   call  sprintLF
   call  quit
   
.continue:        
   mov   eax, resultString        ;print the result
   call  sprint
   pop   eax                      ; restore the integer to eax
   push  eax                      ; preserve the integer
   mov   ebx, eax                 ; copy the integer to ebx
   call  iprint

   mov   eax, colon               ; print a ":"
   call  sprintLF

   mov   esi, 2                   ; begin with 2

    
.main: 
   mov   eax, ebx                 ; when beginning every loop,firstly restore the integer to eax
   cmp   eax, esi                 ; copmare the eax with the integer
   je    .resultAnalyze           ; if equals goto resultAnalyze
    
   ; test if the value in esi is already excluded,if true go to loop_end_work
   mov   edx, [FlagBytes+PerByte*esi]
   cmp   edx, false
   je    .loop_end_work

   mov   edx, 0                   ;necessray for div
   div   esi
   mov   ecx, eax                 ; keep the result in ecx
    
.child_loop:
   cmp   ecx, 1                   ; compare the result with 1 
   jle   .loop_end_work           ; if le ,goto the loop end,notices that it is accpeted by default.
   mov   eax, esi                 ; multiple work
   mul   ecx
   mov   edx, false               ; exclude the following integers.
   mov   [FlagBytes+PerByte*eax], edx
   dec   ecx 
   jmp   .child_loop              ; begin next child loop

.loop_end_work:
   inc   esi
   jmp   .main 
   
.resultAnalyze:                   ; analyze the flag bytes to selct the primes.
   mov   eax, ebx                 ; restore the integer
   
   mov   esi, 0                   ; initalize the counter
   
   mov   ebx, 2                   ; obviously, test begins with 2
   
.loopTest:
   cmp   eax, ebx                 ; check if ends
   jl    .count
   push  eax                      ; preserve
   
   mov   eax, ebx                 ; get the correspond flag value
   mov   edx, PerByte
   mul   edx
   add   eax, FlagBytes
   call  atoi

   cmp   eax, 0                   ; compare, if true,skip print
   je    .skipPrint
   
   push  eax                      ; print the accepted number following a space 
   mov   eax, ebx
   call  iprint
   mov   eax, space
   call  sprint
   pop   eax

   inc   esi                      ; increase the counter

.skipPrint:
   pop   eax                      ; restore
  
   inc   ebx   
   jmp   .loopTest

; print messgae about the counter
.count:
   push  eax
   mov   eax, space
   call  sprintLF                        
   mov   eax, StringForCount0     
   call  sprint 
   mov   eax, esi
   call  iprint
   mov   eax, StringForCount1
   call  sprintLF
   pop   eax
; test itself
.testItself:
   call  iprint 
   push  eax
   mov   edx, PerByte
   mul   edx
   add   eax, FlagBytes
   call  atoi
   cmp   eax, 0
   je    .notPrime
   mov   eax, StringIsPrime
   call  sprintLF
   pop   eax
   jmp   .isPrime 
.notPrime:
   mov   eax, StringIsNotPrime
   call  sprintLF  
   pop   eax
.isPrime:
;to be continued
.exit:
    call    quit