function onCreate()
	
	makeLuaSprite('AbstractBG05','AbstractBG05', -902, -400); 
	setLuaSpriteScrollFactor('AbstractBG05', 0.126, 0.126); 
	scaleObject('AbstractBG05', 1.0, 1.0);
	
	makeLuaSprite(
	'AbstractBG01','AbstractBG01',-902, -400);  
	setLuaSpriteScrollFactor('AbstractBG01', 1.0, 1.0); 
	scaleObject('AbstractBG01', 1.0, 1.0);
	



	-- sprites that only load if Low Quality is turned off

	if not lowQuality then

		makeLuaSprite('FG00', 'FG00', -902, -400);
		setLuaSpriteScrollFactor('FG00', 1.5, 1.0);
		scaleObject('FG00', 1.0, 1.0);

		makeLuaSprite('AbstractBG02','AbstractBG02',-902, -400);  
		setLuaSpriteScrollFactor('AbstractBG02', 0.504, 0.504); 
		scaleObject('AbstractBG02', 1.0, 1.0);

		makeLuaSprite('AbstractBG03','AbstractBG03',-902, -400);  
		setLuaSpriteScrollFactor('AbstractBG03', 0.378, 0.378); 
		scaleObject('AbstractBG03', 1.0, 1.0);

		makeLuaSprite('AbstractBG04','AbstractBG04',-902, -400);  
		setLuaSpriteScrollFactor('AbstractBG04', 0.252, 0.252); 
		scaleObject('AbstractBG04', 1.0, 1.0);
	end

	addLuaSprite('AbstractBG05', false);
	if not lowQuality then
		addLuaSprite('AbstractBG04', false);
		addLuaSprite('AbstractBG03', false);
		addLuaSprite('AbstractBG02', false);
	end 

	addLuaSprite('AbstractBG01', false);
	if not lowQuality then
		addLuaSprite('FG00', true);
	end
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end