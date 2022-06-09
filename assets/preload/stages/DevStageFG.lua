function onCreate()

	if lowQuality then

	else
		makeLuaSprite('FG_Dev','FG_Dev', -902, -450);  
		setScrollFactor('FG_Dev', 1.2, 1.2); 
		scaleObject('FG_Dev', 1.2, 1.2);

		makeAnimatedLuaSprite('crowd','crowd', -630, 500); 
		addAnimationByPrefix('crowd','cheer','crowd idle',18,true); 
		setScrollFactor('crowd', 1.3, 1.3); 
		scaleObject('crowd', 1, 1);

		addLuaSprite('FG_Dev', true);
		addLuaSprite('crowd', true);
	end 
	close(true);	
	--For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end