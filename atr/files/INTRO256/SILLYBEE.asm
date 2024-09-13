; "Bees", Atari XL/XE Intro 256B
;
; code by SuN / NG
; idea by tr1x / Agenda
; requirements: original Atari XL/XE 64KB PAL
; version: 1.0
; release date: 2023-07-07

;scradr	equ $00

fntadr	equ $0c00

rtclok	equ $0012
chbas	equ $02f4
colpf0	equ $d016
colpf1	equ $d017
colpf2	equ $d018
colpf3	equ $d019
colpf4	equ $D01A
colbak	equ $D01A

COLOR0   = $02c4
COLOR1   = $02c5
COLOR2   = $02c6
COLOR3   = $02c7
COLOR4   = $02c8

PCOLR0   = $02c0
PCOLR1   = $02c1
PCOLR2   = $02c2
PCOLR3   = $02c3

consol	equ $d01f
random	equ $d20a
wsync	equ $d40a
vcount	equ $d40b
osgraph	equ $ef9c
VVBLKD  equ $0224
XITVBV  equ $e462

SPLAYER0 equ $D008 ; size player0
GPLAYER0 equ $D00D ; rejestr grafiki gracza 0    
PPLAYER0 equ $D000 ; pozycja gracza 0
CPLAYER0 equ $D012 ; kolor gracza 0

; POKEY write locations
AUDF1    = $d200
AUDC1    = $d201
AUDF2    = $d202
AUDC2    = $d203
AUDF3    = $d204
AUDC3    = $d205
AUDF4    = $d206
AUDC4    = $d207
AUDCTL   = $d208
STIMER   = $d209
SKREST   = $d20a
POTGO    = $d20b
SEROUT   = $d20d
IRQEN    = $d20e
SKCTL    = $d20f

vol1 = $80
vol2 = $81
	org $0082

start	lda #$0c
	jsr osgraph

	sta rtclok+2
	stx chbas			; X=$0c after "jsr osgraph"

;colors
    lda #$ee
    sta color0
    sta pcolr0
    sta pcolr1

    lda #$3a
    sta color2
    
    ldy #$ff
draw	equ *
    lda random
    and #$f
    cmp #5; a-3
    bmi scradr
    lda #0
scradr equ *
    sta $bba0,y
    sta $bba0+$ff,y
    sta $bba0+($ff*2),y
    sta $bba0+($ff*3),y
	dey
	bne draw

; freq
    sty audf2
;vol2 $80 = 0
;    sty vol2
    lda #$4
    sta audf1
    sta vol1
    
    iny
    sty GPLAYER0;
    sty GPLAYER0+1;

; put hive
    ldy #5
;    sty vol1
    sty $bba0+(40*22)+37; srodek
    iny
    sty $bba0+(40*22)+38; srodek
    iny
    sty $bba0+(40*23)+37; srodek
    iny
    sty $bba0+(40*23)+38; srodek

; show bees    
loop1
    sty pplayer0;
    sty pplayer0+1;

    lda vcount
minpoz equ *+1
    cmp #16
    bmi exit
maxpoz equ *+1
    cmp #110
    bpl exit
    
    lda random
and_bees equ *+1
    and #127
adc_bees equ *+1
    adc #56
    sta pplayer0;
    eor #$ff
    sta pplayer0+1;
exit
    sta wsync
	jmp loop1

; VBLANK interrupt routine
vbrout	
; bzyk
;       znieksz     volume
;    lda #%00100000 + %00000011
    lda vol1
    tax
    eor #%01000000
    sta audc1
    
    lda vol2
    tay
    eor #%01000000
    sta audc2

    lda rtclok+2
	bne skipa
; dodaj, odejmij?    
    inx
    txa
    and #$f
    sta vol1

    iny
    tya
    and #$f
    sta vol2
    
    lda and_bees
    eor random
    sta and_bees    
    
;    inc minpoz
;    dec maxpoz
    
skipa
	jmp xitvbv

    org vvblkd
	.word .adr(vbrout)

    org $0c00;+8
plants
;    .BYTE 136,34,136,34,136,34,136,34 ;green
    .BYTE 136,0,128,34,0,2,136,0; green 2
;    .BYTE 136,0,34,0,136,0,34,0; green 3
    .BYTE 0,17,63,29,12,40,10,8 ;flowers
    .BYTE 0,4,55,21,55,8,32,8
    .BYTE 0,8,29,38,8,32,8,2
    .BYTE 128,32,34,10,8,8,8,32


    .BYTE 3,15,61,213,85,85,170,85			;ul
    .BYTE 192,240,124,87,85,85,170,85
    .BYTE 85,85,170,85,85,85,240,240
    .BYTE 85,85,170,85,1,85,15,15
; 7*8 = 56 bytes

    run start