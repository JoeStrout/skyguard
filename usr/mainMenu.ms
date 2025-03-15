clear
import "mathUtil"
import "events"

gfx.drawImage file.loadImage("/usr/pics/titleScreen.png")

fadeOut = function
	display(0).mode = displayMode.solidColor
	fader = display(0)
	for alpha in range(0, 255, 3)
		fader.color = color.rgba(0,0,0, alpha)
		yield
	end for
end function

SelRing = new events.EventSprite
SelRing.image = file.loadImage("/usr/pics/levelSelectRing.png")
SelRing.tint = "#AAAAAA"
SelRing.localBounds = new Bounds
SelRing.localBounds.width = SelRing.image.width
SelRing.localBounds.height = SelRing.image.height
SelRing.selected = false

SelRing.select = function(selectIt=true)
	if selectIt then self.tint = "#FFFF88" else self.tint = "#AAAAAA"
	self.selected = selectIt
	if selectIt then env.curLevel = levelSelectRings.indexOf(self) + 1
end function

SelRing.onClick = function
	for ring in levelSelectRings
		ring.select ring == self
	end for
end function

levelSelectRings = []
for i in [0,1,2]
	ring = new SelRing
	ring.start
	levelSelectRings.push ring
end for
if not (env.hasIndex("curLevel") and 0 < env.curLevel <= 3) then env.curLevel = 1
levelSelectRings[env.curLevel - 1].select

levelSelectRings[0].x = 382 + 211/2
levelSelectRings[0].y = 640 - 214 - 211/2
levelSelectRings[1].x = 654 + 211/2
levelSelectRings[1].y = 640 - 151 - 211/2
levelSelectRings[2].x = 730 + 211/2
levelSelectRings[2].y = 640 - 412 - 211/2


Checkbox = new events.EventSprite
Checkbox.image = file.loadImage("/usr/pics/checkboxX.png")
Checkbox.localBounds = new Bounds
Checkbox.localBounds.height = Checkbox.image.height + 8
Checkbox.localBounds.width = 600
Checkbox.onClick = function
	if self.tint == color.clear then
		self.tint = color.white
	else
		self.tint = color.clear
	end if
end function

checkboxes = []
for i in [0,1]
	cb = new Checkbox
	cb.x = 50
	cb.y = [105, 55][i]
	cb.start
end for

playBtn = new events.EventSprite
playBtn.images = [
	file.loadImage("/usr/pics/playButton.png"),
	file.loadImage("/usr/pics/playButton-pressed.png") ]
playBtn.image = playBtn.images[0]
playBtn.localBounds = new Bounds
playBtn.localBounds.width = playBtn.image.width
playBtn.localBounds.height = playBtn.image.height
playBtn.x = 411 + playBtn.image.width/2
playBtn.y = 70

playBtn.onClick = function
	self.image = self.images[1]
end function

playBtn.onDrag = function
	self.image = self.images[self.contains(mouse)]
end function

playBtn.onDragEnd = function
	if self.image == self.images[1] then
		self.image = self.images[0]
		fadeOut
		
		// Bug?  The sprite display will be messed up when we return
		// if we don't clear it now:
		events.spriteDisplay.clear
		// ToDo: investigate!
		
		reset; run "main"
	end if
end function
playBtn.start

events.eventLoop.run
