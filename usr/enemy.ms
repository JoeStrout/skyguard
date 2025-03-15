// Enemies fly around, sometimes shoot at you, and you can shoot them.

import "importUtil"
ensureImport "renderer"
ensureImport "mathUtil"
ensureImport "disp"

globals.Enemy = new Sprite3D
Enemy.image = file.loadImage("/sys/pics/UFO.png") // for now!
Enemy.Instances = []
Enemy.InvaderCount = 0
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
	if self.wz + dwz < self.minDist then
		self.wz = self.minDist
		dwz = 0
	end if
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

Enemy.isHitByPoint = function(worldPos)
	// Note: we only check x and y, because we assume this is only called for
	// projectiles that have already crossed our Z plane.
	dSqr = (worldPos.wx - self.wx)^2 + ((worldPos.wy - self.wy) * self.aspectRatio)^2
//	print "dx: " + round(projectile.wx - self.wx) +   "   dy: " + round((projectile.wy - self.wy)) + "   dSqr: " + round(dSqr) + "  dist: " + round(sqrt(dSqr)) + "    "
	return dSqr < self.hitRSqr
end function

Enemy.hitBy = function(projectile)
	if not self.isHitByPoint(projectile) then return false
	self.vanish
	vfx.spawn vfx.Explosion, self.wx, self.wy, self.wz - 1
	globals.score += self.scoreValue
	return true
end function

Enemy.vanish = function
	disp.sprites.removeVal self
	Enemy.Instances.removeVal self
	if not self isa EnemyShot then Enemy.InvaderCount -= 1
end function


Enemy1 = new Enemy
Enemy1.image = file.loadImage("/usr/pics/ufo-1.png")
Enemy1.aspectRatio = 3.3
Enemy1.hitRSqr = 24000

Enemy2 = new Enemy
Enemy2.image = file.loadImage("/usr/pics/ufo-2.png")
Enemy2.aspectRatio = 2.2
Enemy2.hitRSqr = 18000

Enemy3 = new Enemy
Enemy3.image = file.loadImage("/usr/pics/ufo-3.png")
Enemy3.aspectRatio = 2.2
Enemy3.hitRSqr = 15000

Enemy4 = new Enemy
Enemy4.image = file.loadImage("/usr/pics/ufo-4.png")
Enemy4.aspectRatio = 3
Enemy4.hitRSqr = 55000



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
	sounds.blorp.play3D self
	return noob
end function	

EnemyShot.update = function(dt=0.017)
	if self.wz == self.minDist then
		// We've reached the level of the fighter; did we hit it?
		dSqr = (self.x - fighter.craft.x)^2 + (self.y - fighter.craft.y)^2
		//print "Dist: " + round(sqrt(dSqr))
		if not fighter.craft.dead and dSqr < 10000 then
			fighter.craft.takeHit sounds.electricalHit, self.damage
		end if
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

spawn = function(typeNum)
	if Enemy.Instances.len > 20 then return // enemy count cap
	noob = new [Enemy1, Enemy2, Enemy3, Enemy4][typeNum]
	noob.wx = mathUtil.randRange(-760, 760)
	noob.wy = mathUtil.randRange(-490, 490)
	noob.wz = renderer.maxDist
	disp.sprites.insert 1, noob
	Enemy.Instances.push noob
	Enemy.InvaderCount += 1
	return noob
end function

updateAll = function(dt=0.017)
	for enemy in Enemy.Instances
		enemy.update dt
	end for
end function


testHitbox = function(class)
	disp.init
	disp.background.x = 0; disp.background.y = 0
	globals.obj = new class
	obj.reset
	obj.wx = 480
	obj.wy = 320
	obj.wz = obj.minDist
	obj.scale = 0.75
	disp.sprites.push obj
	obj.update
	for y in range(0, 640, 20)
		for x in range(0, 960, 20)
			wp = {"wx":x, "wy":y, "wz": obj.wz}
			if obj.isHitByPoint(wp) then c = color.red else c = color.blue
			if x == 240 and y == 160 then print wp + " -> " + obj.isHitByPoint(wp)
			gfx.fillRect x-1, y-1, 3, 3, c
		end for
	end for
end function
	

if locals == globals then testHitbox Enemy4