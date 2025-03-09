// Quick prototype of single-point perspective projection.

import "importUtil"
ensureImport "mathUtil"
ensureImport "listUtil"
ensureImport "obstacles"


maxDist = 2000

globals.Sprite3D = new Sprite
Sprite3D.wx = 0		// pixels relative to center of background when scale=1
Sprite3D.wy = 0		
Sprite3D.wz = maxDist	// distance from camera

Sprite.perspectiveFactor = function
	return 300 / (300 + self.wz)
end function

Sprite3D.reset = function
	self.wx = mathUtil.randRange(-3000, 3000)
	self.wy = mathUtil.randRange(-500, 500)
	self.wz = maxDist
	self.tint = "#FFFFFF"
end function

Sprite3D.update = function(dz=0)
	self.wz -= dz
	if self.wz < 0.1 then self.wz = 0.1
	p = self.perspectiveFactor
	self.x = background.x + self.wx * p
	self.y = background.y + self.wy * p
	self.scale = p
	if self.wz > maxDist - 100 then
		self.tint = color.lerp("#FFFFFF00", "#FFFFFFFF", (maxDist - self.wz) / 100)
	else if self.wz < 10 then
		self.tint = color.lerp("#FFFFFF00", "#FFFFFFFF", self.wz/10)
	end if
end function


init = function(spriteDisp)
	outer.background = new Sprite
	background.image = file.loadImage("/usr/pics/sky-Earth.png")
	background.scale = 2
	background.x = 480
	background.y = 320
	spriteDisp.sprites.insert 0, background
end function

update = function(dt=0.017)
	fc = fighter.craft
	background.x = mathUtil.clamp(background.x - (fc.x-480)*dt, 0, 960)
	background.y = mathUtil.clamp(background.y - (fc.y-320)*dt, 0, 640)
	
end function


test = function
	clear
	globals.spriteDisp = display(4)	 // HACK
	init
	obstacles.init spriteDisp
	
	while true
		yield
		background.x = mathUtil.clamp(background.x - key.axis("Horizontal")*2, 0, 960)
		background.y = mathUtil.clamp(background.y - key.axis("Vertical")*2, 0, 640)
		obstacles.update	
	end while
end function

if locals == globals then test

