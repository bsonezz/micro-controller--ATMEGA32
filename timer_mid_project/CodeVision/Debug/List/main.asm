
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
	.DEF _minutes=R4
	.DEF _minutes_msb=R5
	.DEF _seconds=R6
	.DEF _seconds_msb=R7
	.DEF _counting_active=R8
	.DEF _counting_active_msb=R9
	.DEF _paused=R10
	.DEF _paused_msb=R11
	.DEF _input_stage=R12
	.DEF _input_stage_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
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
	.DB  0x0,0x0

_0x3:
	.DB  0xFF,0xFF
_0x4:
	.DB  0x41,0x22,0x14,0x8,0x14,0x22,0x41
_0x5:
	.DB  0xC0,0xFF,0xF9,0xFF,0xA4,0xFF,0xB0,0xFF
	.DB  0x99,0xFF,0x92,0xFF,0x82,0xFF,0xF8,0xFF
	.DB  0x80,0xFF,0x90,0xFF
_0x6:
	.DB  0xFE,0xFD,0xFB,0xF7
_0x7:
	.DB  0x1
_0x8:
	.DB  0x37,0x38,0x39,0x2F,0x34,0x35,0x36,0x2A
	.DB  0x31,0x32,0x33,0x2D,0x43,0x30,0x3D,0x2B

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _pos
	.DW  _0x3*2

	.DW  0x07
	.DW  _led_pattern
	.DW  _0x4*2

	.DW  0x14
	.DW  _seg
	.DW  _0x5*2

	.DW  0x04
	.DW  _ref
	.DW  _0x6*2

	.DW  0x01
	.DW  _segref
	.DW  _0x7*2

	.DW  0x10
	.DW  _keys
	.DW  _0x8*2

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
;#define F_CPU 8000000UL
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
;#include <delay.h>
;
;int minutes = 0;
;int seconds = 0;
;int counting_active = 0;
;int paused = 0;
;int input_stage = 0;
;int digit_count = 0;
;int pos = -1;

	.DSEG
;int show_time = 0;
;int display_index = 0;
;
;unsigned char led_pattern[7] = {
;    0b01000001, 0b00100010, 0b00010100, 0b00001000,
;    0b00010100, 0b00100010, 0b01000001
;};
;
;int seg[] = {~0x3F, ~0x06, ~0x5B, ~0x4F, ~0x66, ~0x6D, ~0x7D, ~0x07, ~0x7F, ~0x6F};
;
;char ref[] = {0xFE, 0xFD, 0xFB, 0xF7};
;int i = 0, segref = 0x01;
;
;char keys[] = { '7', '8', '9', '/',
;                '4', '5', '6', '*',
;                '1', '2', '3', '-',
;                'C', '0', '=', '+'};
;
;void display_value(int min, int sec, int show_sec);
;void buzzer_and_led_pattern(void);
;void handle_keypad_input(void);
;void short_buzzer_beep(void);
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
; 0000 0023 interrupt [8] void timer1_compa_isr(void) {

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	RCALL SUBOPT_0x0
; 0000 0024     if (counting_active && !paused) {
	MOV  R0,R8
	OR   R0,R9
	BREQ _0xA
	MOV  R0,R10
	OR   R0,R11
	BREQ _0xB
_0xA:
	RJMP _0x9
_0xB:
; 0000 0025         if (seconds == 0) {
	MOV  R0,R6
	OR   R0,R7
	BRNE _0xC
; 0000 0026             if (minutes > 0) {
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRGE _0xD
; 0000 0027                 minutes--;
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
; 0000 0028                 seconds = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	MOVW R6,R30
; 0000 0029             } else {
	RJMP _0xE
_0xD:
; 0000 002A                 counting_active = 0;
	CLR  R8
	CLR  R9
; 0000 002B                 buzzer_and_led_pattern();
	RCALL _buzzer_and_led_pattern
; 0000 002C             }
_0xE:
; 0000 002D         } else {
	RJMP _0xF
_0xC:
; 0000 002E             seconds--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 002F         }
_0xF:
; 0000 0030     }
; 0000 0031 }
_0x9:
	RJMP _0x64
