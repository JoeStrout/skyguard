// Purely visual effects like explosions, etc.
// Some of these also make sound fx.

init = function
	frames = []
	src = file.loadImage("/usr/pics/explosion.png")
	size = src.width
	y = 0
	while y < src.height
		frames.push src.getImage(0, y, size, size)
		y += size
	end while
	outer.explosionFrames = frames
end function

VfxSprite = new Sprite3D
VfxSprite.frames = null
VfxSprite.curFrameNum = -1
VfxSprite.Instances = []

VfxSprite.update = function(dt)
	self.curFrameNum += 1
	if self.curFrameNum >= self.frames.len then
		self.vanish
	else
		self.image = self.frames[self.curFrameNum]
		super.update
	end if
end function

VfxSprite.vanish = function
	spriteDisp.sprites.removeVal self
	VfxSprite.Instances.removeVal self
end function

spawnExplosion = function(wx, wy, wz)
	boom = new VfxSprite
	boom.frames = explosionFrames
	boom.wx = wx; boom.wy = wy; boom.wz = wz
	VfxSprite.Instances.push boom
	spriteDisp.sprites.push boom
	boom.update
	sounds.explosion_1.play3D boom
end function

updateAll = function(dt=0.017)
	for i in range(VfxSprite.Instances.len-1, 0, -1)
		VfxSprite.Instances[i].update dt
	end for
end function

	