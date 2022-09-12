function onCreate()
	setProperty('gfGroup.visible', false);
	setPropertyFromClass('GameOverSubstate', 'characterName', 'nikkoplayer'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'loss_sfx'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --put in mods/music/
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/

	makeAnimatedLuaSprite('mirrorNikko', 'characters/nikkoplayer', 970, 680);
	addAnimationByPrefix('mirrorNikko', 'singUPmiss', 'nikko upmiss', 18, true)
	addAnimationByPrefix('mirrorNikko', 'singDOWNmiss', 'nikko downmiss', 18, true)
	addAnimationByPrefix('mirrorNikko', 'singDOWN', 'nikko down0', 18, true)
	addAnimationByPrefix('mirrorNikko', 'singUP', 'nikko up0', 18, true)
	addAnimationByPrefix('mirrorNikko', 'idle', 'nikko idle', 18, true)
	addAnimationByPrefix('mirrorNikko', 'singLEFTmiss', 'nikko rightmiss', 18, true)
	addAnimationByPrefix('mirrorNikko', 'singRIGHTmiss', 'nikko leftmiss', 18, true)
	addAnimationByPrefix('mirrorNikko', 'singLEFT', 'nikko right0', 18, true)
	addAnimationByPrefix('mirrorNikko', 'singRIGHT', 'nikko left0', 18, true)
	setProperty('mirrorNikko.flipX', true);
	setProperty('mirrorNikko.flipY', true);
	setProperty('mirrorNikko.alpha', 0.3);
	updateHitbox('mirrorNikko');
	addLuaSprite('mirrorNikko', false);

	makeAnimatedLuaSprite('mirrorMinikko', 'characters/minikko', 350, 680);
	addAnimationByPrefix('mirrorMinikko', 'singDOWN', 'minikko down0', 12, true)
	addAnimationByPrefix('mirrorMinikko', 'singUP', 'minikko up0', 12, true)
	addAnimationByPrefix('mirrorMinikko', 'idle', 'minikko idle', 12, true)
	addAnimationByPrefix('mirrorMinikko', 'singLEFT', 'minikko left0', 12, true)
	addAnimationByPrefix('mirrorMinikko', 'singRIGHT', 'minikko right0', 12, true)
	--setProperty('mirrorMinikko.flipX', false);
	setProperty('mirrorMinikko.flipY', true);
	setProperty('mirrorMinikko.alpha', 0.3);
	updateHitbox('mirrorMinikko');
	addLuaSprite('mirrorMinikko', false);
end

function onCreatePost()
	setProperty('mirrorMinikko.x', getProperty('dad.x'))
	setProperty('mirrorNikko.x', getProperty('boyfriend.x'))
	setProperty('mirrorMinikko.y', getProperty('dad.y')+getProperty('dad.height')-140)
	setProperty('mirrorNikko.y', getProperty('boyfriend.y')+getProperty('boyfriend.height')-70)
end

function onUpdatePost()
    objectPlayAnimation('mirrorMinikko', getProperty("dad.animation.curAnim.name"), true);
    setProperty("mirrorMinikko.animation.frameIndex", getProperty("dad.animation.frameIndex"))

    objectPlayAnimation('mirrorNikko', getProperty("boyfriend.animation.curAnim.name"), true);
    setProperty("mirrorNikko.animation.frameIndex", getProperty("boyfriend.animation.frameIndex"))
end
