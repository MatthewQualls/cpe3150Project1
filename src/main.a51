
		ORG 250H	
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
NOFUNC:	LCALL DELAY
		
SW1:    MOV C, P2.1; Switch 1; Decrement Switch
		MOV P2.5, C; Light 1 on if button 1 pressed
		JC SW2
		MOV A, R0
		JZ ROLL0		;if A is zero, then do Rollover function
BACK1:	DEC A
		MOV R0, A
		LCALL DELAY
		SETB P2.5
		LCALL DELAY
		
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
		LCALL DELAY
		SETB P2.6
		LCALL DELAY
		
SW3:	MOV C, P0.3; Switch 3; Selector Switch
		MOV P0.7, C; Light 3 on if button 3 pressed
		JC WATCH;
		;Activate Code
		LCALL DELAY
		SETB P0.7
		LCALL FS;
		
		LJMP WATCH
		
		
		
ROLL0:	ACALL ROLL
		LCALL DELAY
		SETB P2.5
		LCALL DELAY
		MOV R0, #15D
		LJMP WATCH
		
ROLL15:	ACALL ROLL
		LCALL DELAY
		SETB P2.5
		LCALL DELAY
		LJMP RESET
		
ROLL:   CLR P1.6
		LCALL SOUND1 ;make a beep
		LCALL DELAY
		LCALL DELAY
		SETB P1.6
		RET
		
			
		
FS:		;Function Select based on R0
		MOV DPTR, #TABLE
		MOV A, R0
		MOVC A, @A+DPTR
		
		JZ INVALID;
		Mov R1, A
FS1:	DJNZ R1, FS2
		LCALL F1
		JMP done
FS2:    DJNZ R1, FS3
		LCALL F2
		JMP done
FS3:	DJNZ R1, FS4
		LCALL F3
		JMP done
FS4:	DJNZ R1, done
		LCALL F4
		JMP done

INVALID:CLR P0.4
		LCALL DELAY
		SETB P0.4
DONE:   RET
		
		
		
		
F1:     ;funct1 Tim Regan
		LCALL CLEAR
		
		CLR P1.6
		CLR P0.5
		LCALL DELAY
		LCALL DELAY
		LCALL DELAY
		SETB P0.5
		CLR P2.7
		LCALL DELAY
		LCALL DELAY
		LCALL DELAY
		SETB P2.7
		
		LCALL CLEAR
		RET
F2:     ;funct2 Blake Patornum
		LCALL CLEAR
		LCALL TEMP
		LCALL CLEAR
		RET
F3:     ;funct3 Matthew Qualls
		LCALL CLEAR
		LCALL TEMP
		LCALL CLEAR
		RET
F4:     ;funct4 Myles Hammerdude
		LCALL CLEAR
		LCALL TEMP
		LCALL CLEAR
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
		LCALL DELAY
		SETB P1.6
		LCALL DELAY
		CLR P0.4
		LCALL DELAY
		SETB P0.4
		LCALL DELAY
		CLR P1.6
		LCALL DELAY
		SETB P1.6
		LCALL DELAY
		CLR P0.4
		LCALL DELAY
		SETB P0.4
		RET
		
SOUND1: ;make a sound
		MOV R3, #32
LOOP3:	MOV R2, #32
LOOP2:	MOV R1, #32
LOOP1:	MOV R4, #32
LOOP0:	CLR P1.7
		NOP
		NOP
		NOP
		NOP
		NOP
		SETB P1.7
		DJNZ R4, LOOP0
		DJNZ R1, LOOP1
		DJNZ R2, LOOP2
		DJNZ R3, LOOP3
		RET
		
		END