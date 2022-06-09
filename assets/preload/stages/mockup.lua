function onCreate()
	-- background shit
	makeLuaSprite('mockup', 'mockup', -500, -500);
	setScrollFactor('mockup', 0.9, 0.9);
	scaleObject('mockup', 1.2, 1.2);


	addLuaSprite('mockup', false);

	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end