; ------------------------------------------------------------
; CMPR 154 - Final Project
; Project: Guess the Number
; Team Name : The Assemblers
; Team Member Names : Andrew Arnold, David Derramadero, Sovan Ly, Alyssa Ramos
; Creation Date : 11 / 19 / 2026
; Collaboration: Andrew Arnold, David Derramadero, Sovan Ly, Alyssa Ramos
; ------------------------------------------------------------
include Irvine32.inc

colorText PROTO txt : PTR BYTE, txtColor : DWORD
colorInt PROTO number : DWORD, intColor : DWORD

.data
; MENU STUFF
groupName BYTE "*** The Assemblers ***", 0
mainMenuTitle BYTE "*** MAIN MENU ***", 0
msg1 BYTE "Please select one of the following:", 0

option1Message BYTE "     1: Display my available credit", 0
option2Message BYTE "     2: Add credits to my account", 0
option3Message BYTE "     3: Play the guessing game", 0
option4Message BYTE "     4: Display my statistics", 0
exitMessage BYTE "     5: Exit", 0

cursorOffset BYTE "     Option: ", 0

invalidInput BYTE " Invalid Input (1 - 5) Only", 0

; OPTION 1 Finished data
displayAvailableBalance BYTE "Your available balance is: $", 0

; OPTION 2 Finished data
addCreditsPrompt BYTE "Please enter the amount you would like to add (0 - EXIT): ", 0
errorMessage_LessThan_Zero BYTE "Please enter an amount greater than -1! (Please try again)", 0
errorMessage_GreaterThan_Twenty BYTE "Please enter an amount less than or equal to Twenty! (Please try again)", 0
errorMessage_exceeds_Allowed_Balace BYTE "Exceeds amount able to add to balance! (Please try again)", 0
errorMessage_Not_Number BYTE "Please enter a valid number!", 0
displayAdded BYTE "The amout you have added: $ ", 0
displayNewBalance BYTE "Your new balance is: $", 0

; OPTION 3 Finished data
selectedOption3 BYTE "Welcome to the guessing game!", 0
insuficientFundsMsg BYTE "Insuficient funds. Try adding more...", 14, 10, 0
fundsDeductedMsg BYTE "$1 deducted from balance.", 14, 10, 0
guessMsg BYTE "Enter your guess, 1-10 only!", 14, 10, 0
lossMsgP1 BYTE "Better luck next time!", 14, 10, "The winning number was: ", 0
lossMsgP2 BYTE 14, 10, "You entered: ", 0
congratsMsg BYTE "YOU WON!!", 14, 10, "YOU GET $2!", 0
playAgainMsg BYTE "Do you want to play again?", 14, 10, "1 to play agian", 14, 10, "2 to return to main menu.", 0
returnToMenuMsg BYTE "Returning to main menu...", 14, 10, 0

; TEST EQUIPMENT
TESTMSG56 BYTE "this test message is here", 0

; OPTION 4 Finished Data
option4Menu BYTE "========== PLAYER STATISTICS ==========", 0
PlayNameHeader BYTE "	Player Name:       ", 0
AvailableCreditHeader BYTE "	Available Credit:  $", 0
GamesPlayedHeader BYTE "	Total Games Played:", 0
CorrectGuessesHeader BYTE "	Correct Guesses:   ", 0
MissedGuessesHeader BYTE "	Missed Guesses:    ", 0
MoneyWonHeader BYTE "	Money You Won:     $", 0
MoneyLostHeader BYTE "	Money You Lost:    $", 0


; OPTION 5 Finished data
selectedOption5 BYTE "Closing Program, Thank you!", 0

; NUMERIC VARIABLES
balance DWORD 0
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
playerName BYTE 16 DUP(0)
inputNamePrompt BYTE "Please enter your name: ", 0


.code
main proc

NamePrompt :

INVOKE colorText, ADDR groupName, lightBlue

call crlf
call crlf
mov edx, OFFSET inputNamePrompt
call WriteString

mov edx, OFFSET playerName
mov ecx, 15
call ReadString

mainMenu :
call Clrscr
; This is the Group Name Title
INVOKE colorText, ADDR groupName, lightBlue
call crlf
INVOKE colorText, ADDR mainMenuTitle, lightBlue
call crlf
call crlf

; This the is the Options allow Message
INVOKE colorText, ADDR msg1, cyan
call crlf
call crlf

; This is the first Option Listed
INVOKE colorText, ADDR option1Message, lightcyan
call crlf
call crlf

; This is the Second Option Listed
INVOKE colorText, ADDR option2Message, lightcyan
call crlf
call crlf

; This is the Third Option Listed
INVOKE colorText, ADDR option3Message, lightcyan
call crlf
call crlf

; This is the Fourth Option Listed
INVOKE colorText, ADDR option4Message, lightcyan
call crlf
call crlf

; This is the Exit Option Listed
INVOKE colorText, ADDR exitMessage, lightcyan
call crlf
call crlf

; This is the cursor offset
INVOKE colorText, ADDR cursorOffset, lightgray

; This is for reading input
call readInt

; Player Options
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

jmp option6; option 6 invalid choice

option1 :
; This prints out the currenty
; balance that the user has

Call Clrscr
mov edx, offset displayAvailableBalance
call writeString
INVOKE colorInt, balance, lightGreen
call crlf
call crlf
; just waits til the user enters something
; to go back the main menu
call WaitMsg
jmp mainMenu


option2 :

call Clrscr
; this prompts the user to enter funds to their account
; and reads the input
INVOKE colorText, ADDR addCreditsPrompt, lightgray
call readInt

; if they entered text instead of a number
jo errorInvalidNumber


mov creditsAdded, eax

