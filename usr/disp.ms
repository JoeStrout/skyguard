// Manages the display layers (and provides quick access to the main sprites list).

init = function
	clear

	display(7).mode = displayMode.sprite	// background
	outer.bg = display(7)
	bg.clear
	outer.background = new Sprite
	background.scale = 2
	background.x = 480
	background.y = 320
	bg.sprites.insert 0, background

	display(6).mode = displayMode.sprite	// main Z-sorted sprite layer
	outer.spr = display(6)
	spr.clear
	outer.sprites = spr.sprites
	
	display(5).mode = displayMode.sprite	// fighter/foreground sprites
	outer.fg = display(5)
	fg.clear
	
	display(4).mode = displayMode.pixel		// pixel graphics layer
	globals.gfx = display(4)
	gfx.clear color.clear
	
	display(3).mode = displayMode.text
	globals.text = display(3)
	text.clear
	text.color = "#88FFFF"
	
	display(2).mode = displayMode.off
	display(1).mode = displayMode.off
	display(0).mode = displayMode.off
end function

if locals == globals then init
