// Enemies fly around, sometimes shoot at you, and you can shoot them.

import "importUtil"
ensureImport "renderer"
ensureImport "mathUtil"

globals.Enemy = new Sprite3D
Enemy.image = file.loadImage("/sys/pics/UFO.png") // for now!
Enemy.Instances = []
Enemy.minDist = 10
Enemy.approachSpeed = 200
//Enemy.localBounds = new Bounds
//Enemy.localBounds.width = Enemy.image.width * 0.9
//Enemy.localBounds.height = Enemy.image.height * 0.9

Enemy.update = function(dt=0.017)
	// Enemies close distance slowly, until they're close enough,
	// and then stay there
	dwz = 0
	if self.wz > self.minDist then
		dwz = -self.approachSpeed * dt
	end if
	super.update dwz, true, false
	maxDist = renderer.maxDist
	if self.wz > maxDist - 100 then
		self.tint = color.lerp("#FFFFFF00", "#FFFFFFFF", (maxDist - self.wz) / 100)
	end if
end function

Enemy.hitBy = function(projectile)
	dSqr = (projectile.wx - self.wx)^2 + ((projectile.wy - self.wy) * 0.6)^2
//	print "dx: " + round(projectile.wx - self.wx) +   "   dy: " + round((projectile.wy - self.wy)) + "   dSqr: " + round(dSqr) + "  dist: " + round(sqrt(dSqr)) + "    "
	if dSqr > 2500 then return false
	self.vanish
	vfx.spawnExplosion self.wx, self.wy, self.wz - 1
end function

Enemy.vanish = function
	spriteDisp.sprites.removeVal self
	Enemy.Instances.removeVal self
end function

spawn = function
	if Enemy.Instances.len > 2 then return // enemy count cap
	noob = new Enemy
	noob.wx = mathUtil.randRange(-760, 760)
	noob.wy = mathUtil.randRange(-490, 490)
	noob.wz = renderer.maxDist
	spriteDisp.sprites.insert 1, noob
	Enemy.Instances.push noob
end function

updateAll = function(dt=0.017)
	for enemy in Enemy.Instances
		enemy.update dt
	end for
end function