; .FEND
;
;interrupt [TIM0_COMP] void timer0_comp_isr(void) {
; 0000 0033 interrupt [11] void timer0_comp_isr(void) {
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
	RCALL SUBOPT_0x0
; 0000 0034     display_value(minutes, seconds, counting_active || paused || show_time);
	RCALL SUBOPT_0x1
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x10
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x10
	LDS  R30,_show_time
	LDS  R31,_show_time+1
	SBIW R30,0
	BRNE _0x10
	LDI  R30,0
	RJMP _0x11
_0x10:
	LDI  R30,1
_0x11:
	LDI  R31,0
	MOVW R26,R30
	RCALL _display_value
; 0000 0035     segref <<= 1;
	LDS  R30,_segref
	LDS  R31,_segref+1
	LSL  R30
	ROL  R31
	STS  _segref,R30
	STS  _segref+1,R31
; 0000 0036     i++;
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL SUBOPT_0x2
; 0000 0037     if (i == 4) {
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,4
	BRNE _0x12
; 0000 0038         i = 0;
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
; 0000 0039         segref = 0x01;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _segref,R30
	STS  _segref+1,R31
; 0000 003A     }
; 0000 003B }
_0x12:
_0x64:
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
;void display_value(int min, int sec, int show_sec) {
; 0000 003D void display_value(int min, int sec, int show_sec) {
_display_value:
; .FSTART _display_value
; 0000 003E     int min_tens = min / 10;
; 0000 003F     int min_units = min % 10;
; 0000 0040     int sec_tens = (show_sec) ? (sec / 10) : 0;
; 0000 0041     int sec_units = (show_sec) ? (sec % 10) : 0;
; 0000 0042 
; 0000 0043     // Ensure all segments are turned off before updating
; 0000 0044     PORTC = 0xFF;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	CALL __SAVELOCR6
;	min -> Y+12
;	sec -> Y+10
;	show_sec -> Y+8
;	min_tens -> R16,R17
;	min_units -> R18,R19
;	sec_tens -> R20,R21
;	sec_units -> Y+6
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x3
	MOVW R16,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R18,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x13
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x3
	RJMP _0x14
_0x13:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x14:
	MOVW R20,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x16
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RJMP _0x17
_0x16:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x17:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0045     PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0046 
; 0000 0047     switch (display_index % 4) {
	LDS  R26,_display_index
	LDS  R27,_display_index+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
; 0000 0048         case 0:
	SBIW R30,0
	BRNE _0x1C
; 0000 0049             PORTC = seg[min_tens];
	MOVW R30,R16
	RJMP _0x60
; 0000 004A             PORTD = (1 << display_index); // Active high for the selected digit
; 0000 004B             break;
; 0000 004C         case 1:
_0x1C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1D
; 0000 004D             PORTC = seg[min_units];
	MOVW R30,R18
	RJMP _0x60
; 0000 004E             PORTD = (1 << display_index); // Active high for the selected digit
; 0000 004F             break;
; 0000 0050         case 2:
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1E
; 0000 0051             PORTC = seg[sec_tens];
	MOVW R30,R20
	RJMP _0x60
; 0000 0052             PORTD = (1 << display_index); // Active high for the selected digit
; 0000 0053             break;
; 0000 0054         case 3:
_0x1E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1B
; 0000 0055             PORTC = seg[sec_units];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
_0x60:
	LDI  R26,LOW(_seg)
	LDI  R27,HIGH(_seg)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x15,R30
; 0000 0056             PORTD = (1 << display_index); // Active high for the selected digit
	LDS  R30,_display_index
	LDI  R26,LOW(1)
	CALL __LSLB12
	OUT  0x12,R30
; 0000 0057             break;
; 0000 0058     }
_0x1B:
; 0000 0059 
; 0000 005A     display_index = (display_index + 1) % 4;
	LDS  R30,_display_index
	LDS  R31,_display_index+1
	ADIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	STS  _display_index,R30
	STS  _display_index+1,R31
; 0000 005B }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; .FEND
;
;void buzzer_and_led_pattern(void) {
; 0000 005D void buzzer_and_led_pattern(void) {
_buzzer_and_led_pattern:
; .FSTART _buzzer_and_led_pattern
; 0000 005E     int k, j;
; 0000 005F     for (k = 0; k < 1; k++) {
	CALL __SAVELOCR4
;	k -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x21:
	__CPWRN 16,17,1
	BRGE _0x22
; 0000 0060         PORTB |= (1 << PORTB7);
	SBI  0x18,7
; 0000 0061         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 0062         PORTB &= ~(1 << PORTB7);
	CBI  0x18,7
; 0000 0063         for (j = 0; j < 7; j++) {
	__GETWRN 18,19,0
_0x24:
	__CPWRN 18,19,7
	BRGE _0x25
; 0000 0064             PORTB = (PORTB & ~(0x7F)) | led_pattern[j]; // clears the lower 7
	IN   R30,0x18
	ANDI R30,LOW(0x80)
	MOV  R0,R30
	LDI  R26,LOW(_led_pattern)
	LDI  R27,HIGH(_led_pattern)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	OR   R30,R0
	OUT  0x18,R30
; 0000 0065             delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0066         }
	__ADDWRN 18,19,1
	RJMP _0x24
_0x25:
; 0000 0067     }
	__ADDWRN 16,17,1
	RJMP _0x21
_0x22:
; 0000 0068 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;void handle_keypad_input(void) {
; 0000 006A void handle_keypad_input(void) {
_handle_keypad_input:
; .FSTART _handle_keypad_input
; 0000 006B     char key = 0; // pressed key
; 0000 006C     int row, col = -1; // no key initialized
; 0000 006D 
; 0000 006E     for (row = 0; row < 4; row++) {
	CALL __SAVELOCR6
;	key -> R17
;	row -> R18,R19
;	col -> R20,R21
	LDI  R17,0
	__GETWRN 20,21,-1
	__GETWRN 18,19,0
_0x27:
	__CPWRN 18,19,4
	BRGE _0x28
; 0000 006F         PORTA = ref[row]; // scan keypad
	LDI  R26,LOW(_ref)
	LDI  R27,HIGH(_ref)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	OUT  0x1B,R30
; 0000 0070         delay_us(50);
	__DELAY_USB 133
; 0000 0071 
; 0000 0072         // column detection
; 0000 0073         if (!(PINA & (1 << PINA4))) { col = 0; break; }
	SBIC 0x19,4
	RJMP _0x29
	__GETWRN 20,21,0
	RJMP _0x28
; 0000 0074         if (!(PINA & (1 << PINA5))) { col = 1; break; }
_0x29:
	SBIC 0x19,5
	RJMP _0x2A
	__GETWRN 20,21,1
	RJMP _0x28
; 0000 0075         if (!(PINA & (1 << PINA6))) { col = 2; break; }
_0x2A:
	SBIC 0x19,6
	RJMP _0x2B
	__GETWRN 20,21,2
	RJMP _0x28
; 0000 0076         if (!(PINA & (1 << PINA7))) { col = 3; break; }
_0x2B:
	SBIC 0x19,7
	RJMP _0x2C
	__GETWRN 20,21,3
	RJMP _0x28
; 0000 0077     }
_0x2C:
	__ADDWRN 18,19,1
	RJMP _0x27
_0x28:
; 0000 0078 
; 0000 0079     if (col != -1) {
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R20
	CPC  R31,R21
	BRNE PC+2
	RJMP _0x2D
; 0000 007A         pos = row * 4 + col;
	MOVW R30,R18
	CALL __LSLW2
	ADD  R30,R20
	ADC  R31,R21
	STS  _pos,R30
	STS  _pos+1,R31
; 0000 007B         key = keys[pos];
	SUBI R30,LOW(-_keys)
	SBCI R31,HIGH(-_keys)
	LD   R17,Z
; 0000 007C 
; 0000 007D         short_buzzer_beep();
	RCALL _short_buzzer_beep
; 0000 007E 
; 0000 007F         if (key >= '0' && key <= '9') {
	CPI  R17,48
	BRLO _0x2F
	CPI  R17,58
	BRLO _0x30
_0x2F:
	RJMP _0x2E
_0x30:
; 0000 0080             // input_stage 0 is minute
; 0000 0081             // input stage 1 seconds
; 0000 0082             if (input_stage == 0) {
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x31
; 0000 0083                 if (digit_count == 0) {
	LDS  R30,_digit_count
	LDS  R31,_digit_count+1
	SBIW R30,0
	BRNE _0x32
; 0000 0084                     minutes = (key - '0');
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	MOVW R4,R30
; 0000 0085                     digit_count++;
	LDI  R26,LOW(_digit_count)
	LDI  R27,HIGH(_digit_count)
	RCALL SUBOPT_0x2
; 0000 0086                 } else if (digit_count == 1) {
	RJMP _0x33
_0x32:
	LDS  R26,_digit_count
	LDS  R27,_digit_count+1
	SBIW R26,1
	BRNE _0x34
; 0000 0087                     minutes = minutes * 10 + (key - '0');
	MOVW R30,R4
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	ADD  R30,R26
	ADC  R31,R27
	MOVW R4,R30
; 0000 0088                     if (minutes >= 60) minutes = 59; // if overflow range set to 59
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x35
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	MOVW R4,R30
; 0000 0089                     input_stage = 1;
_0x35:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 008A                     digit_count = 0;
	LDI  R30,LOW(0)
	STS  _digit_count,R30
	STS  _digit_count+1,R30
; 0000 008B                 }
; 0000 008C             } else {
_0x34:
_0x33:
	RJMP _0x36
_0x31:
; 0000 008D                 if (digit_count == 0) {
	LDS  R30,_digit_count
	LDS  R31,_digit_count+1
	SBIW R30,0
	BRNE _0x37
; 0000 008E                     seconds = (key - '0') * 10;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	RJMP _0x61
; 0000 008F                     digit_count++;
; 0000 0090                 } else if (digit_count == 1) {
_0x37:
	RCALL SUBOPT_0x4
	SBIW R26,1
	BRNE _0x39
; 0000 0091                     seconds += (key - '0');
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	__ADDWRR 6,7,30,31
; 0000 0092                     if (seconds >= 60) seconds = 59;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x3A
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
_0x61:
	MOVW R6,R30
; 0000 0093                     digit_count++;
_0x3A:
	LDI  R26,LOW(_digit_count)
	LDI  R27,HIGH(_digit_count)
	RCALL SUBOPT_0x2
; 0000 0094                 }
; 0000 0095             }
_0x39:
_0x36:
; 0000 0096             display_value(minutes, seconds, 1);
	RJMP _0x62
; 0000 0097             show_time = 0;
; 0000 0098         } else if (key == 'C') {
_0x2E:
	CPI  R17,67
	BRNE _0x3C
; 0000 0099             if (show_time) {
	LDS  R30,_show_time
	LDS  R31,_show_time+1
	SBIW R30,0
	BREQ _0x3D
; 0000 009A                 counting_active = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 009B                 show_time = 0;
	RCALL SUBOPT_0x5
; 0000 009C             }
; 0000 009D         } else if (key == '/') {
_0x3D:
	RJMP _0x3E
_0x3C:
	CPI  R17,47
	BRNE _0x3F
; 0000 009E             if (counting_active) {
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x40
; 0000 009F                 paused = !paused;
	MOVW R30,R10
	CALL __LNEGW1
	MOV  R10,R30
	CLR  R11
; 0000 00A0             }
; 0000 00A1         } else if (key == '=') {
_0x40:
	RJMP _0x41
_0x3F:
	CPI  R17,61
	BRNE _0x42
; 0000 00A2             if (!counting_active && (minutes > 0 || seconds > 0)) {
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x44
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRLT _0x45
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRGE _0x44
_0x45:
	RJMP _0x47
_0x44:
	RJMP _0x43
_0x47:
; 0000 00A3                 show_time = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _show_time,R30
	STS  _show_time+1,R31
; 0000 00A4                 display_value(minutes, seconds, 1);
	RCALL SUBOPT_0x1
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _display_value
; 0000 00A5             }
; 0000 00A6         } else if (key == '*') {
_0x43:
	RJMP _0x48
_0x42:
	CPI  R17,42
	BRNE _0x49
; 0000 00A7             minutes = 0;
	CLR  R4
	CLR  R5
; 0000 00A8             seconds = 0;
	CLR  R6
	CLR  R7
; 0000 00A9             input_stage = 0;
	CLR  R12
	CLR  R13
; 0000 00AA             digit_count = 0;
	LDI  R30,LOW(0)
	STS  _digit_count,R30
	STS  _digit_count+1,R30
; 0000 00AB             counting_active = 0;
	CLR  R8
	CLR  R9
; 0000 00AC             paused = 0;
	CLR  R10
	CLR  R11
; 0000 00AD             show_time = 0;
	RCALL SUBOPT_0x5
; 0000 00AE             display_value(minutes, seconds, 0);
	RCALL SUBOPT_0x1
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _display_value
; 0000 00AF         } else if (key == '-') {
	RJMP _0x4A
_0x49:
	CPI  R17,45
	BRNE _0x4B
; 0000 00B0             if (input_stage == 1 && digit_count > 0) {
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x4D
	RCALL SUBOPT_0x4
	CALL __CPW02
	BRLT _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 00B1                 seconds = seconds / 10;
	MOVW R26,R6
	RCALL SUBOPT_0x3
	MOVW R6,R30
; 0000 00B2                 digit_count--;
	RJMP _0x63
; 0000 00B3             } else if (input_stage == 1 && digit_count == 0) {
_0x4C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x51
	RCALL SUBOPT_0x4
	SBIW R26,0
	BREQ _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 00B4                 input_stage = 0;
	CLR  R12
	CLR  R13
; 0000 00B5                 digit_count = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _digit_count,R30
	STS  _digit_count+1,R31
; 0000 00B6             } else if (input_stage == 0 && digit_count > 0) {
	RJMP _0x53
_0x50:
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRNE _0x55
	RCALL SUBOPT_0x4
	CALL __CPW02
	BRLT _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 00B7                 minutes = minutes / 10;
	MOVW R26,R4
	RCALL SUBOPT_0x3
	MOVW R4,R30
; 0000 00B8                 digit_count--;
_0x63:
	LDI  R26,LOW(_digit_count)
	LDI  R27,HIGH(_digit_count)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00B9             }
; 0000 00BA             display_value(minutes, seconds, 1);
_0x54:
_0x53:
_0x62:
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R6
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _display_value
; 0000 00BB             show_time = 0;
	RCALL SUBOPT_0x5
; 0000 00BC         }
; 0000 00BD 
; 0000 00BE         while (!(PINA & (1 << PINA4)) || !(PINA & (1 << PINA5)) || !(PINA & (1 << PINA6)) || !(PINA & (1 << PINA7))) {
_0x4B:
_0x4A:
_0x48:
_0x41:
_0x3E:
_0x57:
	SBIS 0x19,4
	RJMP _0x5A
	SBIS 0x19,5
	RJMP _0x5A
	SBIS 0x19,6
	RJMP _0x5A
	SBIC 0x19,7
	RJMP _0x59
_0x5A:
; 0000 00BF             delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 00C0         }
	RJMP _0x57
_0x59:
; 0000 00C1     }
; 0000 00C2 }
_0x2D:
	CALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;void short_buzzer_beep(void) {
; 0000 00C4 void short_buzzer_beep(void) {
_short_buzzer_beep:
; .FSTART _short_buzzer_beep
; 0000 00C5     PORTB |= (1 << PORTB7);
	SBI  0x18,7
; 0000 00C6     delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 00C7     PORTB &= ~(1 << PORTB7);
	CBI  0x18,7
; 0000 00C8 }
	RET
; .FEND
;
;void main(void) {
; 0000 00CA void main(void) {
_main:
; .FSTART _main
; 0000 00CB     DDRC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00CC     PORTC = 0xFF;
	OUT  0x15,R30
; 0000 00CD     DDRD = 0xFF;
	OUT  0x11,R30
; 0000 00CE     PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00CF     DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00D0     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00D1     DDRA = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 00D2     PORTA = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 00D3 
; 0000 00D4     TCCR1B |= (1 << WGM12) | (1 << CS12) | (1 << CS10);
	IN   R30,0x2E
	ORI  R30,LOW(0xD)
	OUT  0x2E,R30
; 0000 00D5     OCR1A = 2928;  // 1 second delay, Timer1, 1024 prescaler
	LDI  R30,LOW(2928)
	LDI  R31,HIGH(2928)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00D6     TIMSK |= (1 << OCIE1A);
	IN   R30,0x39
	ORI  R30,0x10
	OUT  0x39,R30
; 0000 00D7 
; 0000 00D8     TCCR0 |= (1 << WGM01) | (1 << CS01) | (1 << CS00);
	IN   R30,0x33
	ORI  R30,LOW(0xB)
	OUT  0x33,R30
; 0000 00D9     OCR0 =  2928;
	LDI  R30,LOW(112)
	OUT  0x3C,R30
; 0000 00DA     //0x4D;  // 10 ms delay, Timer0, 64 prescaler
; 0000 00DB     TIMSK |= (1 << OCIE0);
	IN   R30,0x39
	ORI  R30,2
	OUT  0x39,R30
; 0000 00DC 
; 0000 00DD 
; 0000 00DE 
; 0000 00DF 
; 0000 00E0     #asm("sei");
	sei
; 0000 00E1 
; 0000 00E2     while (1) {
_0x5C:
; 0000 00E3         handle_keypad_input();
	RCALL _handle_keypad_input
; 0000 00E4     }
	RJMP _0x5C
; 0000 00E5 }
_0x5F:
	RJMP _0x5F
; .FEND

	.DSEG
_digit_count:
	.BYTE 0x2
_pos:
	.BYTE 0x2
_show_time:
	.BYTE 0x2
_display_index:
	.BYTE 0x2
_led_pattern:
	.BYTE 0x7
_seg:
	.BYTE 0x14
_ref:
	.BYTE 0x4
_i:
	.BYTE 0x2
_segref:
	.BYTE 0x2
_keys:
	.BYTE 0x10

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R26,_digit_count
	LDS  R27,_digit_count+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _show_time,R30
	STS  _show_time+1,R30
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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LNEGW1:
	OR   R30,R31
	LDI  R30,1
	BREQ __LNEGW1F
	LDI  R30,0
__LNEGW1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
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
