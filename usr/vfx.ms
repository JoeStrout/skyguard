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
	
	Explosion.frames = explosionFrames
	Explosion.sound = sounds.explosion_1

	ShotSplash.frames = explosionFrames[:2] * 3
	ShotSplash.sound = sounds.laserHit
end function

VfxSprite = new Sprite3D
VfxSprite.frames = null
VfxSprite.curFrameNum = -1
VfxSprite.Instances = []
VfxSprite.sound = null

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
	disp.sprites.removeVal self
	VfxSprite.Instances.removeVal self
end function

Explosion = new VfxSprite

ShotSplash = new VfxSprite

ShotSplash.update = function(dt)
	super.update
	if self.curFrameNum <= 6 then
		self.scale *= [1, 1.2, 1.5, 1.2, 1, 0.8, 0.4][self.curFrameNum]
	end if
end function

spawn = function(vfxClass, wx, wy, wz)
	effect = new vfxClass
	effect.wx = wx; effect.wy = wy; effect.wz = wz
	VfxSprite.Instances.push effect
	disp.sprites.push effect
	effect.update
	if effect.sound then effect.sound.play3D effect
	return effect
end function

updateAll = function(dt=0.017)
	for i in range(VfxSprite.Instances.len-1, 0, -1)
		VfxSprite.Instances[i].update dt
	end for
end function

	