import "importUtil"
ensureImport "renderer"
ensureImport "fighter"

globals.Shot = new Sprite3D
Shot.image = file.loadImage("/usr/pics/fighter-shot.png")
Shot.trail = null // list of trail sprites
Shot.speed = 1000  // distance units/sec
Shot.maxDist = renderer.maxDist/2
Shot.Instances = []

Shot.update = function(dt=0.017)
	super.update self.speed * dt, false  // (we'll do our own sorting, below)
	if self.wz > self.maxDist then
		self.vanish
	else
		sprites = spriteDisp.sprites
		idx = sprites.indexOf(self)
		wz = self.wz
		trailRange = self.trail.indexes
		for i in trailRange
			self.trail[i].wz = wz - (i + 1) * 15
			self.trail[i].update 0, false
			self.trail[i].scale *= 0.7 - 0.3*i
		end for
		while idx > 0 and sprites[idx-1].wz < wz
			if sprites[idx-1].hitBy(self) then
				self.vanish
				break
			else
				sprites.swap idx, idx-1
				for i in trailRange
					sprites.swap idx+i+1, idx+i
				end for
				idx -= 1
			end if
		end while
	end if
end function

Shot.vanish = function
	spriteDisp.sprites.removeVal self
	for tp in self.trail
		spriteDisp.sprites.removeVal tp
	end for
	Shot.Instances.removeVal self
end function

spawn = function(wx, wy)
	shot = new Shot
	shot.wx = wx
	shot.wy = wy
	shot.wz = 1
	idx = spriteDisp.sprites.indexOf(fighter.craft)
	spriteDisp.sprites.insert idx, shot
	shot.trail = []
	for i in [1,2]
		trailSp = new Sprite3D
		trailSp.image = shot.image
		trailSp.tint = ["", "#DDDDAACC", "#BBBB55AA"][i]
		trailSp.wx = wx
		trailSp.wy = wy
		trailSp.tz = 1 - i*0.1
		shot.trail.push trailSp
		spriteDisp.sprites.insert idx+i, trailSp		
	end for
	Shot.Instances.push shot
	return shot
end function

updateAll = function(dt=0.017)
	for i in range(Shot.Instances.len-1, 0, -1)
		Shot.Instances[i].update dt
	end for
end function

