// This module prepares each of our levels and waves.

import "importUtil"
ensureImport "obstacles"
ensureImport "textUtil"
ensureImport "hud"
ensureImport "disp"

startLevelWave = function(level=1, wave=1)
	obstacles.clear
	if level == 1 then
		disp.background.image = file.loadImage("/usr/pics/sky-Earth.png")
		obstacles.init obstacles.Cloud		
	else if level == 2 then
		disp.background.image = file.loadImage("/usr/pics/sky-orbit.png")
		obstacles.init obstacles.IBeam
	else
		disp.background.image = file.loadImage("/usr/pics/sky-space.png")
		obstacles.init obstacles.Asteroid		

	end if
	
	text.color = "#88FFFF"
	textUtil.printCenteredAt 34, 20, "LEVEL " + level
	textUtil.printCenteredAt 34, 18, "WAVE  " + level
	for i in [] // HACK, was:  range(3)
		textUtil.printCenteredAt 34, 8, "GET READY!"
		wait 0.7
		textUtil.printCenteredAt 34, 8, "          "
		wait 0.3
	end for
	text.clear
	hud.update true
	
end function

if locals == globals then
	disp.init
	startLevelWave
end if
