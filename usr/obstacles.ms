// Spawns random obstacles in the environment.

import "importUtil"
ensureImport "renderer"
ensureImport "mathUtil"
ensureImport "fighter"
ensureImport "listUtil"

maxDist = renderer.maxDist

obstacles = []

Cloud = new Sprite3D
Cloud.images = []
for i in range(1, 7)
	Cloud.images.push file.loadImage("/usr/pics/cloud" + i + ".png")
end for
Cloud.reset = function
	super.reset
	self.wy = mathUtil.randRange(-600, 400)
	self.image = Cloud.images.any
end function

Cloud.update = function(dt=0.7)
	super.update dt, false, true
end function

IBeam = new Sprite3D
IBeam.image = file.loadImage("/usr/pics/IBeam.png")
IBeam.localBounds = new Bounds
IBeam.localBounds.width = IBeam.image.width
IBeam.localBounds.height = IBeam.image.height
IBeam.canHitShip = true

IBeam.isHitByPoint = function(pt)
	// start with basic bounds test
	if not self.worldBounds.contains(pt) then return false
	// then, do funny I-beam shape via local points
	x = (pt.x - self.x) / self.scale
	y = (pt.y - self.y) / self.scale
	if -50 < x < 50 then return true
	if -170 < y < 170 then return false
	return true
end function

IBeam.hitBy = function(projectile)
	if not self.isHitByPoint(projectile) then return false
	vfx.spawn vfx.ShotSplash, projectile.wx, projectile.wy, projectile.wz - 1
	vfx.spawn vfx.Explosion, self.wx, self.wy, self.wz - 1
	vfx.spawn vfx.Explosion, self.wx, self.wy + 200, self.wz - 1
	vfx.spawn vfx.Explosion, self.wx, self.wy - 200, self.wz - 1
	self.reset
	globals.score += 2
	return true
end function

IBeam.update = function(dt=0.7)
	super.update dt, false, true
	if self.wz < self.fadeOutDist and self.canHitShip then
		if self.isHitByPoint(fighter.craft) then
			fighter.craft.takeHit sounds.impactHit, 35
			self.tint = "#FFAAAA"
			self.canHitShip = false
		end if
	end if
end function

Asteroid = new Sprite3D
Asteroid.fadeOutDist = 3
Asteroid.images = []
for i in range(1, 5)
	Asteroid.images.push file.loadImage("/usr/pics/asteroid" + i + ".png")
end for
Asteroid.canHitShip = true

Asteroid.reset = function
	super.reset
	self.image = Asteroid.images.any
	self.localBounds = new Bounds
	self.localBounds.width = self.image.width
	self.localBounds.height = self.image.height
	self.tint = "#FFFFFF"
end function

Asteroid.update = function(dt=0.7)
	super.update dt, false, true
	if self.wz < self.fadeOutDist and self.canHitShip then
		if self.isHitByPoint(fighter.craft) then
			fighter.craft.takeHit sounds.impactHit, 35
			self.tint = "#FFAAAA"
			self.canHitShip = false
		end if
	end if
end function

Asteroid.isHitByPoint = function(pt)
	// start with basic bounds test
	if not self.worldBounds.contains(pt) then return false
	// then, do ellipse test
	x = (pt.x - self.x) / self.scale
	y = (pt.y - self.y) / self.scale
	a = self.localBounds.width / 2
	b = self.localBounds.height / 2
	return x^2/a^2 + y^2/b^2 <= 1
end function

Asteroid.hitBy = function(projectile)
	if not self.isHitByPoint(projectile) then return false
	vfx.spawn vfx.ShotSplash, projectile.wx, projectile.wy, projectile.wz - 1
	return true
end function


init = function(obstacleClass)
	outer.obstacles = []
	for i in range(19)
		ob = new obstacleClass
		ob.reset
		ob.wz = mathUtil.randRange(1, maxDist)
		ob.update
		obstacles.push ob
	end for
	obstacles.sort "wz", false
	for ob in obstacles
		disp.sprites.push ob
	end  for
end function

update = function(dz=5)
	qtyToReset = 0
	for ob in obstacles
		if ob.wz <= 0.1 then
			qtyToReset += 1
		else
			ob.update -dz
		end if
	end for
	for i in range(1, qtyToReset, 1)
		obs = obstacles.pop
		obs.reset
		obs.update
		obstacles.insert 0, obs
		disp.sprites.removeVal obs
		disp.sprites.insert 1, obs
	end for
end function

clear = function
	for ob in obstacles
		disp.sprites.removeVal ob
	end for
	outer.obstacles = []
end function

test = function
	globals.clear
	init display(4)
	update
end function

testHitbox = function(class)
	disp.init
	globals.obj = new class
	obj.reset
	obj.x = 480
	obj.y = 320
	obj.scale = 0.75
	disp.sprites.push obj
	for y in range(0, 640, 20)
		for x in range(0, 960, 20)
			p = {"x":x, "y":y}
			if obj.isHitByPoint(p) then c = color.red else c = color.blue
			gfx.fillRect x-1, y-1, 3, 3, c
		end for
	end for
end function
	

if locals == globals then testHitbox Asteroid