cmp eax, 0
; jumps to label if it's less than 0
; since we used 0 as an exit
JE mainMenu
JL errorLessThanZero

cmp eax, MAX_ALLOWED
; compares the current eax to the max input
; if the number they entered was greater than 20
JG errorGreaterThanTwenty

; if it's between 0 - 20
jmp withinBounds

; Just shows them the error message and jumps back to option 2
errorLessThanZero:
INVOKE colorText, ADDR errorMessage_LessThan_Zero, lightred
call crlf
call WaitMsg
jmp option2

; Just shows them the error message and jumps back to option 2
errorGreaterThanTwenty:
INVOKE colorText, ADDR errorMessage_GreaterThan_Twenty, lightred

call crlf
call WaitMsg
jmp option2

; this is if it's between 0 - 20
withinBounds:
mov eax, balance
add eax, creditsAdded
cmp eax, MAX_ALLOWED

; if the balance and the added amount is greater than the allowed limit
JG exceedsLimit
; if the balance and the added amount is within the allowed limit
JMP allowsInput

; Just shows them the error message and jumps back to option 2
exceedsLimit:

INVOKE colorText, ADDR errorMessage_exceeds_Allowed_Balace, lightred
call crlf
call WaitMsg
jmp option2

; if the balance and the added amount is within the allowed limit
allowsInput :
mov balance, eax
INVOKE colorText, ADDR displayAdded, lightgray
INVOKE colorInt, balance, lightGreen

call crlf

INVOKE colorText, ADDR displayNewBalance, lightgray
INVOKE colorInt, balance, lightGreen

call crlf
call crlf

call WaitMsg
jmp mainMenu

; Just shows them the error message and jumps back to option 2
errorInvalidNumber:
INVOKE colorText, ADDR errorMessage_Not_Number, lightred
call crlf
call WaitMsg
jmp option2

; Starts the actual game
option3 :
call clrscr
INVOKE colorText, ADDR selectedOption3, lightcyan
call playTheGame
jmp mainMenu

; all these label does is print all the user stats
option4 :
Call Clrscr
INVOKE colorText, ADDR option4Menu, lightblue
call crlf

mov edx, offset PlayNameHeader
call writeString
INVOKE colorText, ADDR playerName, lightcyan
call crlf

mov edx, offset AvailableCreditHeader
call writeString
INVOKE colorInt, balance, lightGreen
call crlf

mov edx, OFFSET GamesPlayedHeader
call writeString
INVOKE colorInt, totalGames, lightGreen
call crlf

mov edx, OFFSET CorrectGuessesHeader
call writeString
INVOKE colorInt, correctGuesses, lightGreen
call crlf

mov edx, OFFSET MissedGuessesHeader
call writeString
INVOKE colorInt, missedGuesses, lightred
call crlf

mov edx, OFFSET MoneyWonHeader
call writeString
INVOKE colorInt, totalMoneyWon, lightgreen
call crlf

mov edx, OFFSET MoneyLostHeader
call writeString
INVOKE colorInt, totalMoneyLost, lightred
call crlf

call WaitMsg
jmp mainMenu

; displays a message that is ending the program and jumps to endProgram to end the program
option5 :
Call Clrscr
INVOKE colorText, ADDR selectedOption5, lightgray
call crlf
call crlf
mov eax, 500
call delay
jmp endProgram

; just the main menu error message
option6 :
Call Clrscr
INVOKE colorText, ADDR invalidInput, lightred
call crlf
call waitMsg
jmp mainMenu

endProgram :
exit

main endp

; so this function uses eax and edx, so it takes in a pointer thats the size
; of a byte, and a text color that is the size of DWORD
colorText PROC USES eax edx, txt:PTR BYTE, txtColor : DWORD


mov eax, txtColor
; sets the color here
call SetTextColor

; prints the text here
mov edx, txt
call WriteString

; Reset text color
mov eax, white
call SetTextColor

ret

colorText ENDP

colorInt PROC USES eax, number:DWORD, intColor : DWORD

mov eax, intColor
call SetTextColor

mov eax, number
call WriteDec

; Reset text color
mov eax, white
call SetTextColor

ret

colorInt ENDP


playTheGame proc
push EBP
mov ebp, esp

call crlf
call crlf
mov eax, 500
call delay
step1 :
mov eax, balance
cmp eax, 1
jae step2
call crlf
INVOKE colorText, ADDR insuficientFundsMsg, lightgray
mov eax, 1000
call delay
jmp returnToMainMenu
step2 :
call crlf
dec balance
inc totalGames
inc totalMoneyLost
INVOKE colorText, ADDR fundsDeductedMsg, yellow
call randomize
mov eax, 10
call randomRange
inc eax
mov random, eax
step3 :
INVOKE colorText, ADDR guessMsg, yellow
call ReadInt
jo step3
cmp eax, 1
jl step3
cmp eax, 10
jg step3
mov userGuess, eax
cmp eax, random
je winner
inc missedGuesses
INVOKE colorText, ADDR lossMsgP1, lightred
mov eax, random
call writeint
call crlf
INVOKE colorText, ADDR lossMsgP2, yellow
mov eax, userGuess
call writeint
call crlf
jmp step4
winner :
inc correctGuesses
add balance, 2
add totalMoneyWon, 2
call crlf
INVOKE colorText, ADDR congratsMsg, lightgreen
step4 :
INVOKE colorText, ADDR playAgainMsg, yellow
call crlf
call readint
cmp eax, 1
je step1
cmp eax, 2
je returnToMainMenu
jmp step4
returntoMainMenu :
INVOKE colorText, ADDR returnToMenuMsg, yellow
mov eax, 500
call delay


pop ebp
ret
playTheGame endp

end main
