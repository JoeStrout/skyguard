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

setup = function
	clear
	globals.spriteDisp = display(4) // HACK
	renderer.init spriteDisp
	obstacles.init spriteDisp
	fighter.init spriteDisp
	sounds.init
	vfx.init
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
end function

// Main program
setup
nextEnemySpawnTime = time + 2
while true
	if time > nextEnemySpawnTime then
		enemy.spawn
		nextEnemySpawnTime = time + 3
	end if
	update 0.017
	yield
end while
