import "importUtil"
ensureImport "mathUtil"
ensureImport "listUtil"
ensureImport "obstacles"
ensureImport "renderer"
ensureImport "fighter"

setup = function
	clear
	globals.spriteDisp = display(4) // HACK
	renderer.init spriteDisp
	obstacles.init spriteDisp
	fighter.init spriteDisp
end function

update = function(dt=0.017)
	yield
	obstacles.update 6
	fighter.craft.update dt
	renderer.update dt
end function

// Main program
setup
while true
	update 0.017
	yield
end while
