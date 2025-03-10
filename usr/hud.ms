// Draws the overlay showing shield/score/etc.

_lastScore = -1
_lastShield = -1

init = function
	display(2).mode = displayMode.text
	globals.text = display(2)
	text.color = "#88FFFF"
	text.clear
	display(3).mode = displayMode.pixel
	globals.gfx = display(3)
	gfx.clear color.clear
	gfx.fillRect 0, 600, 960, 40, "#00000088"
end function

update = function(forceRedraw = false)
	if score != _lastScore or forceRedraw then
		text.row = 25
		text.column = 53
		s = ("000000" + score)[-6:]
		print "SCORE: " + s + "   "
		outer._lastScore = score
	end if
	
	s = str(round(fighter.craft.shield))
	if s != _lastShield or forceRedraw then
		text.row = 25
		text.column = 1
		print "SHIELD: " + s + "   "
		_lastShield = s
	end if
end  function