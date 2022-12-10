function onCreate()
	setProperty('gfGroup.visible', false);
	makeAnimatedLuaSprite('mirrorWakko', 'characters/wacknikko', 95, 750);
	addAnimationByPrefix('mirrorWakko', 'singDOWN', 'wacknikko down0', 12, true)
	addAnimationByPrefix('mirrorWakko', 'singUP', 'wacknikko up0', 12, true)
	addAnimationByPrefix('mirrorWakko', 'idle', 'wacknikko idle', 12, true)
	addAnimationByPrefix('mirrorWakko', 'singLEFT', 'wacknikko right0', 12, true)
	addAnimationByPrefix('mirrorWakko', 'singRIGHT', 'wacknikko left0', 12, true)
	--setProperty('mirrorWakko.flipX', true);
	setProperty('mirrorWakko.flipY', true);
	scaleObject('mirrorWakko', 0.7, 0.7);
	setProperty('mirrorWakko.alpha', 0.3);
	updateHitbox('mirrorWakko');
	addLuaSprite('mirrorWakko', false);

	makeAnimatedLuaSprite('mirrorBF', 'characters/wackbf', 910, 760);
	addAnimationByPrefix('mirrorBF', 'singDOWN', 'wackbf down0', 12, true)
	addAnimationByPrefix('mirrorBF', 'singUP', 'wackbf up0', 12, true)
	addAnimationByPrefix('mirrorBF', 'idle', 'wackbf idle', 12, true)
	addAnimationByPrefix('mirrorBF', 'singLEFT', 'wackbf right0', 12, true)
	addAnimationByPrefix('mirrorBF', 'singRIGHT', 'wackbf left0', 12, true)
	--setProperty('mirrorBF.flipX', true);
	setProperty('mirrorBF.flipY', true);
	scaleObject('mirrorBF', 0.7, 0.7);
	setProperty('mirrorBF.alpha', 0.3);
	updateHitbox('mirrorBF');
	addLuaSprite('mirrorBF', false);
end



function onUpdatePost()
	objectPlayAnimation('mirrorWakko', getProperty("dad.animation.curAnim.name"), true);
    setProperty("mirrorWakko.animation.frameIndex", getProperty("dad.animation.frameIndex"))

    objectPlayAnimation('mirrorBF', getProperty("boyfriend.animation.curAnim.name"), true);
    setProperty("mirrorBF.animation.frameIndex", getProperty("boyfriend.animation.frameIndex"))
end