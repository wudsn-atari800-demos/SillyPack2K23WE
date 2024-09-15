
	icl "..\..\asm\Fixes.asm"
	
llo	= $400
lhi	= $410

	.macro m_load_screen filename
?length = .filesize ':filename'
	opt h-

        .print ':filename has ',?length, ' bytes'
	ins ':filename',+2,?length-6-2
	.word $2e2,$2e3
	ins ':filename',-2
	.endm

	.macro m_load_screen_and_wait filename
	m_load_screen ":filename"

	opt h+
	ini loader.wait_key
	.endm
	
	.macro m_load_song filename
?length = .filesize ':filename'
	opt h-

        .print ':filename has ',?length, ' bytes'
	ins ':filename',+0,?length-6
	.word loader.runadr,loader.runadr+1
	ins ':filename',-2

	opt h+
	ini loader.load_block
	.endm


	m_enable_basic

	opt h+
	org $1f80

	.proc loader

	.proc wait_key
	mva #$ff 764
wait	ldx vcount
	stx colbk
	cmp 764
	beq wait
	mva color4 colbk
	rts
	.endp

	.proc load_block
	jsr call_runadr

index	ldx #0
	mva $cd llo,x
	mva $ce lhi,x
	inc index+1
	rts
	

	.proc call_runadr
	jmp (runadr)
	.endp
	.endp

runadr	.word $ffff

	.proc screen_off
	mva #$00 sdmctl
	lda rtclok+2
wait	cmp rtclok+2
	beq wait
	rts
	.endp

	.proc start_main
	mva #$22 sdmctl
	jmp main
	.endp

	.endp


	m_load_screen_and_wait "ATR\01.OBX"
	m_load_screen_and_wait "ATR\02.OBX"
	m_load_screen_and_wait "ATR\03.OBX"
	m_load_screen_and_wait "ATR\04.OBX"
	ini loader.screen_off
	m_load_screen "ATR\05.OBX"

	m_load_song "ATR\COSMICHO.DAT"
	m_load_song "ATR\DARKLIGH.DAT"
	m_load_song "ATR\EVE.DAT"
	m_load_song "ATR\EVEREDUX.DAT"
	m_load_song "ATR\JOURNEY.DAT"
	m_load_song "ATR\MADASHEL.DAT"
	m_load_song "ATR\SUPER70S.DAT"
	m_load_song "ATR\TRICEROP.DAT"


	opt h+
	org $2000
	m_load_high $fa "ATR\TRITONE.OBX" 

;	opt h-
;	ins "ATR\TRITONE.OBX",+2

	opt h+
	run loader.start_main

