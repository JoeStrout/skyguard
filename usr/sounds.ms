
import "importUtil"
ensureImport "stringUtil"
ensureImport "renderer"

play3D = function(wXYZ, pitchVariance=0.2, volVariance=0.2)
	screenPos = renderer.screenXY(wXYZ)
	pan = (screenPos - 480) / 400
	vol = (1.2 - wXYZ.wz / renderer.maxDist) - rnd * volVariance
	self.play vol, pan, 1 - pitchVariance + pitchVariance*2*rnd
end function

init = function
	count = 0
	for fname in file.children("/usr/sounds")
		if not fname.endsWith(".wav") then continue
		snd = file.loadSound("/usr/sounds/" + fname)
		snd.play3D = @play3D
		outer[fname - ".wav"] = snd
		count += 1
	end for
	return count
end function




if locals == globals then
	globals.spriteDisp = display(4)
	renderer.init spriteDisp
	count = init
	print count + " sounds loaded."
end if