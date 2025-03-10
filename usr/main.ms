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
end function

// Main program
setup
levels.startLevelWave 2, 1
nextEnemySpawnTime = time + 2
while true
	if time > nextEnemySpawnTime then
		enemy.spawn
		nextEnemySpawnTime = time + 3
	end if
	update 0.017
	yield
end while
