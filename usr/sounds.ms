
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
	
	// digitized sounds in .wav files
	for fname in file.children("/usr/sounds")
		if not fname.endsWith(".wav") then continue
		snd = file.loadSound("/usr/sounds/" + fname)
		snd.play3D = @play3D
		outer[fname - ".wav"] = snd
		count += 1
	end for
	
	// synthesized sounds (mostly made with /sys/demo/soundLab!)
	snd = new Sound
	freq = [2093.004, 2.59]
	envelope = [1/3, 0.8/3, 0.8/3, 0.8/3, 0]
	snd.init 0.2, freq, envelope, Sound.squareWave
	snd.play3D = @play3D
	outer.pew = snd
	count += 1
	
	snd = new Sound
	freq = [142.04, 490.37, 1.21, 1.45]
	envelope = [1, 0.8, 0.8, 0.8, 0]
	snd.init 0.2, freq, envelope, Sound.triangleWave
	snd2 = new Sound
	freq = [251.64, 13.11, 1.95]
	envelope = [1, 0.8, 0.8, 0.8, 0]
	snd2.init 0.2, freq, envelope, Sound.triangleWave
	snd.mix snd2
	snd.play3D = @play3D
	outer.blorp = snd
		
	return count
end function




if locals == globals then
	globals.spriteDisp = display(4)
	renderer.init
	count = init
	print count + " sounds loaded."
	blorp.play
end if