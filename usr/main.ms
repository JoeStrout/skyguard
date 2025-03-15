import "importUtil"
ensureImport "mathUtil"
ensureImport "listUtil"
ensureImport "stringUtil"
ensureImport "renderer"
ensureImport "obstacles"
ensureImport "fighter"
ensureImport "shot"
ensureImport "enemy"
ensureImport "sounds"
ensureImport "vfx"
ensureImport "hud"
ensureImport "levels"
ensureImport "disp"

setup = function
	disp.init
	renderer.init
	fighter.init
	sounds.init
	vfx.init
	globals.score = 0
	hud.init
	if not (env.hasIndex("curLevel") and 0 < env.curLevel <= 3) then env.curLevel = 1
	if env.hasIndex("bgm") and env.bgm then
		outer.bgm = file.loadSound("/usr/sounds/gameMusicLoop.ogg")
		bgm.loop = true
		bgm.play
	else
		outer.bgm = null
	end if
end function

update = function(dt=0.017)
	key.clear
	yield
	obstacles.update 6
	fighter.craft.update dt
	renderer.update dt
	shot.updateAll dt
	enemy.updateAll dt
	vfx.updateAll dt
	hud.update
	levels.update dt
end function

endGame = function(message = "GAME OVER", msgColor = "#FF8888")
	env.lastScore = score
	text.row = 14; text.column = 34 - message.len/2
	text.color = msgColor
	print message
	wait
	display(0).mode = displayMode.solidColor
	fader = display(0)
	for alpha in range(0, 255, 1)
		fader.color = color.rgba(0,0,0, alpha)
		if bgm then bgm.adjust 1 - alpha/255
		yield
	end for
	key.clear
	clear
	Sound.stopAll
	reset; run "mainMenu"
end function

// Main program
setup
levels.startLevelWave env.curLevel, 1
while true
	update 0.017
	yield
end while
