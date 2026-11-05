;Name Header 
;hELLOW 
include Irvine32.inc

.data
; MENU STUFF
groupName BYTE "*** Team Name *** *** MAIN MENU ***", 0
msg1 BYTE "Please select one of the following:" ,0
option1Message BYTE "     1: Display my available credit" ,0
option2Message BYTE "     2: Add credits to my account" ,0
option3Message BYTE "     3: Play the guessing game" ,0
option4Message BYTE "     4: Display my statistics" ,0
exitMessage BYTE "     5: Exit" ,0
cursorOffset BYTE "     Option: ", 0
invalidInput BYTE " Invalid Input (1 - 5) Only" ,0

selectedOption1 BYTE "YAY Option 1 Works" ,0
selectedOption2 BYTE "YAY Option 2 Works" ,0
selectedOption3 BYTE "YAY Option 3 Works" ,0
selectedOption4 BYTE "YAY Option 4 Works" ,0
selectedOption5 BYTE "Closing Program, Thank you!" ,0

; USER INPUT STUFF
userInput DWORD ?


.code
main proc

    ; This is the Group Name Title
	mov edx, offset groupName
	call writeString
	call crlf
	call crlf
	
	; This the is the Options allow Message
	mov edx, offset msg1
	call writeString
	call crlf
	call crlf
	
	;This is the first Option Listed
	mov edx, offset option1Message
	call writeString
	call crlf
	call crlf
	
	
	;This is the Second Option Listed
	mov edx, offset option2Message
	call writeString
	call crlf
	call crlf
	
	
	;This is the Third Option Listed
	mov edx, offset option3Message
	call writeString
	call crlf
	call crlf
	
	;This is the Fourth Option Listed
	mov edx, offset option4Message
	call writeString
	call crlf
	call crlf
	
	;This is the Exit Option Listed
	mov edx, offset exitMessage
	call writeString
	call crlf
	call crlf

	;This is the cursor offset
	mov edx, offset cursorOffset
	call writeString


 again:
	call readInt
	cmp eax, 1
	jz option1

	cmp eax, 2
	jz option2

	cmp eax, 3
	jz option3

	cmp eax, 4
	jz option4
	
	cmp eax, 5
	jz option5

	jb option6 ; option 6 invalid choice

 loop again

 option1:
	mov edx , offset selectedOption1
	call writeString
	jmp again


option2:
	mov edx, offset selectedOption2
	call writeString
	jmp again


option3:
	mov edx , offset selectedOption3
	call writeString
	jmp again

option4:
	mov edx, offset selectedOption4
	call writeString
	jmp again

option5:
	call crlf
	mov edx, offset selectedOption5
	call writeString
	call crlf
	call crlf
	jmp endProgram


option6:
	; call crlf
	mov edx, offset invalidInput
	call writeString
	;call crlf
	jmp again

endProgram:

exit

main endp
end main
