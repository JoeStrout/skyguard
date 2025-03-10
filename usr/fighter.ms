import "importUtil"
ensureImport "mathUtil"
ensureImport "gameInput"
ensureImport "shot"
ensureImport "disp"

speed = 100  // distance units per second

globals.Craft = new Sprite
Craft.targetRot = 0
Craft.vx = 0
Craft.vy = 0
Craft.fireCooldown = 0
Craft.redTill = null
Craft.shield = 100
Craft.shieldRegen = 1 // shield points/sec
Craft.rolling = false
Craft.wasInpRollDown = [false, false]  // was left, right roll pressed last frame?
Craft.lastRollInpTime = [-1, -1]  // input time for left, right rolls

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
	return self.x - disp.background.x
end function

Craft.wy = function
	return self.y - disp.background.y
end function

Craft.wz = 0.1

Craft.fire = function
	craft.fireBox.x = craft.x
	craft.fireBox.y = craft.y
	craft.fireBox.rotation = craft.rotation
	corners = craft.fireBox.corners
	shot.spawn corners[0][0] - disp.background.x, 
	  corners[0][1] - disp.background.y
	shot.spawn corners[3][0] - disp.background.x, 
	  corners[3][1] - disp.background.y
end function

Craft.handleInputs = function(dt=0.017)
	inpX = gameInput.flightHorz
	inpY = gameInput.flightVert
	self.targetRot = -60 * inpX
	
	for i in [0,1]
		if i then rollPressed = (inpX > 0.1) else rollPressed = (inpX < -0.1)
		justPressed = rollPressed and not self.wasInpRollDown[i]
		if justPressed then
			dblTime = time - self.lastRollInpTime[i]
			self.rolling = (dblTime < 0.5)
			self.lastRollInpTime[i] = time
		end if
		self.wasInpRollDown[i] = rollPressed
	end for
	if -0.1 <= inpX <= 0.1 then self.rolling = false
	if self.rolling then
		self.rotation -= 360 * inpX * dt
		self.rotation = (self.rotation + 36000) % 360
		if self.rotation > 180 then self.rotation -= 360
		self.targetRot = self.rotation
		radians = self.rotation * pi/180
		s = sign(inpX)
		self.vx = s * 800 * cos(radians)
		self.vy = s * 800 * sin(radians) + 100 * inpY
	else
		self.rotation = mathUtil.moveTowards(self.rotation, self.targetRot, 120*dt)		
		self.vx = mathUtil.moveTowards(self.vx, 0, 1000 * dt)
		self.vx = mathUtil.clamp(self.vx + inpX * 2000 * dt, -50000, 50000) * 0.99
	end if
	
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
//	print "bgx: " + round(disp.background.x) + "   bgy: " + round(disp.background.y) + "    "
	if self.redTill != null and time > self.redTill then
		self.tint = color.white
		self.redTill = null
	end if
	self.shield = mathUtil.clamp(self.shield + self.shieldRegen * dt, 0, 100)
end function

Craft.takeHit = function(sound, damage)
	sound.play3D self
	self.tint = "#FFAAAA"
	self.redTill = time + 0.25
	self.shield -= damage
	if self.shield <= 0 then
		hud.update
		text.color = color.orange
		text.row = 5
		print "GAME OVER"
		_printMark "To play again, type `run` and press Return."
		wait
		key.clear
		exit
	end if
end function

init = function
	outer.craft = new Craft
	craft.image = file.loadImage("/usr/pics/fighter.png")
	craft.scale = 0.5
	disp.fg.sprites.push craft
	craft.x = 480
	craft.y = 320
	
	craft.flares = []
	flarePic = file.loadImage("/usr/pics/flare.png")
	for i in [0,1]
		fl = new Sprite
		fl.image = flarePic
		fl.scale = craft.scale
		craft.flares.push fl
		disp.fg.sprites.push fl
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
	disp.init
	init
	while true
		craft.update
		yield
	end while
end function

if locals == globals then test
