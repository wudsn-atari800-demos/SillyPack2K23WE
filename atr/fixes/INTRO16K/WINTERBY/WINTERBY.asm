
	icl "..\..\asm\Fixes.asm"
	
	opt h+
	m_force_coldstart

	opt h-
	ins "WINTERBY-Original.xex"
	
	opt h+
	org $5000
	m_fade_screen_out
