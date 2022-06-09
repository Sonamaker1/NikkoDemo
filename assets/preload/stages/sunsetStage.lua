
function onCreate()
	addLuaScript('stages/unlockScript') 
	
	
	makeLuaSprite("Yellow",'',-screenWidth/2,-screenHeight/2)
	makeGraphic("Yellow",2,2, 'ffe478')
	scaleObject("Yellow",screenWidth*2, screenHeight*2);
	addLuaSprite("Yellow",false)

	local scl = 0.1

	function ux(x) 
		return x - 60 - 120/(scl+1);
	end

	function uy(y) 
		return y - 375 - 75/(scl+1);
	end

	scl = 0
	-- background shit
	makeLuaSprite(		'Sun01', 'Sun01', ux(30), uy(75));
	setScrollFactor(	'Sun01', scl, scl);
	scaleObject(		'Sun01', 1.0, 1.0);
	addLuaSprite(		'Sun01', false);

	scl = 0.1
	makeLuaSprite(		'Sun02', 'Sun02', ux(30), uy(75));
	setScrollFactor(	'Sun02', scl, scl);
	scaleObject(		'Sun02', 1.0, 1.0);
	addLuaSprite(		'Sun02', false);

	scl = 0.2
	makeLuaSprite(		'Sun03', 'Sun03', ux(30), uy(75)-35/scl);
	setScrollFactor(	'Sun03', scl, scl);
	scaleObject(		'Sun03', 1.0, 1.0);
	addLuaSprite(		'Sun03', false);

	scl = 0.2
	makeLuaSprite(		'Sun04', 'Sun04', ux(30), uy(75)-35/scl);
	setScrollFactor(	'Sun04', scl, scl);
	scaleObject(		'Sun04', 1.0, 1.0);
	addLuaSprite(		'Sun04', false);

	scl = 0.3
	makeLuaSprite(		'Sun05', 'Sun05', ux(30), uy(75)-35/scl);
	setScrollFactor(	'Sun05', scl, scl);
	scaleObject(		'Sun05', 1.0, 1.0);
	addLuaSprite(		'Sun05', false);

	scl = 0.5
	makeLuaSprite(		'Sun06', 'Sun06', ux(30), uy(75)-35/scl);
	setScrollFactor(	'Sun06', scl, scl);
	scaleObject(		'Sun06', 1.0, 1.0);
	addLuaSprite(		'Sun06', false);

	scl = 1.0
	makeLuaSprite(		'Sun07', 'Sun07', 30, 75);
	setScrollFactor(	'Sun07', scl, scl);
	scaleObject(		'Sun07', 1.0, 1.0);
	addLuaSprite(		'Sun07', false);

	-- makeLuaSprite('mockup', 'testStageFlat', 30, 75);
	-- setScrollFactor('mockup', 1.0, 1.0);
	-- scaleObject('mockup', 1.0, 1.0);
	-- addLuaSprite('mockup', false);
	
	makeAnimatedLuaSprite('LU', 'DevUN', 1329, 1325);
	addAnimationByPrefix('LU', 'unlock', 'devUN0', 36, false)
	updateHitbox('LU');
	addLuaSprite('LU', false);
	objectPlayAnimation('LU', 'unlock', true);

	

	setProperty('gfGroup.visible', false);
	

	
	--setProperty('inCutscene', true);
	--startDialogue('stages/unlockDialogue');
	--return Function_Stop;

	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end