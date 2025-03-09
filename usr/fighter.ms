import "importUtil"
ensureImport "mathUtil"
ensureImport "gameInput"
ensureImport "shot"

speed = 100  // distance units per second

globals.Craft = new Sprite
Craft.targetRot = 0
Craft.vx = 0
Craft.vy = 0
Craft.fireCooldown = 0

Craft.updateFlares = function
	craft.flareBox.x = craft.x
	craft.flareBox.y = craft.y
	craft.flareBox.rotation = craft.rotation
	corners = craft.flareBox.corners
	craft.flares[0].x = corners[0][0]
	craft.flares[0].y = corners[0][1]
	craft.flares[1].x = corners[3][0]
	craft.flares[1].y = corners[3][1]
	craft.flares[0].scale = 0.7 + rnd * 0.4
	craft.flares[1].scale = 0.7 + rnd * 0.4
end function

Craft.wx = function
	return self.x - renderer.background.x
end function

Craft.wy = function
	return self.y - renderer.background.y
end function

Craft.fire = function
	craft.fireBox.x = craft.x
	craft.fireBox.y = craft.y
	craft.fireBox.rotation = craft.rotation
	corners = craft.fireBox.corners
	shot.spawn corners[0][0] - renderer.background.x, 
	  corners[0][1] - renderer.background.y
	shot.spawn corners[3][0] - renderer.background.x, 
	  corners[3][1] - renderer.background.y
end function

Craft.handleInputs = function(dt=0.017)
	inpX = gameInput.flightHorz
	inpY = gameInput.flightVert
	self.targetRot = -60 * inpX
	
	self.rotation = mathUtil.moveTowards(self.rotation, self.targetRot, 120*dt)
	
	self.vx = mathUtil.moveTowards(self.vx, 0, 1000 * dt)
	self.vx = mathUtil.clamp(self.vx + inpX * 2000 * dt, -500, 500) * 0.99
	self.x += self.vx * dt
	if self.x < 100 then
		self.x = 100
//		self.vx = 0
	else if self.x > 860 then
		self.x = 860
//		self.vx = 0
	end if
	
	self.vy = mathUtil.moveTowards(self.vy, 0, 1000 * dt)
	self.vy = mathUtil.clamp(self.vy + inpY * 2000 * dt, -400, 400) * 0.99
	self.y += self.vy * dt
	if self.y < 50 then
		self.y = 50
		self.vy = 0
	else if self.y > 590 then
		self.y = 590
		self.vy = 0
	end if
	
	self.fireCooldown -= dt
	if self.fireCooldown <= 0 and gameInput.fire then
		self.fireCooldown = 0.2
		self.fire
	end if
end function

Craft.update = function(dt=0.017)
	self.handleInputs dt
	self.updateFlares
//	text.row = 25; print "wx:  " + round(self.wx) + "   wy:  " + round(self.wy) + "    "
//	print "bgx: " + round(renderer.background.x) + "   bgy: " + round(renderer.background.y) + "    "
end function

init = function(spriteDisp)
	outer.craft = new Craft
	craft.image = file.loadImage("/usr/pics/fighter.png")
	craft.scale = 0.5
	spriteDisp.sprites.push craft
	craft.x = 480
	craft.y = 320
	
	craft.flares = []
	flarePic = file.loadImage("/usr/pics/flare.png")
	for i in [0,1]
		fl = new Sprite
		fl.image = flarePic
		fl.scale = craft.scale
		craft.flares.push fl
		spriteDisp.sprites.push fl
	end for
	craft.flareBox = new Bounds  // used to calculate position of engine flares
	craft.flareBox.width = 72*craft.scale
	craft.flareBox.height = 24*craft.scale
	craft.updateFlares
	craft.fireBox = new Bounds  // used to calculate position of guns
	craft.fireBox.width = 156
	craft.fireBox.height = 30
end function


test = function
	clear
	init display(4)
	while true
		craft.update
		yield
	end while
end function

if locals == globals then test
