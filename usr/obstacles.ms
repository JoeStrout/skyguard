// Spawns random obstacles in the environment.

import "importUtil"
ensureImport "renderer"
ensureImport "mathUtil"
ensureImport "fighter"
ensureImport "listUtil"

maxDist = renderer.maxDist

obstacles = []

Cloud = new Sprite3D
Cloud.image = file.loadImage("/usr/pics/cloud1.png")

Cloud.update = function(dt=0.7)
	super.update dt, false, true
end function

init = function(spriteDisp)
	outer.obstacles = []
	for i in range(19)
		ob = new Cloud
		ob.reset
		ob.wz = mathUtil.randRange(1, maxDist)
		ob.update
		obstacles.push ob
	end for
	obstacles.sort "wz", false
	spriteDisp.sprites += obstacles
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
		spriteDisp.sprites.removeVal obs
		spriteDisp.sprites.insert 1, obs
	end for
end function

test = function
	clear
	init display(4)
	update
end function

if locals == globals then test