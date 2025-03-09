
flightHorz = function
	return key.axis("Horizontal")
end function

flightVert = function
	return key.axis("Vertical")
end function

fireButtons = ["space", "left shift", "right shift",
  "joystick button 0", "joystick button 1"]
fire = function
	for btn in fireButtons
		if key.pressed(btn) then return true
	end for
	return false
end function
