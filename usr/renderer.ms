// Quick prototype of single-point perspective projection.

import "importUtil"
ensureImport "mathUtil"
ensureImport "listUtil"

maxDist = 2000

screenXY = function(wXYZ)
	p = 300 / (300 + wXYZ.wz)
	background = disp.background
	return {"x": mathUtil.lerp(480, background.x + wXYZ.wx, p),
			"y": mathUtil.lerp(320, background.y + wXYZ.wy, p) }
end function


globals.Sprite3D = new Sprite
Sprite3D.wx = 0		// pixels relative to center of background when scale=1
Sprite3D.wy = 0		
Sprite3D.wz = maxDist	// distance from camera
Sprite.fadeOutDist = 20

Sprite3D.isHitByPoint = function(xy)
	return false
end function

Sprite3D.hitBy = function(projectile)
	return false
end function

Sprite.perspectiveFactor = function
	return 300 / (300 + self.wz)
end function

Sprite3D.reset = function
	self.wx = mathUtil.randRange(-3000, 3000)
	self.wy = mathUtil.randRange(-1000, 1000)
	self.wz = maxDist
	self.tint = "#FFFFFF"
end function

Sprite3D.update = function(dz=0, resort=false, fadeInOut=false)
	self.wz += dz
	if self.wz < 0.1 then self.wz = 0.1
	p = self.perspectiveFactor
	background = disp.background
	self.x = mathUtil.lerp(480, background.x + self.wx, p)
//	self.y = background.y + self.wy * p
	self.y = mathUtil.lerp(320, background.y + self.wy, p)
	self.scale = p
	if resort then self.resort
	if fadeInOut then
		maxDist = renderer.maxDist
		if self.wz > maxDist - 100 then
			self.tint = color.lerp("#FFFFFF00", "#FFFFFFFF", (maxDist - self.wz) / 100)
		else if self.wz < self.fadeOutDist then
			self.tint = color.lerp("#FFFFFF00", self.tint, self.wz/self.fadeOutDist)
		end if
	end if
end function

Sprite3D.resort = function
	sprites = disp.sprites
	idx = sprites.indexOf(self)
	wz = self.wz
	while idx > 0 and sprites[idx-1].wz < wz
		sprites.swap idx, idx - 1
		idx -= 1
	end while
	maxIdx = sprites.len - 1
	while idx < maxIdx and sprites[idx+1].wz > wz
		sprites.swap idx, idx + 1
		idx += 1
	end while
end function

init = function
	// Nothing to do!  :)
end function

update = function(dt=0.017)
	fc = fighter.craft
	background = disp.background
	background.x = mathUtil.clamp(background.x - (fc.x-480)*dt, 0, 960)
	background.y = mathUtil.clamp(background.y - (fc.y-320)*dt, 0, 640)	
end function


test = function
	clear
	init
	obstacles.init
	
	while true
		yield
		background = disp.background
		background.x = mathUtil.clamp(background.x - key.axis("Horizontal")*2, 0, 960)
		background.y = mathUtil.clamp(background.y - key.axis("Vertical")*2, 0, 640)
		obstacles.update	
	end while
end function

if locals == globals then test

