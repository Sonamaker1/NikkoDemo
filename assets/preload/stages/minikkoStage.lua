function onCreate()
	
	makeLuaSprite(
	'L00','Lost_BG00', -450, -400
	);  
	setLuaSpriteScrollFactor(
	'L00', 0, 0
	); 
	scaleObject(
	'L00', 1.0, 1.0
	);

	makeLuaSprite(
	'floor', 'Lost_floor', -427.5, -400
	); 
	setLuaSpriteScrollFactor(
	'floor', 1.0, 0.6
	);	
	scaleObject(
	'floor', 1.0, 1.0
	);

	--I will keep this indentation for no reason mwhahaha
		

	addLuaSprite('L00', false);
	addLuaSprite('floor', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end