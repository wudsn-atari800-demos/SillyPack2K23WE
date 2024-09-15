;
;	>>> SillyPack Noter by JAC! <<<
;

	.macro m_text
	.byte $0d,$0a,$0a,$0d
	ins "..\..\..\..\atr\files\GAME\ZDENDADD.txt"
	.endm

	icl "..\..\asm\Noter.asm"
