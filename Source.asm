; ------------------------------------------------------------
; CMPR 154 - Final Project
; Project: Guess the Number
; Team Name: The Assemblers
; Team Member Names: Andrew Arnold, David Derramadero, Sovan Ly, Alyssa Ramos
; Creation Date: 11/19/2026
; Collaboration: Andrew Arnold, David Derramadero, Sovan Ly, Alyssa Ramos
; ------------------------------------------------------------
include Irvine32.inc

.data
; MENU STUFF
groupName BYTE "*** The Assemblers ***" ,14,10, "*** MAIN MENU ***", 0
msg1 BYTE "Please select one of the following:" ,0
playerName BYTE "howdy", 0

option1Message BYTE "     1: Display my available credit" ,0
option2Message BYTE "     2: Add credits to my account" ,0
option3Message BYTE "     3: Play the guessing game" ,0
option4Message BYTE "     4: Display my statistics" ,0
exitMessage BYTE "     5: Exit" ,0
cursorOffset BYTE "     Option: ", 0
invalidInput BYTE " Invalid Input (1 - 5) Only" ,0

; OPTION 1 Finished data
displayAvailableBalance BYTE "Your available balance is: $" ,0

; OPTION 2 Finished data
addCreditsPrompt BYTE "Please enter the amount you would like to add: " ,0
errorMessage_LessThan_Zero BYTE "Please enter an amount greater than Zero!", 0
errorMessage_GreaterThan_Twenty BYTE "Please enter an amount less than or equal to Twenty!", 0
errorMessage_exceeds_Allowed_Balace BYTE "Exceeds amount able to add to balance!", 0 
errorMessage_Not_Number BYTE "Please enter a valid number!", 0
displayAdded BYTE "The amout you have added: $ ",0
displayNewBalance BYTE "Your new balance is: $",0 

selectedOption3 BYTE "YAY Option 3 Works" ,0

; OPTION 4 working on Data
option4Menu BYTE "========== PLAYER STATISTICS ==========", 0 
PlayNameHeader BYTE "	Player Name:       ", 0
AvailableCreditHeader BYTE "	Available Credit:  $", 0
GamesPlayedHeader BYTE "	Games Played:      ", 0
CorrectGuessesHeader BYTE "	Correct Guesses:   ", 0
MissedGuessesHeader BYTE "	Missed Guesses:    ", 0
MoneyWonHeader BYTE "	Money You Won:     $", 0
MoneyLostHeader BYTE "	Money You Lost:    $", 0


;OPTION 5 Finished data
selectedOption5 BYTE "Closing Program, Thank you!" ,0

; NUMERIC VARIABLES
balance DWORD 10
MAX_ALLOWED DWORD 20
amount DWORD 0
correctGuesses DWORD 0
missedGuesses DWORD 0
totalGames DWORD 0
random DWORD ?
userGuess DWORD ?
creditsAdded DWORD ?
totalMoneyWon DWORD 0
totalMoneyLost DWORD 0

; ALL PURPUSE USER INPUT STUFF
userInput DWORD ?

.code
main proc

	mainMenu:
	call Clrscr
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

	call readInt
	
	cmp eax, 1
	je option1

	cmp eax, 2
	je option2

	cmp eax, 3
	je option3

	cmp eax, 4
	je option4
	
	cmp eax, 5
	je option5

	jmp option6 ; option 6 invalid choice

 option1:
	Call Clrscr
	mov edx , offset displayAvailableBalance
	call writeString
	mov eax, balance
	call writeInt
	call crlf
	call crlf
	call WaitMsg
	jmp mainMenu


option2:
	call Clrscr
    mov edx, OFFSET addCreditsPrompt
    call WriteString
	
	call readInt
	jo errorInvalidNumber
	
	mov creditsAdded, eax

	cmp eax, 0
	JLE errorLessThanZero

	cmp eax, 20
	JG errorGreaterThanTwenty

	jmp withinBounds

	errorLessThanZero:
		mov edx, OFFSET errorMessage_LessThan_Zero 
		call WriteString
		call crlf
		call WaitMsg
		jmp mainMenu

	errorGreaterThanTwenty:
		mov edx, OFFSET errorMessage_GreaterThan_Twenty
		call WriteString
		call crlf
		call WaitMsg
		jmp mainMenu

	withinBounds:
		mov eax, balance
		add eax, creditsAdded
		cmp eax, 20
		JG exceedsLimit
		JMP allowsInput
		exceedsLimit:
			mov edx, OFFSET errorMessage_exceeds_Allowed_Balace
			call WriteString
			call crlf
			call WaitMsg
			jmp mainMenu
   
		allowsInput:
			mov balance, eax

			mov edx, OFFSET displayAdded
			call WriteString 
			mov eax, creditsAdded
			call WriteInt

			call crlf

			mov edx, OFFSET displayNewBalance
			call WriteString 
			mov eax, balance
			call WriteInt

			call crlf
			call WaitMsg
			jmp mainMenu

	errorInvalidNumber:
		mov edx, OFFSET errorMessage_Not_Number
		call WriteString 
		call crlf
		call WaitMsg
		jmp mainMenu

option3:
	Call Clrscr
	mov edx , OFFSET selectedOption3
	call writeString
	call crlf
    call crlf
    call WaitMsg
	jmp mainMenu

option4:
	Call Clrscr
	mov edx, offset option4Menu
	call writeString
	call crlf

    mov edx, offset PlayNameHeader
	call writeString
	mov edx, offset playerName
	call writeString
	call crlf

	mov edx, offset AvailableCreditHeader
	call writeString
	mov eax, balance
	call writeInt
	call crlf

	mov edx, OFFSET GamesPlayedHeader 
	call writeString
	mov eax, totalGames
	call writeInt
	call crlf

	mov edx, OFFSET CorrectGuessesHeader
	call writeString
	mov eax, correctGuesses
	call writeInt
	call crlf

	mov edx, OFFSET MissedGuessesHeader
	call writeString
	mov eax, missedGuesses 
	call writeInt
	call crlf

	mov edx, OFFSET MoneyWonHeader
	call writeString
	mov eax, totalMoneyWon
	call writeInt
	call crlf

	mov edx, OFFSET MoneyLostHeader
	call writeString
	mov eax, totalMoneyLost
	call writeInt
	call crlf

    call WaitMsg
	jmp mainMenu
	
option5:
	Call Clrscr
	mov edx, offset selectedOption5
	call writeString
	call crlf
	call crlf
	call WaitMsg
	jmp endProgram


option6:
	Call Clrscr
	mov edx, offset invalidInput
	call writeString
	call crlf
	call waitMsg
	jmp mainMenu

endProgram:

exit

main endp
end main



