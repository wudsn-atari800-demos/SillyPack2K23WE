
	org $1f80
	
	.echo "Fixed: SillyPack compatible version"
	
	.proc clear
	lda #0
	tax
loop	sta $2000,x
	inx
	bne loop
	inc loop+2
	bpl loop
	
loop2	sta $80,x
	inx
	bpl loop2
	rts
	.endp
	
	ini clear

	opt h-
	ins "RETURNBS-Original.xex"
