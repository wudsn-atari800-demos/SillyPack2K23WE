;
;	>>> SillyMenu by JAC! <<<
;
;	@com.wudsn.ide.lng.mainsourcefile=..\asm\SillyMenu.asm
;
;	Lengths specifies the number of line with same color.
;	Length 0 terminates the sequence.
;	Chromas specified the PAL color values with luma zero.

;              LO, LO, XL, PO, GT, GF, 25, 16, DE, G2, GA, WI, TI.
lengths	.byte  15, 10 , 10, 11, 10, 12,  9,  7, 13, 11, 10, 16, 11,0
chromas	.byte $30,$10,$e0,$d0,$b0,$90,$70,$50,$40,$20,$f0,$c0,$00,$00
;chroma .byte $30,$10,$e0,$d0,$b0,$90,$70,$50,$40,$20,$f0,$c0,$a0,$00

