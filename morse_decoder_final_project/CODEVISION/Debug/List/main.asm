
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _button_pressed=R6
	.DEF _button_pressed_msb=R7
	.DEF _press_duration=R8
	.DEF _press_duration_msb=R9
	.DEF _idle_time=R10
	.DEF _idle_time_msb=R11
	.DEF _morse_index=R12
	.DEF _morse_index_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x4:
	.DB  LOW(_0x3),HIGH(_0x3),0x41,LOW(_0x3+3),HIGH(_0x3+3),0x42,LOW(_0x3+8),HIGH(_0x3+8)
	.DB  0x43,LOW(_0x3+13),HIGH(_0x3+13),0x44,LOW(_0x3+17),HIGH(_0x3+17),0x45,LOW(_0x3+19)
	.DB  HIGH(_0x3+19),0x46,LOW(_0x3+24),HIGH(_0x3+24),0x47,LOW(_0x3+28),HIGH(_0x3+28),0x48
	.DB  LOW(_0x3+33),HIGH(_0x3+33),0x49,LOW(_0x3+36),HIGH(_0x3+36),0x4A,LOW(_0x3+41),HIGH(_0x3+41)
	.DB  0x4B,LOW(_0x3+45),HIGH(_0x3+45),0x4C,LOW(_0x3+50),HIGH(_0x3+50),0x4D,LOW(_0x3+53)
	.DB  HIGH(_0x3+53),0x4E,LOW(_0x3+56),HIGH(_0x3+56),0x4F,LOW(_0x3+60),HIGH(_0x3+60),0x50
	.DB  LOW(_0x3+65),HIGH(_0x3+65),0x51,LOW(_0x3+70),HIGH(_0x3+70),0x52,LOW(_0x3+74),HIGH(_0x3+74)
	.DB  0x53,LOW(_0x3+78),HIGH(_0x3+78),0x54,LOW(_0x3+80),HIGH(_0x3+80),0x55,LOW(_0x3+84)
	.DB  HIGH(_0x3+84),0x56,LOW(_0x3+89),HIGH(_0x3+89),0x57,LOW(_0x3+93),HIGH(_0x3+93),0x58
	.DB  LOW(_0x3+98),HIGH(_0x3+98),0x59,LOW(_0x3+103),HIGH(_0x3+103),0x5A
