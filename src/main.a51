
		ORG 400H	
		  ;0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
TABLE: 	DB 0, 1, 0, 0, 2, 0, 0, 3, 0, 0, 4, 0, 0, 0, 0, 0
		
		ORG 0H
		
		MOV 0xA4,#0		; set Port 2 to bi-directional
		MOV 0x91,#0		; set Port 1 to bi-directional
		MOV 0x84,#0		; set Port 0 to bi-directional

RESET:	MOV R0, #00H; Counter Registerrrrr
		
WATCH:	;update lights
        MOV A, R0;
		CPL A;
		MOV C, ACC.3;
		MOV P0.6, C;
		MOV C, ACC.2;
		MOV P2.4, C;
		MOV C, ACC.1;
		MOV P0.5, C;
		MOV C, ACC.0;
		MOV P2.7, C;
		
		;if there is func available here, turn on bottom middle button
		MOV DPTR, #TABLE
		MOV A, R0
		MOVC A, @A+DPTR
		JZ NOFUNC
		CLR P0.7
NOFUNC:	ACALL DELAY
		
SW1:    MOV C, P2.1; Switch 1; Decrement Switch
		MOV P2.5, C; Light 1 on if button 1 pressed
		JC SW2
		MOV A, R0
		JZ ROLL0		;if A is zero, then do Rollover function
BACK1:	DEC A
		MOV R0, A
		ACALL DELAY
		SETB P2.5
		ACALL DELAY
		
SW2:	MOV C, P2.2; Switch 2; Increment Switch
		MOV P2.6, C; Light 2 on if button 2 pressed	
		JC SW3
		MOV A, R0
		MOV R3, #0FH
		XRL A, R3 ;if a = 15
		JZ ROLL15 ;then call rollover
BACK2:	MOV A, R0
		INC A
		MOV R0, A
		ACALL DELAY
		SETB P2.6
		ACALL DELAY
		
SW3:	MOV C, P0.3; Switch 3; Selector Switch
		MOV P0.7, C; Light 3 on if button 3 pressed
		JC WATCH;
		;Activate Code
		ACALL DELAY
		SETB P0.7
		ACALL FS;
		
		LJMP WATCH
		
		
		
ROLL0:	CLR P1.6
		ACALL SOUND1
		ACALL SOUND2
		ACALL SOUND1
		ACALL DELAY
		SETB P1.6
		ACALL DELAY
		SETB P2.5
		ACALL DELAY
		MOV R0, #15D
		LJMP WATCH
		
ROLL15:	CLR P1.6
		ACALL SOUND2
		ACALL SOUND1
		ACALL SOUND2
		ACALL DELAY
		SETB P1.6
		ACALL DELAY
		SETB P2.5
		ACALL DELAY
		LJMP RESET
		
			
		
FS:		;Function Select based on R0
		MOV DPTR, #TABLE
		MOV A, R0
		MOVC A, @A+DPTR
		
		JZ INVALID;
		MOV R1, A
FS1:	DJNZ R1, FS2
		ACALL F1
		JMP done
FS2:    DJNZ R1, FS3
		ACALL F2
		JMP done
FS3:	DJNZ R1, FS4
		ACALL F3
		JMP done
FS4:	DJNZ R1, done
		ACALL F4
		JMP done

INVALID:CLR P0.4
		ACALL SOUND3
		SETB P0.4
DONE:   RET
		
		
		
		
F1:     ;funct1 Tim Regan
		ACALL CLEAR
		;BEGIN TIM'S PROGRAM ----------------------------------------------
		
STRT:	CLR P1.6
		CLR P0.5
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		SETB P0.5
		CLR P2.7
		ACALL SOUND2
		MOV C, P1.4
		JNC FIN1
		
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		SETB P2.7
		CLR P0.4
		ACALL SOUND1
		MOV C, P1.4
FIN1:	JNC FIN
		
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		SETB P0.4
		CLR P2.6
		ACALL SOUND2
		MOV C, P1.4
		JNC FIN
		
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		SETB P2.6
		CLR P0.7
		ACALL SOUND1
		MOV C, P1.4
		JNC FIN
		
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		SETB P0.7
		CLR P2.5
		ACALL SOUND2
		MOV C, P1.4
		JNC FIN
		
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		SETB P2.5
		CLR P0.6
		ACALL SOUND1
		MOV C, P1.4
		JNC FIN
		
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		SETB P0.6
		CLR P2.4
		ACALL SOUND2
		MOV C, P1.4
		JNC FIN
		
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		SETB P2.4
		CLR P0.5
		ACALL SOUND1
		MOV C, P1.4
		JNC FIN
		JMP STRT
		
		;END TIM'S PROGRAM ----------------------------------------------
		
FIN:	ACALL CLEAR
		RET
		
		
F2:     ;funct2 Blake Patornum
		ACALL CLEAR
		
		;BEGIN BLAKE'S PROGRAM ----------------------------------------------
		ACALL SOUND1
		
		CLR P2.4
		CLR P2.5
		CLR P2.6
		CLR P2.7
		CLR P0.4
		CLR P0.5
		CLR P0.6
		CLR P1.6
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		ACALL DELAY
		
CHECK:		
		MOV C, P2.0
		JC ON
		SETB P2.4
		ACALL SOUND1
		
ON:		MOV C,P0.1
		JC ON1
		SETB P0.5
		ACALL SOUND1
		
ON1:	MOV C, P2.3
		JC ON2
		SETB P2.7
		ACALL SOUND1
		
