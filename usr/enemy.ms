// Enemies fly around, sometimes shoot at you, and you can shoot them.

import "importUtil"
ensureImport "renderer"
ensureImport "mathUtil"

globals.Enemy = new Sprite3D
Enemy.image = file.loadImage("/sys/pics/UFO.png") // for now!
Enemy.Instances = []
Enemy.minDist = 10
Enemy.approachSpeed = 200
Enemy.scoreValue = 100
//Enemy.localBounds = new Bounds
//Enemy.localBounds.width = Enemy.image.width * 0.9
//Enemy.localBounds.height = Enemy.image.height * 0.9
Enemy.secsPerFire = 1
Enemy.nextFireTime = 0

Enemy.update = function(dt=0.017)
	// Enemies close distance slowly, until they're close enough,
	// and then stay there
	dwz = 0
	dwz = -self.approachSpeed * dt
	if self.wz < self.minDist then self.wz = self.minDist
	super.update dwz, true, false
	maxDist = renderer.maxDist
	if self.wz > maxDist - 100 then
		self.tint = color.lerp("#FFFFFF00", "#FFFFFFFF", (maxDist - self.wz) / 100)
	end if
	if self.secsPerFire != null and time > self.nextFireTime then
		shot = EnemyShot.Spawn(self)
		if shot.wz/(shot.approachSpeed/60) < 5 then
			// ensure shot takes at least 5 frames to hit
			shot.approachSpeed = shot.wz / 5 * 60
		end if
		self.nextFireTime = time + self.secsPerFire * (0.8 + rnd * 0.4)
	end if
end function

Enemy.hitBy = function(projectile)
	dSqr = (projectile.wx - self.wx)^2 + ((projectile.wy - self.wy) / 0.6)^2
//	print "dx: " + round(projectile.wx - self.wx) +   "   dy: " + round((projectile.wy - self.wy)) + "   dSqr: " + round(dSqr) + "  dist: " + round(sqrt(dSqr)) + "    "
	if dSqr > 3500 then return false
	self.vanish
	vfx.spawn vfx.Explosion, self.wx, self.wy, self.wz - 1
	globals.score += self.scoreValue
	return true
end function

Enemy.vanish = function
	disp.sprites.removeVal self
	Enemy.Instances.removeVal self
end function

EnemyShot = new Enemy
EnemyShot.approachSpeed = 1500
EnemyShot.minDist = 0.1
EnemyShot.secsPerFire = null
EnemyShot.damage = 15
EnemyShot.scoreValue = 15
EnemyShot.frames = []
img = file.loadImage("/usr/pics/blue-ball.png")
for i in range(0,3)
	EnemyShot.frames.push img.getImage(0, img.width*i, img.width, img.width)
end for
EnemyShot.image = EnemyShot.frames[0]

EnemyShot.Spawn = function(owner)
	noob = new EnemyShot
	noob.wx = owner.wx; noob.wy = owner.wy; noob.wz = owner.wz-1
	disp.sprites.insert 1, noob
	Enemy.Instances.push noob
	return noob
end function	

EnemyShot.update = function(dt=0.017)
	if self.wz == self.minDist then
		// We've reached the level of the fighter; did we hit it?
		dSqr = (self.x - fighter.craft.x)^2 + (self.y - fighter.craft.y)^2
		//print "Dist: " + round(sqrt(dSqr))
		if dSqr < 10000 then fighter.craft.takeHit sounds.electricalHit, self.damage
		self.vanish
		return
	end if
	super.update dt
	self.image = self.frames.any
	self.rotation += 20
	self.scale *= 3
end function

EnemyShot.hitBy = function(projectile)
	dSqr = (projectile.wx - self.wx)^2 + (projectile.wy - self.wy)^2
	if dSqr > 8100 then return false
	self.vanish
	globals.score += self.scoreValue
	return true
end function

spawn = function
	if Enemy.Instances.len > 2 then return // enemy count cap
	noob = new Enemy
	noob.wx = mathUtil.randRange(-760, 760)
	noob.wy = mathUtil.randRange(-490, 490)
	noob.wz = renderer.maxDist
	disp.sprites.insert 1, noob
	Enemy.Instances.push noob
	return noob
end function

updateAll = function(dt=0.017)
	for enemy in Enemy.Instances
		enemy.update dt
	end for
end function