_0x0:
	.DB  0x2E,0x2D,0x0,0x2D,0x2E,0x2E,0x2E,0x0
	.DB  0x2D,0x2E,0x2D,0x2E,0x0,0x2D,0x2E,0x2E
	.DB  0x0,0x2E,0x2E,0x2D,0x2E,0x0,0x2D,0x2D
	.DB  0x2E,0x0,0x2E,0x2E,0x2E,0x2E,0x0,0x2E
	.DB  0x2D,0x2D,0x2D,0x0,0x2D,0x2E,0x2D,0x0
	.DB  0x2E,0x2D,0x2E,0x2E,0x0,0x2E,0x2D,0x2D
	.DB  0x2E,0x0,0x2D,0x2D,0x2E,0x2D,0x0,0x2E
	.DB  0x2E,0x2D,0x0,0x2E,0x2E,0x2E,0x2D,0x0
	.DB  0x2E,0x2D,0x2D,0x0,0x2D,0x2E,0x2E,0x2D
	.DB  0x0,0x2D,0x2E,0x2D,0x2D,0x0,0x2D,0x2D
	.DB  0x2E,0x2E,0x0,0x57,0x6F,0x72,0x64,0x20
	.DB  0x73,0x74,0x6F,0x72,0x65,0x64,0x0,0x53
	.DB  0x79,0x73,0x74,0x65,0x6D,0x20,0x72,0x65
	.DB  0x73,0x65,0x74,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x03
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x3+3
	.DW  _0x0*2+3

	.DW  0x05
	.DW  _0x3+8
	.DW  _0x0*2+8

	.DW  0x04
	.DW  _0x3+13
	.DW  _0x0*2+13

	.DW  0x02
	.DW  _0x3+17
	.DW  _0x0*2+6

	.DW  0x05
	.DW  _0x3+19
	.DW  _0x0*2+17

	.DW  0x04
	.DW  _0x3+24
	.DW  _0x0*2+22

	.DW  0x05
	.DW  _0x3+28
	.DW  _0x0*2+26

	.DW  0x03
	.DW  _0x3+33
	.DW  _0x0*2+5

	.DW  0x05
	.DW  _0x3+36
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x3+41
	.DW  _0x0*2+36

	.DW  0x05
	.DW  _0x3+45
	.DW  _0x0*2+40

	.DW  0x03
	.DW  _0x3+50
	.DW  _0x0*2+33

	.DW  0x03
	.DW  _0x3+53
	.DW  _0x0*2+10

	.DW  0x04
	.DW  _0x3+56
	.DW  _0x0*2+32

	.DW  0x05
	.DW  _0x3+60
	.DW  _0x0*2+45

	.DW  0x05
	.DW  _0x3+65
	.DW  _0x0*2+50

	.DW  0x04
	.DW  _0x3+70
	.DW  _0x0*2+9

	.DW  0x04
	.DW  _0x3+74
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x3+78
	.DW  _0x0*2+1

	.DW  0x04
	.DW  _0x3+80
	.DW  _0x0*2+55

	.DW  0x05
	.DW  _0x3+84
	.DW  _0x0*2+59

	.DW  0x04
	.DW  _0x3+89
	.DW  _0x0*2+64

	.DW  0x05
	.DW  _0x3+93
	.DW  _0x0*2+68

	.DW  0x05
	.DW  _0x3+98
	.DW  _0x0*2+73

	.DW  0x05
	.DW  _0x3+103
	.DW  _0x0*2+78

	.DW  0x4E
	.DW  _morse_dict
	.DW  _0x4*2

	.DW  0x0C
	.DW  _0x1A
	.DW  _0x0*2+83

	.DW  0x0D
	.DW  _0x38
	.DW  _0x0*2+95

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <string.h>
;
;#define DOT_TIME_MS 400
;#define CHAR_END_TIME_MS 1000
;#define SPACE_MARK_TIME_MS 2000
;#define WORD_END_TIME_MS 2000  // 2 seconds for word end
;#define EEPROM_START_ADDR 0x00
;
;
;
;
;int i;
;
;typedef struct {
;    char *code; // pointer string array for efficiency in memory
;    char letter;
;} MorseDictionary;// type of data
;
;MorseDictionary morse_dict[] = {
;    {".-", 'A'}, {"-...", 'B'}, {"-.-.", 'C'}, {"-..", 'D'}, {".", 'E'},
;    {"..-.", 'F'}, {"--.", 'G'}, {"....", 'H'}, {"..", 'I'}, {".---", 'J'},
;    {"-.-", 'K'}, {".-..", 'L'}, {"--", 'M'}, {"-.", 'N'}, {"---", 'O'},
;    {".--.", 'P'}, {"--.-", 'Q'}, {".-.", 'R'}, {"...", 'S'}, {"-", 'T'},
;    {"..-", 'U'}, {"...-", 'V'}, {".--", 'W'}, {"-..-", 'X'}, {"-.--", 'Y'},
;    {"--..", 'Z'}
;};

	.DSEG
_0x3:
	.BYTE 0x6C
