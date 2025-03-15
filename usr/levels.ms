// This module prepares each of our levels and waves.

import "importUtil"
ensureImport "obstacles"
ensureImport "textUtil"
ensureImport "hud"
ensureImport "disp"

enemyTypes = []
enemyDTs = []
curWave = 0
nextWaveTime = 0

startLevelWave = function(level=1, wave=1)
	obstacles.clear
	env.curLevel = level
	outer.curWave = wave
	if level == 1 then
		disp.background.image = file.loadImage("/usr/pics/sky-Earth.png")
		obstacles.init obstacles.Cloud
		outer.enemyTypes = [
			[1,1,1,1,1,1,1,1,1,2],
			[1,1,1,1,1,1,1,2,1,2],
			[1,1,1,1,1,1,2,1,2,2] ][wave-1]		
		outer.enemyDTs = [3 + 2*(wave==1), 2, 2, 2, 5, 1, 1, 1, 0.5, 0.5]
	else if level == 2 then
		disp.background.image = file.loadImage("/usr/pics/sky-orbit.png")
		obstacles.init obstacles.IBeam
		outer.enemyTypes = [
			[2,1,2,2,1,2,2,2,2,3],
			[2,2,1,2,2,2,2,3,2,3],
			[2,2,2,2,2,2,3,2,3,3] ][wave-1]	
		outer.enemyDTs = [3, 2, 2, 2, 5, 1, 1, 1, 0.5, 0.5]
	else
		disp.background.image = file.loadImage("/usr/pics/sky-space.png")
		obstacles.init obstacles.Asteroid		
		outer.enemyTypes = [
			[3,2,3,3,3,3,1,3,3,4],
			[3,3,2,3,1,3,3,4,3,4],
			[3,1,3,2,3,3,4,3,4,4] ][wave-1]	
		outer.enemyDTs = [3, 2, 2, 2, 5, 1, 1, 1, 0.5, 0.5]
	end if
	
	//outer.enemyTypes = enemyTypes[:1] // HACK!!!
	
	if enemyDTs.len != enemyTypes.len then
		outer.enemyDTs += [1] * enemyTypes.len
		outer.enemyDTs = outer.enemyDTs[:enemyTypes.len]
	end if
	
	waitAndBumpShield = function
		if fighter.craft.shield < 100 then
			fighter.craft.shield += 3
			if fighter.craft.shield > 100 then fighter.craft.shield = 100
			hud.update
		end if
		wait 0.1
	end function
	
	text.color = "#FF6666"
	textUtil.printCenteredAt 34, 20, "LEVEL " + level
	textUtil.printCenteredAt 34, 18, "WAVE  " + wave
	for i in range(3)
		textUtil.printCenteredAt 34, 8, "GET READY!"
		for j in range(6); waitAndBumpShield; end for
		textUtil.printCenteredAt 34, 8, "          "
		for j in range(2); waitAndBumpShield; end for
	end for
	text.clear
	fighter.craft.shield = 100
	hud.update true	
end function

update = function(dt=0.017)
	if not enemyDTs then
		// level over (shortly after last enemy is destroyed)
		if Enemy.Instances then outer.nextWaveTime = time + 2
		if time > nextWaveTime then
			nextWave = curWave + 1
			nextLevel = env.curLevel
			if nextWave > 3 then
				nextWave = 1
				nextLevel += 1
				if nextLevel > 3 then
					endGame "YOU WIN -- EARTH IS SAVED!", "#88FF88"
					return
				end if
			end if
			startLevelWave nextLevel, nextWave
		end if
		return
	end if
	// spawn next enemy when it's time
	enemyDTs[0] -= dt
	if enemyDTs[0] > 0 then return
	enemyDTs.pull
	enemy.spawn enemyTypes.pull
end function

if locals == globals then
	disp.init
	startLevelWave
end if