ON2:	MOV C, P0.2
		JC ON3
		SETB P0.6
		ACALL SOUND1
		
ON3:	MOV C, P1.4
		JC ON4
		SETB P1.6
		ACALL SOUND1
		
ON4:	MOV C, P0.0
		JC ON5
		SETB P0.4
		ACALL SOUND1
		
ON5:	MOV C, P2.1
		JC ON6
		SETB P2.5
		ACALL SOUND1
		
ON6:	MOV C, P2.2
		JC ON7
		SETB P2.6
		ACALL SOUND1
		
ON7:	MOV C, P0.3
		JNC EXIT
		LJMP CHECK 
		
		;END BLAKE's PROGRAM -----------------------------------------------
		
EXIT:	ACALL SOUND2
		ACALL CLEAR
		RET
		
F3:     ;funct3 Matthew Qualls
		ACALL CLEAR
		
		;BEGIN MATHEW'S PROGRAM -----------------------------------------------
		
		SHOW1:	MOV R1, #08;

SHOW1A: ;lightshow 1 time
		ACALL DELAY
		DJNZ R1, ULS1 ; if r1 == 0, roll over r1 to 8
		MOV R1, #08;
ULS1: 	; Update Light Show 1
		
		MOV A, R1
		MOV R2, A
; first number following tag is lightshow number
; second number following tag is to check if R1 == second num
TAG11:	DJNZ R2, TAG12 
		ACALL CLEAR
		CLR P2.4
		CLR P0.5
		JMP CHKXT
		
TAG12:  DJNZ R2, TAG13
		ACALL CLEAR
		CLR P2.4
		CLR P0.6
		JMP CHKXT
		
TAG13:  DJNZ R2, TAG14
		ACALL CLEAR
		CLR P2.5
		CLR P0.6
		JMP CHKXT
		
TAG14:  DJNZ R2, TAG15
		ACALL CLEAR
		CLR P2.5
		CLR P0.7
		JMP CHKXT
		
TAG15:  DJNZ R2, TAG16
		ACALL CLEAR
		CLR P2.6
		CLR P0.7
		JMP CHKXT
		
TAG16:  DJNZ R2, TAG17
		ACALL CLEAR
		CLR P2.6
		CLR P0.4
		JMP CHKXT
		
TAG17:  DJNZ R2, TAG18
		ACALL CLEAR
		CLR P2.7
		CLR P0.4
		JMP CHKXT
		
TAG18:  ACALL CLEAR
		CLR P2.7
		CLR P0.5

CHKXT:	;Check Exit switch 3
		MOV C, P0.3; Check if switch 3 is pressed
		;MOV P0.7, C; Light 3 on if switch 3 pressed
		JNC SHOW1A; Jump to beginning of this function if switch 3 pressed
		ACALL DELAY
		
		;END F3 -----------------------------------------------------------
		
		ACALL CLEAR
		RET
		
SHOW1B: LJMP SHOW1A
		
F4:     ;funct4 Myles Hammerdude
		ACALL CLEAR
		ACALL TEMP
		ACALL CLEAR
		RET

		

DELAY:	MOV R5, #03H
H:		MOV R6, #0FFH
R:		MOV R7, #0FFH
L: 		NOP
		NOP
		DJNZ R7, L
		DJNZ R6, R
		DJNZ R5, H
		RET
		
CLEAR:	SETB P2.4
		SETB P2.5
		SETB P2.6
		SETB P2.7
		SETB P0.4
		SETB P0.5
		SETB P0.6
		SETB P0.7
		SETB P1.6
		RET
		
TEMP:	CLR P1.6
		ACALL DELAY
		SETB P1.6
		ACALL DELAY
		CLR P0.4
		ACALL DELAY
		SETB P0.4
		ACALL DELAY
		CLR P1.6
		ACALL DELAY
		SETB P1.6
		ACALL DELAY
		CLR P0.4
		ACALL DELAY
		SETB P0.4
		RET
		
SOUND1: ;make a sound
		MOV R3, #12
LOOP13:	MOV R2, #16
LOOP12:	MOV R1, #32
LOOP11:	MOV R4, #64
LOOP10:	DJNZ R4, LOOP10
		DJNZ R1, LOOP11
		CPL P1.7 
		DJNZ R2, LOOP12
		DJNZ R3, LOOP13
		RET
		
SOUND2: ;make a sound
		MOV R3, #12
LOOP23:	MOV R2, #32
LOOP22:	MOV R1, #32
LOOP21:	MOV R4, #32
LOOP20:	DJNZ R4, LOOP20
		DJNZ R1, LOOP21
		CPL P1.7 
		DJNZ R2, LOOP22
		DJNZ R3, LOOP23
		RET

		
SOUND3: ;make a sound
		MOV B, #120
		MOV R3, #10
LOOP33:	MOV R2, #12
LOOP32:	DEC B
SKP:	MOV R1, B
LOOP31:	MOV R4, #120
LOOP30:	DJNZ R4, LOOP30
		DJNZ R1, LOOP31
		CPL P1.7 
		DJNZ R2, LOOP32
		DJNZ R3, LOOP33
		RET
		
SOUND4: ;make a sound
		MOV R3, #3
LOOP43:	MOV R2, #16
LOOP42:	MOV R1, #120
LOOP41:	MOV R4, #120
LOOP40:	DJNZ R4, LOOP40
		DJNZ R1, LOOP41
		CPL P1.7 
		DJNZ R2, LOOP42
		DJNZ R3, LOOP43
		RET
		
		END