;
;int button_pressed = 0;
;int press_duration = 0;
;int idle_time = 0; //not pressed duration
;char morse_buffer[10]; //store morse code
;int morse_index = 0; //position of char in morse
;char eeprom_data[100];
;int eeprom_index = 0;
;int word_end_flag = 0;  // flag to track if word end is detected
;
;void init_interrupts(void);
;void process_morse(void);
;void decode_morse(void);
;void write_morse_to_eeprom(void);
;void read_morse_from_eeprom(void);  // Function prototype
;void reset_system(void);  // Function prototype for reset button handling
;
;void WRITER_EEPROM(unsigned char addr, unsigned char data) {
; 0000 0031 void WRITER_EEPROM(unsigned char addr, unsigned char data) {

	.CSEG
_WRITER_EEPROM:
; .FSTART _WRITER_EEPROM
; 0000 0032     while (EECR & (1 << EEWE));
	ST   -Y,R26
;	addr -> Y+1
;	data -> Y+0
_0x5:
	SBIC 0x1C,1
	RJMP _0x5
; 0000 0033     EEAR = addr;
	LDD  R30,Y+1
	LDI  R31,0
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 0034     EEDR = data;
	LD   R30,Y
	OUT  0x1D,R30
; 0000 0035     EECR |= (1 << EEMWE);
	SBI  0x1C,2
; 0000 0036     EECR |= (1 << EEWE);
	SBI  0x1C,1
; 0000 0037 }
	JMP  _0x2040002
; .FEND
;
;unsigned char READER_EEPROM(unsigned char addr) {
; 0000 0039 unsigned char READER_EEPROM(unsigned char addr) {
_READER_EEPROM:
; .FSTART _READER_EEPROM
; 0000 003A     while (EECR & (1 << EEWE));
	ST   -Y,R26
;	addr -> Y+0
_0x8:
	SBIC 0x1C,1
	RJMP _0x8
; 0000 003B     EEAR = addr;
	LD   R30,Y
	LDI  R31,0
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 003C     EECR |= (1 << EERE);
	SBI  0x1C,0
; 0000 003D     return EEDR;
	IN   R30,0x1D
	JMP  _0x2040001
; 0000 003E }
; .FEND
;
;void main(void) {
; 0000 0040 void main(void) {
_main:
; .FSTART _main
; 0000 0041     lcd_init(32);
	LDI  R26,LOW(32)
	CALL _lcd_init
; 0000 0042 
; 0000 0043     DDRD &= ~(1 << 2);   // PD2 input for Morse button
	CBI  0x11,2
; 0000 0044     PORTD |= (1 << 2);   // Enable pull-up on PD2
	SBI  0x12,2
; 0000 0045     DDRD &= ~(1 << 3);   // PD3 input for Read button
	CBI  0x11,3
; 0000 0046     PORTD |= (1 << 3);   // Enable pull-up on PD3
	SBI  0x12,3
; 0000 0047     DDRD &= ~(1 << 4);   // PD4 input for Write button
	CBI  0x11,4
; 0000 0048     PORTD |= (1 << 4);   // Enable pull-up on PD4
	SBI  0x12,4
; 0000 0049 
; 0000 004A     DDRD &= ~(1 << 5);   // PD5 input for Reset button
	CBI  0x11,5
; 0000 004B     PORTD |= (1 << 5);   // Enable pull-up on PD5
	SBI  0x12,5
; 0000 004C 
; 0000 004D     init_interrupts();
	RCALL _init_interrupts
; 0000 004E 
; 0000 004F     #asm("sei")
	sei
; 0000 0050 
; 0000 0051     while (1) {
_0xB:
; 0000 0052         if (button_pressed) {
	MOV  R0,R6
	OR   R0,R7
	BREQ _0xE
; 0000 0053             process_morse();
	RCALL _process_morse
; 0000 0054             button_pressed = 0;
	CLR  R6
	CLR  R7
; 0000 0055         }
; 0000 0056 
; 0000 0057         // check for space mark
; 0000 0058         if (idle_time >= SPACE_MARK_TIME_MS && morse_index > 0) {
_0xE:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x10
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRLT _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 0059             morse_buffer[morse_index] = '\0';
	CALL SUBOPT_0x0
; 0000 005A             eeprom_data[eeprom_index++] = ' ';
	CALL SUBOPT_0x1
; 0000 005B             morse_index = 0;
	CLR  R12
	CLR  R13
; 0000 005C             idle_time = 0;  // Store space mark
	CLR  R10
	CLR  R11
; 0000 005D         }
; 0000 005E         // check for end of character to be shown
; 0000 005F         else if (idle_time >= CHAR_END_TIME_MS && morse_index > 0) {
	RJMP _0x12
_0xF:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x14
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRLT _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 0060             morse_buffer[morse_index] = '\0';
	CALL SUBOPT_0x0
; 0000 0061             decode_morse();
	RCALL _decode_morse
; 0000 0062             morse_index = 0;
	CLR  R12
	CLR  R13
; 0000 0063             idle_time = 0;
	CALL SUBOPT_0x2
; 0000 0064             word_end_flag = 0;  // Reset word end flag after character decode
; 0000 0065         }
; 0000 0066 
; 0000 0067         // Check for end of word
; 0000 0068         if (idle_time >= WORD_END_TIME_MS && eeprom_index > 0 && !word_end_flag) {
_0x13:
_0x12:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x17
	LDS  R26,_eeprom_index
	LDS  R27,_eeprom_index+1
	CALL __CPW02
	BRGE _0x17
	LDS  R30,_word_end_flag
	LDS  R31,_word_end_flag+1
	SBIW R30,0
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 0069             eeprom_data[eeprom_index++] = ' ';  // Space between words
	CALL SUBOPT_0x1
; 0000 006A             word_end_flag = 1;  // Set flag to indicate word end added
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _word_end_flag,R30
	STS  _word_end_flag+1,R31
; 0000 006B             idle_time = 0;
	CLR  R10
	CLR  R11
; 0000 006C         }
; 0000 006D 
; 0000 006E         if (!(PIND & (1 << 4))) {
_0x16:
	SBIC 0x10,4
	RJMP _0x19
; 0000 006F             write_morse_to_eeprom();
	RCALL _write_morse_to_eeprom
; 0000 0070             lcd_clear();
	RCALL _lcd_clear
; 0000 0071             lcd_puts("Word stored");
	__POINTW2MN _0x1A,0
	CALL SUBOPT_0x3
; 0000 0072             delay_ms(1000);
; 0000 0073             lcd_clear();
; 0000 0074             idle_time = 0;
	CALL SUBOPT_0x2
; 0000 0075             word_end_flag = 0;  // Reset flag after word write
; 0000 0076         }
; 0000 0077 
; 0000 0078         if (!(PIND & (1 << 3))) {
_0x19:
	SBIC 0x10,3
	RJMP _0x1B
; 0000 0079             read_morse_from_eeprom();  // Call function to read from EEPROM
	RCALL _read_morse_from_eeprom
; 0000 007A             idle_time = 0;
	CLR  R10
	CLR  R11
; 0000 007B             while (!(PIND & (1 << 3)));  // Wait until Read button is released
_0x1C:
	SBIS 0x10,3
	RJMP _0x1C
; 0000 007C         }
; 0000 007D 
; 0000 007E         if (!(PIND & (1 << 5))) {
_0x1B:
	SBIC 0x10,5
	RJMP _0x1F
; 0000 007F             reset_system();  // Call reset function when reset button is pressed
	RCALL _reset_system
; 0000 0080             while (!(PIND & (1 << 5)));  // Wait until Reset button is released
_0x20:
	SBIS 0x10,5
	RJMP _0x20
; 0000 0081         }
; 0000 0082 
; 0000 0083         delay_ms(1);
_0x1F:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0084         idle_time++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0085     }
	RJMP _0xB
; 0000 0086 }
_0x23:
	RJMP _0x23
; .FEND

	.DSEG
_0x1A:
	.BYTE 0xC
;
;void init_interrupts(void) {
; 0000 0088 void init_interrupts(void) {

	.CSEG
_init_interrupts:
; .FSTART _init_interrupts
; 0000 0089     MCUCR |= (1 << ISC01);  // Trigger INT0 on falling edge
	IN   R30,0x35
	ORI  R30,2
	OUT  0x35,R30
; 0000 008A     GICR |= (1 << INT0);    // Enable INT0 interrupt
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 008B }
	RET
; .FEND
;
;interrupt [EXT_INT0] void ext_int0_isr(void) {
; 0000 008D interrupt [2] void ext_int0_isr(void) {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008E     if (!(PIND & (1 << 2))) {
	SBIC 0x10,2
	RJMP _0x24
; 0000 008F         while (!(PIND & (1 << 2))) {
_0x25:
	SBIC 0x10,2
	RJMP _0x27
; 0000 0090             press_duration++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0091             delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0092         }
	RJMP _0x25
_0x27:
; 0000 0093         button_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 0094     }
; 0000 0095 }
_0x24:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void process_morse(void) {
; 0000 0097 void process_morse(void) {
_process_morse:
; .FSTART _process_morse
; 0000 0098     if (press_duration > DOT_TIME_MS) {
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x28
; 0000 0099         morse_buffer[morse_index++] = '-';
	CALL SUBOPT_0x4
	LDI  R26,LOW(45)
	RJMP _0x39
; 0000 009A     } else {
_0x28:
; 0000 009B         morse_buffer[morse_index++] = '.';
	CALL SUBOPT_0x4
	LDI  R26,LOW(46)
_0x39:
	STD  Z+0,R26
; 0000 009C     }
; 0000 009D 
; 0000 009E     morse_buffer[morse_index] = '\0';
	CALL SUBOPT_0x0
; 0000 009F     lcd_clear();
	RCALL _lcd_clear
; 0000 00A0     lcd_puts(morse_buffer);
	LDI  R26,LOW(_morse_buffer)
	LDI  R27,HIGH(_morse_buffer)
	RCALL _lcd_puts
; 0000 00A1 
; 0000 00A2     press_duration = 0;
	CLR  R8
	CLR  R9
; 0000 00A3     idle_time = 0;
	CLR  R10
	CLR  R11
; 0000 00A4 }
	RET
; .FEND
;
;void decode_morse(void) {
; 0000 00A6 void decode_morse(void) {
_decode_morse:
; .FSTART _decode_morse
; 0000 00A7     // Find the corresponding letter for the morse code
; 0000 00A8 
; 0000 00A9 //sizr morse dict is count chars * 8 bytes = 26* 8
; 0000 00AA // sizeof(morse_dict[0] is 8
; 0000 00AB 
; 0000 00AC     for (i = 0; i < sizeof(morse_dict) / sizeof(morse_dict[0]); i++) {
	CLR  R4
	CLR  R5
_0x2B:
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x2C
; 0000 00AD         if (strcmp(morse_dict[i].code, morse_buffer) == 0) { //if codes are the same
	MOVW R30,R4
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	SUBI R30,LOW(-_morse_dict)
	SBCI R31,HIGH(-_morse_dict)
	MOVW R26,R30
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_morse_buffer)
	LDI  R27,HIGH(_morse_buffer)
	CALL _strcmp
	CPI  R30,0
	BRNE _0x2D
; 0000 00AE             eeprom_data[eeprom_index++] = morse_dict[i].letter;
	LDI  R26,LOW(_eeprom_index)
	LDI  R27,HIGH(_eeprom_index)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	SUBI R30,LOW(-_eeprom_data)
	SBCI R31,HIGH(-_eeprom_data)
	MOVW R22,R30
	MOVW R30,R4
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	__ADDW1MN _morse_dict,2
	LD   R30,Z
	MOVW R26,R22
	ST   X,R30
; 0000 00AF             lcd_clear();
	RCALL _lcd_clear
; 0000 00B0             lcd_puts(eeprom_data);
	LDI  R26,LOW(_eeprom_data)
	LDI  R27,HIGH(_eeprom_data)
	RCALL _lcd_puts
; 0000 00B1             break;
	RJMP _0x2C
; 0000 00B2         }
; 0000 00B3     }
_0x2D:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x2B
_0x2C:
; 0000 00B4 }
	RET
; .FEND
;
;void write_morse_to_eeprom(void) {
; 0000 00B6 void write_morse_to_eeprom(void) {
_write_morse_to_eeprom:
; .FSTART _write_morse_to_eeprom
; 0000 00B7     for (i = 0; i < eeprom_index; i++) {
	CLR  R4
	CLR  R5
_0x2F:
	LDS  R30,_eeprom_index
	LDS  R31,_eeprom_index+1
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x30
; 0000 00B8         WRITER_EEPROM(EEPROM_START_ADDR + i, eeprom_data[i]); //write data in eeprom buffer to eeprom one by one
	MOV  R30,R4
	ST   -Y,R30
	LDI  R26,LOW(_eeprom_data)
	LDI  R27,HIGH(_eeprom_data)
	ADD  R26,R4
	ADC  R27,R5
	LD   R26,X
	RCALL _WRITER_EEPROM
; 0000 00B9     }
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x2F
_0x30:
; 0000 00BA     WRITER_EEPROM(EEPROM_START_ADDR + eeprom_index, '\0'); // flag end of data
	LDS  R30,_eeprom_index
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _WRITER_EEPROM
; 0000 00BB     eeprom_index = 0; //clears buffer for new data
	LDI  R30,LOW(0)
	STS  _eeprom_index,R30
	STS  _eeprom_index+1,R30
; 0000 00BC }
	RET
; .FEND
;
;void read_morse_from_eeprom(void) {
; 0000 00BE void read_morse_from_eeprom(void) {
_read_morse_from_eeprom:
; .FSTART _read_morse_from_eeprom
; 0000 00BF     int index = 0;
; 0000 00C0     unsigned char data;
; 0000 00C1 
; 0000 00C2     lcd_clear();
	CALL __SAVELOCR4
;	index -> R16,R17
;	data -> R19
	__GETWRN 16,17,0
	RCALL _lcd_clear
; 0000 00C3     while (1) {
_0x31:
; 0000 00C4         data = READER_EEPROM(EEPROM_START_ADDR + index);
	MOV  R26,R16
	RCALL _READER_EEPROM
	MOV  R19,R30
; 0000 00C5         if (data == '\0') {
	CPI  R19,0
	BREQ _0x33
; 0000 00C6             // end of message then exit loop
; 0000 00C7             break;
; 0000 00C8         } else if (data == ' ') {
	CPI  R19,32
	BRNE _0x36
; 0000 00C9             // space between words
; 0000 00CA             lcd_putchar(' ');
	LDI  R26,LOW(32)
	RJMP _0x3A
; 0000 00CB         } else {
_0x36:
; 0000 00CC             // Display character
; 0000 00CD             lcd_putchar(data);
	MOV  R26,R19
_0x3A:
	RCALL _lcd_putchar
; 0000 00CE         }
; 0000 00CF         index++;
	__ADDWRN 16,17,1
; 0000 00D0         delay_ms(50);  // Delay for visual separation (adjust as needed)
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 00D1     }
	RJMP _0x31
_0x33:
; 0000 00D2 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;void reset_system(void) {
; 0000 00D4 void reset_system(void) {
_reset_system:
; .FSTART _reset_system
; 0000 00D5     // Perform actions to reset the system
; 0000 00D6     eeprom_index = 0;
	LDI  R30,LOW(0)
	STS  _eeprom_index,R30
	STS  _eeprom_index+1,R30
; 0000 00D7     morse_index = 0;
	CLR  R12
	CLR  R13
; 0000 00D8     word_end_flag = 0;
	STS  _word_end_flag,R30
	STS  _word_end_flag+1,R30
; 0000 00D9     lcd_clear();
	RCALL _lcd_clear
; 0000 00DA     lcd_puts("System reset");
	__POINTW2MN _0x38,0
	CALL SUBOPT_0x3
; 0000 00DB     delay_ms(1000);
; 0000 00DC     lcd_clear();
; 0000 00DD }
	RET
; .FEND

	.DSEG
_0x38:
	.BYTE 0xD
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,2
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,2
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,1
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,1
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,0
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,0
_0x200000B:
	__DELAY_USB 13
	SBI  0x15,5
	__DELAY_USB 13
	CBI  0x15,5
	__DELAY_USB 13
	RJMP _0x2040001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2040001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2040002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x5
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x5
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2040001
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,7
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,7
	RJMP _0x2040001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x14,3
	SBI  0x14,2
	SBI  0x14,1
	SBI  0x14,0
	SBI  0x14,5
	SBI  0x14,7
	SBI  0x14,6
	CBI  0x15,5
	CBI  0x15,7
	CBI  0x15,6
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2040001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND

	.DSEG
_morse_dict:
	.BYTE 0x4E
_morse_buffer:
	.BYTE 0xA
_eeprom_data:
	.BYTE 0x64
_eeprom_index:
	.BYTE 0x2
_word_end_flag:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_morse_buffer)
	LDI  R27,HIGH(_morse_buffer)
	ADD  R26,R12
	ADC  R27,R13
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_eeprom_index)
	LDI  R27,HIGH(_eeprom_index)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	SUBI R30,LOW(-_eeprom_data)
	SBCI R31,HIGH(-_eeprom_data)
	LDI  R26,LOW(32)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	CLR  R10
	CLR  R11
	LDI  R30,LOW(0)
	STS  _word_end_flag,R30
	STS  _word_end_flag+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	CALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	SBIW R30,1
	SUBI R30,LOW(-_morse_buffer)
	SBCI R31,HIGH(-_morse_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
