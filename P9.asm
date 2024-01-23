; **** Encabezado ****
	list p=16F84A
#include P16F84A.inc
	__CONFIG   _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC
	radix dec
;===== Definicion de variables ================
PUERTOA 				EQU 05H
PUERTOB 				EQU 06H ; Declaración del puerto B en la dirección 06 H
;========VARIABLES PARA MANEJAR INTERRUPCION================
Contador        		equ     0x0C    ; Contador para detectar 4 desbordes de TMR0.-
W_Temp 		 		equ     0x0D    ; Registro para guardar temporalmente W.-
STATUS_Temp     equ     0x0E    ; Registro para guardar temporalmete STATUS
;=============Para el daly (retardo)========================
delay					equ		0x0F
delay1					equ		0x10
delay2					equ		0x11
;========VARIABLES PARA MANEJAR INTERRUPCION================
Frec					equ 0x12
Raiz2					equ 0x13
Copia					equ 0x14
BitsA					equ 0x15
Multi					equ 0x16
;**** Inicio del Micro ****
;Reset           
        org     0x00            ; Aquí comienza el micro.-
        goto    Inicio          ; Salto a inicio de mi programa.-
;**** Vector de Interrupcion ****
        org     0x04            ; Atiendo Interrupcion.-
        goto    Inicio_ISR
 
; **** Programa Principal ****
;**** Configuracion de puertos ***
        org     0x05            ; Origen del código de programa.-
Inicio          
        bsf     		STATUS,RP0     ; Pasamos de Banco 0 a Banco 1.-
        movlw   b'00000001'     	; RB0 como ENTRADA
        movwf   TRISB
        movlw   b'00000111'
        movwf   TRISA
        movlw   b'01000000'     	; Se selecciona INTERRUPCION EXTERNA
        movwf   OPTION_REG    
        bcf     STATUS,RP0      ; Paso del Banco 1 al Banco 0
	clrf	PUERTOB
	clrf	Contador
        ;variables para el ejercicio====
        clrf Frec
        clrf Raiz2
        clrf Copia
        clrf BitsA
	
        ;======
        movlw  	 b'10010000'     ; Habilitamos GIE y INTE (interrupción del   RB0 INTERRUPCION EXTERNA
        movwf   INTCON

;**** Bucle ****
Bucle           
	call	retardo1seg
        movlw  	b'10000000'     ; desHabilitamos INTE (interrupción del   RB0 INTERRUPCION EXTERNA
        movwf   INTCON
	call	VerificarFrecuencia
        movlw  	 b'10010000'     ; Habilitamos GIE y INTE (interrupción del   RB0 INTERRUPCION EXTERNA
        movwf   INTCON
	CLRF	Contador		
        goto    Bucle           ; sin necesidad de utilizar tiempo en un bucle de demora.-       
 
;**** Rutina de servicio de Interrupcion ****

;  Guardado de registro W y STATUS.-
Inicio_ISR
        btfss   INTCON,INTF             ; Consultamos si es por RB0.-
        retfie     ; No, Salimos de interrupción.-
        movwf   W_Temp  ; Copiamos W a un registro Temporario.-
        swapf   STATUS, W       ;Invertimos los nibles del registro STATUS.-
        movwf   STATUS_Temp     ; Guardamos STATUS en un registro temporal.-
;**** Interrupcion por RB0/INT****
	
	incf Contador,1
        bcf   INTCON,INTF    ; Borro bandera de control de Interrupcion.-
; Restauramos los valores de W y STATUS.-
        swapf   STATUS_Temp,W   ; Invertimos lo nibles de STATUS_Temp.-
        movwf   STATUS
        swapf   W_Temp, f      ; Invertimos los nibles y lo guardamos en el mismo registro.-
        swapf   W_Temp,W       ; Invertimos los nibles nuevamente y lo guardamos en W.-
        retfie                 ; Salimos de interrupción.-
;..........................................
 
 ;**************    b7,b6,b5,b4,b3,b2,b1 = g,f,e,d,c,b,a, respectivamente 

uno
    MOVLW  d'1'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return
dos
    MOVLW  d'2'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return   
tres
    MOVLW  d'3'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return
cuatro
    MOVLW  d'4'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return
cinco
    MOVLW  d'5'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return
seis
    MOVLW  d'6'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return
siete
    MOVLW  d'7'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return
ocho
    MOVLW  d'8'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return
nueve
    MOVLW  d'9'
    MOVWF Frec
    MOVF PORTA, W
    MOVWF BitsA
    BCF BitsA, 3
    return

Raiz_1
  movlw d'1'
  movwf BitsA
  return

Raiz_2
  movlw d'2'
  movwf BitsA
  return

ValidarRaiz
        movlw	1
	subwf	BitsA,0
	btfsc	STATUS,Z
	call	Raiz_1
	movlw	2
	subwf	BitsA,0
	btfsc	STATUS,Z
	call	Raiz_1
	movlw	3
	subwf	BitsA,0
	btfsc	STATUS,Z
	call	Raiz_1
	movlw	4
	subwf	BitsA,0
	btfsc	STATUS,Z
	call	Raiz_2
	movlw	5
	subwf	BitsA,0
	btfsc	STATUS,Z
	call	Raiz_2
	movlw	6
	subwf	BitsA,0
	btfsc	STATUS,Z
	call	Raiz_2
	movlw	7
	subwf	BitsA,0
	btfsc	STATUS,Z
	call	Raiz_2
 return

VerificarFrecuencia
	movlw	1
	subwf	Contador,0
	btfsc	STATUS,Z
	call	uno
	movlw	2
	subwf	Contador,0
	btfsc	STATUS,Z
	call	dos
	movlw	3
	subwf	Contador,0
	btfsc	STATUS,Z
	call	tres
	movlw	4
	subwf	Contador,0
	btfsc	STATUS,Z
	call	cuatro
	movlw	5
	subwf	Contador,0
	btfsc	STATUS,Z
	call	cinco
	movlw	6
	subwf	Contador,0
	btfsc	STATUS,Z
	call	seis
	movlw	7
	subwf	Contador,0
	btfsc	STATUS,Z
	call	siete
	movlw	8
	subwf	Contador,0
	btfsc	STATUS,Z
	call	ocho
	movlw	9
	subwf	Contador,0
	btfsc	STATUS,Z
	call	nueve
        call    ValidarRaiz
        call    ResolverEcuacion
	return

ResolverEcuacion:
   clrf Multi
   movf Raiz2, w
   movwf Copia
   movf Frec, w
suma:
   addwf Multi, f
   decfsz Copia, 1
   goto suma ;si no brinca
   clrf PORTA
   RLF Multi,W
   movf Multi, w
   movwf PORTB
return



; ************** retardo de 1 Segundo
;*************** Ciclo de Maquina = 5+4 .delay+ 4.delay.delay1+3.delay.delay1delay2
;********
retardo1seg
	movlw	9				;9 para un segundo
	movwf	delay
retardo1	
	movlw	145			;145 para un segundo
	movwf	delay1
retardo2
	movlw	254			;254 para un segundo
	movwf	delay2
retardo3
	decfsz	delay2,1
	goto	retardo3
	decfsz	delay1,1
	goto	retardo2
	decfsz	delay,1
	goto	retardo1
	return

;====================================================================
      END
