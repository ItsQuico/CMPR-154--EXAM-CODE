INCLUDE Irvine32.inc

MAX_ALLOWED = 20

.data
titleText BYTE "*** The Assemblers ***",13,10,"*** MAIN MENU ***",13,10,0
namePrompt BYTE "Enter your name (up to 15 characters): ",0
menuText BYTE 13,10,"Please select one of the following:",13,10
         BYTE "1: Display my available credit",13,10
         BYTE "2: Add credits to my account",13,10
         BYTE "3: Play the guessing game",13,10
         BYTE "4: Display my statistics",13,10
         BYTE "5: Exit",13,10,"Enter your selection: ",0
balanceText BYTE "Your available balance is: $",0
amountPrompt BYTE "Please enter the amount you would like to add: ",0
creditError BYTE "Error: Maximum allowable credit is $20.00.",13,10
            BYTE "Please enter a different amount and try again.",13,10,0
numberError BYTE "Enter a whole number in the allowed range.",13,10,0
menuError BYTE "Invalid menu selection. Choose 1 through 5.",13,10,0
noCredit BYTE "You need at least $1 to play. Add credits first.",13,10,0
guessPrompt BYTE "Guess a number from 1 through 10: ",0
winText BYTE "Correct! You won $2.",13,10,0
loseText BYTE "Incorrect. The correct number was ",0
loseSuffix BYTE ". You lost this game.",13,10,0
againPrompt BYTE "Play again? (Y/N): ",0
againError BYTE "Please enter Y or N.",13,10,0
statsTitle BYTE 13,10,"========== PLAYER STATISTICS ==========",13,10,0
statsName BYTE "Player Name:       ",0
statsCredit BYTE "Available Credit:  $",0
statsGames BYTE "Games Played:      ",0
statsCorrect BYTE "Correct Guesses:   ",0
statsMissed BYTE "Missed Guesses:    ",0
statsWon BYTE "Money You Won:     $",0
statsLost BYTE "Money You Lost:    $",0
statsPause BYTE 13,10,"Press Enter to return to the main menu...",0
goodbye BYTE "Thanks for playing!",13,10,0

playerName BYTE 16 DUP(0)
inputBuffer BYTE 32 DUP(0)
balance DWORD 0
amount DWORD 0
correctGuesses DWORD 0
missedGuesses DWORD 0
targetNumber DWORD 0

.code
main PROC
    ; Start the random numbers and ask for the player's name.
    call Randomize
    mov edx,OFFSET titleText
    call WriteString
    mov edx,OFFSET namePrompt
    call WriteString
    mov edx,OFFSET playerName
    mov ecx,15
    call ReadString

menuLoop:
    ; Keep showing the menu until the player chooses 5.
    mov edx,OFFSET menuText
    call WriteString
    call ReadInt
    jo badMenu
    cmp eax,1
    je showBalance
    cmp eax,2
    je addCredit
    cmp eax,3
    je startGame
    cmp eax,4
    je showStats
    cmp eax,5
    je quitProgram
badMenu:
    mov edx,OFFSET menuError
    call WriteString
    jmp menuLoop

showBalance:
    ; Show how much credit is left.
    mov edx,OFFSET balanceText
    call WriteString
    mov eax,balance
    call WriteDec
    call Crlf
    jmp menuLoop

addCredit:
    ; Only add a positive amount if the total stays at $20 or less.
    mov edx,OFFSET amountPrompt
    call WriteString
    call ReadInt
    jo badAmount
    mov amount,eax
    cmp eax,1
    jb badAmount
    cmp eax,MAX_ALLOWED
    ja badAmount
    add eax,balance
    cmp eax,MAX_ALLOWED
    ja badAmount
    mov balance,eax
    jmp showBalance
badAmount:
    mov edx,OFFSET creditError
    call WriteString
    jmp menuLoop

startGame:
gameLoop:
    ; A new game costs $1. Make sure the player can pay first.
    cmp balance,1
    jb insufficientCredit
    dec balance
    mov eax,10
    call RandomRange
    inc eax
    mov targetNumber,eax
guessLoop:
    ; Keep asking until the guess is from 1 to 10.
    mov edx,OFFSET guessPrompt
    call WriteString
    call ReadInt
    jo badGuess
    cmp eax,1
    jb badGuess
    cmp eax,10
    ja badGuess
    cmp eax,targetNumber
    jne wrongGuess
    inc correctGuesses
    add balance,2
    mov edx,OFFSET winText
    call WriteString
    jmp askAgain
badGuess:
    mov edx,OFFSET numberError
    call WriteString
    jmp guessLoop
wrongGuess:
    ; Count a loss and show the number we picked.
    inc missedGuesses
    mov edx,OFFSET loseText
    call WriteString
    mov eax,targetNumber
    call WriteDec
    mov edx,OFFSET loseSuffix
    call WriteString
askAgain:
    ; Y starts another paid game. N goes back to the menu.
    mov edx,OFFSET againPrompt
    call WriteString
    mov edx,OFFSET inputBuffer
    mov ecx,SIZEOF inputBuffer-1
    call ReadString
    cmp eax,1
    jne badAgain
    mov al,inputBuffer
    cmp al,'Y'
    je gameLoop
    cmp al,'y'
    je gameLoop
    cmp al,'N'
    je menuLoop
    cmp al,'n'
    je menuLoop
badAgain:
    mov edx,OFFSET againError
    call WriteString
    jmp askAgain
insufficientCredit:
    mov edx,OFFSET noCredit
    call WriteString
    jmp menuLoop

showStats:
    ; Games played is wins plus losses. Each win pays $2.
    mov edx,OFFSET statsTitle
    call WriteString
    mov edx,OFFSET statsName
    call WriteString
    mov edx,OFFSET playerName
    call WriteString
    call Crlf
    mov edx,OFFSET statsCredit
    call WriteString
    mov eax,balance
    call WriteDec
    call Crlf
    mov edx,OFFSET statsGames
    call WriteString
    mov eax,correctGuesses
    add eax,missedGuesses
    call WriteDec
    call Crlf
    mov edx,OFFSET statsCorrect
    call WriteString
    mov eax,correctGuesses
    call WriteDec
    call Crlf
    mov edx,OFFSET statsMissed
    call WriteString
    mov eax,missedGuesses
    call WriteDec
    call Crlf
    mov edx,OFFSET statsWon
    call WriteString
    mov eax,correctGuesses
    shl eax,1
    call WriteDec
    call Crlf
    mov edx,OFFSET statsLost
    call WriteString
    mov eax,missedGuesses
    call WriteDec
    call Crlf
    mov edx,OFFSET statsPause
    call WriteString
    mov edx,OFFSET inputBuffer
    mov ecx,SIZEOF inputBuffer-1
    call ReadString
    jmp menuLoop

quitProgram:
    mov edx,OFFSET goodbye
    call WriteString
    exit
main ENDP

END main
