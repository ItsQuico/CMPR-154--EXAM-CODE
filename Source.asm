COMMENT @
	Program Description : A four part homework assignment aimed to test various aspects of MASM coding language
	Author : 
	Creation Date : 
    Language: IA - 32 x 86
    Assembler : Microsoft Macro Assembler(MASM)
    Collaboration : None.
@



INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4896

ExitProcess proto, dwExitCode : dword


.data
; MENU STUFF
groupName BYTE "*** Team Name *** *** MAIN MENU ***", 0
msg1 BYTE "Please select one of the following:", 0
playerName BYTE "howdy", 0

option1Message BYTE "     1: Display my available credit", 0
option2Message BYTE "     2: Add credits to my account", 0
option3Message BYTE "     3: Play the guessing game", 0
option4Message BYTE "     4: Display my statistics", 0

cursorOffset BYTE "     Option: ", 0

invalidInput BYTE " Invalid Input (1 - 5) Only", 0

selectedOption1 BYTE "YAY Option 1 Works", 0
selectedOption2 BYTE "YAY Option 2 Works", 0
selectedOption3 BYTE "Welcome to the guessing game!", 0
selectedOption4 BYTE "YAY Option 4 Works", 0
selectedOption5 BYTE "Closing Program, Thank you!", 0

exitMessage BYTE "     5: Exit", 0


;GAME MESSAGES
insuficientFundsMsg BYTE "Insuficient funds. Try adding more...",14,10, 0
fundsDeductedMsg BYTE "$1 deducted from balance.", 14,10, 0
guessMsg BYTE "Enter your guess, 1-10 only!",14,10, 0
lossMsgP1 BYTE "Better luck next time!", 14,10, "The winning number was: ", 0
lossMsgP2 BYTE 14,10, "You entered: ", 0
congratsMsg BYTE "YOU WON!!", 14,10, "YOU GET $2!", 0
playAgainMsg BYTE "Do you want to play again?",14,10, "1 to play agian", 14,10,"2 to return to main menu.", 0
returnToMenuMsg BYTE "Returning to main menu...",14,10, 0


; NUMERIC VARIABLES
balance DWORD 10
MAX_ALLOWED DWORD 20
amount DWORD 0
correctGuesses DWORD 0
missedGuesses DWORD 0
random DWORD ?
userGuess DWORD ?


; TEST EQUIPMENT
TESTMSG56 BYTE "this test message is here", 0


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

; This is the first Option Listed
mov edx, offset option1Message
call writeString
call crlf
call crlf


; This is the Second Option Listed
mov edx, offset option2Message
call writeString
call crlf
call crlf


; This is the Third Option Listed
mov edx, offset option3Message
call writeString
call crlf

call crlf

; This is the Fourth Option Listed
mov edx, offset option4Message
call writeString
call crlf
call crlf

; This is the Exit Option Listed
mov edx, offset exitMessage
call writeString
call crlf
call crlf

; This is the cursor offset
mov edx, offset cursorOffset
call writeString


UserMenuInput:
		

	call readInt
		cmp eax, 1
		jz option1
		jb option6

		cmp eax, 2
		jz option2

		cmp eax, 3
		jz option3

		cmp eax, 4
		jz option4

		cmp eax, 5
		jz option5

		cmp eax, 6
		jae option6; option 6 invalid choice

		;are we going to be adjusting edx here? if not, probably need to just do a jump vs loop?
		loop UserMenuInput

		option1 :
	mov edx, offset selectedOption1
		call writeString
		jmp UserMenuInput


		option2 :
	mov edx, offset selectedOption2
		call writeString
		jmp UserMenuInput


		option3 :
	mov edx, offset selectedOption3
		call writeString
		call playTheGame
		jmp UserMenuInput

		option4 :
	mov edx, offset selectedOption4
		call writeString
		jmp UserMenuInput

		option5 :
	call crlf
		mov edx, offset selectedOption5
		call writeString
		call crlf
		call crlf
		jmp endProgram


		option6 :
	; call crlf
		mov edx, offset invalidInput
		call writeString
		; call crlf
		jmp UserMenuInput

		endProgram :
	; HERE WOULD BE A GREAT SPOT TO USE YOUR DELAY FEATURE, AND A GOODBYE MESSAGE.
		exit

		main endp


		playTheGame proc
		push EBP
		mov ebp, esp

		call crlf
		call crlf
		mov eax, 5000
		call delay
		step1 : mov eax, balance
		cmp eax, 1
		jae step2
		mov edx, OFFSET insuficientFundsMsg
		call writeString
		jmp returnToMainMenu
		step2 : dec balance
		mov edx, OFFSET fundsDeductedMsg
		call writestring
		call randomize
		mov eax, 9
		call randomRange
		inc eax
		mov random, eax
		step3 : mov edx, OFFSET guessMsg
		call writestring
		call readint
		cmp eax, 1
		jb step3
		cmp eax, 10
		ja step3
		jo step3
		mov userGuess, eax
		cmp eax, random
		je winner
		mov edx, OFFSET lossMsgP1
		call writestring
		mov eax, random
		call writeint
		call crlf
		mov edx, OFFSET lossMsgP2
		call writestring
		mov eax, userGuess
		call writeint
		call crlf
		jmp step4
winner: inc correctGuesses
		add balance, 2
		mov edx, OFFSET congratsMsg
		call writestring
step4:  mov edx, OFFSET playAgainMsg
		call writestring
		call readint
		cmp eax, 1
		je step1
		cmp eax, 2
		je returnToMainMenu
		jmp step4
returntoMainMenu:
		mov edx, OFFSET returnToMenuMsg
		call writestring
		mov eax, 5000
		call delay


		pop ebp
		ret
playTheGame endp

		end main
