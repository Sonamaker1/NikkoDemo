function onCreate()
	-- background shit
	makeLuaSprite('00', '00', -750, -500);
	setScrollFactor('00', 0.9, 0.9);
	scaleObject('00', 1.2, 1.2);


	addLuaSprite('00', false);

	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end