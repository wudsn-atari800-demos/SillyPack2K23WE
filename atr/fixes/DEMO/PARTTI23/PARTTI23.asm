	
	.echo "Fixed: SillyPack compatible version"


	opt h-
	ins "PARTTI23-Original.xex"
	
	opt h+
	org $1f80

	.proc fix
	lda #0
	tax
loop	sta $0700,x
	inx
	bne loop
	inc loop+2
	ldy loop+2
	cpy #$20
	bcc loop
	
loop2	sta $80,x
	inx
	bpl loop2
	
	mva #1 580
	jmp $20ef
	.endp
	
	run fix