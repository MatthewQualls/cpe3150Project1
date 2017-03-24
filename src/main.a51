		ORG 250H	
Table: DB 0, 1, 0, 0, 2, 0, 0, 3, 0, 0, 4, 0, 0, 0, 0, 0
		
		ORG 0H
		MOV R0, #0H; Counter Registerrrrr
		;set leds 1; active low
		SETB P0.6; led2; bit3
		SETB P2.4; led1; bit2
		SETB P0.5; led4; bit1
		SETB P2.7; led7; bit0
		SETB P2.5; led3
		SETB P0.7; led6
		SETB P2.6; led9
		;set buttons 0; active high
		CLR P2.1; sw3
		CLR P0.3; sw6	
		CLR P2.2; sw9
		
		//SPEAKER
		SETB P1.7; hopefully output

watch:  ;update lights
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

sw1:    Mov C, P2.1; Switch 1; Decrement Switch
		Mov P2.5, C; Light 1 on if button 1 pressed
		JNC sw2
		MOV A, R0
		DEC A
		JNB ACC.4, skip1
		LCALL ROLL
skip1:  ANL A, #0FH
		MOV R0, A
		; Decrement Code

sw2:	Mov C, P2.2; Switch 2; Increment Switch
		Mov P2.6, C; Light 2 on if button 2 pressed		
		JNC sw3;
		MOV A, R0
		INC A
		JNB ACC.4, skip2
		LCALL ROLL
skip2:  ANL A, #0FH
		MOV R0, A
		; Increment Code
		
sw3:	Mov C, P0.3; Switch 3; Selector Switch
		Mov P0.7, C; Light 3 on if button 3 pressed
		JNC watch;
		;Activate Code
		LCALL FS;
		
		SJMP watch;
		
		ORG 300H
ROLL:  	;rollover stuff
		RET
FS:		;based on R0
		MOV DPTR, #Table
		MOV A, R0
		MOVC A, @A+DPTR
		
		JZ done;
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
done:   RET
		
F1:     ;funct1
		RET
F2:     ;funct2
		RET
F3:     ;funct3
		RET
F4:     ;funct4
		RET
		
		END	
		