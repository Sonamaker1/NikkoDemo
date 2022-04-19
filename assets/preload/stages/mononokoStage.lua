function onCreate()
	
	makeLuaSprite('MonoBG05','MNN_bg05',-450, -400);  
	setLuaSpriteScrollFactor('MonoBG05', 0.126, 0.126); 
	scaleObject('MonoBG05', 1.0, 1.0);
	
	makeLuaSprite('MonoBG00','MNN_bg00', -450, -400);  
	setLuaSpriteScrollFactor('MonoBG00', 1.0, 1.0); 
	scaleObject('MonoBG00', 1.0, 1.0);

	makeLuaSprite('MonoBG02','MNN_bg02',-450, -400);  
	setLuaSpriteScrollFactor('MonoBG02', 0.554, 0.554); 
	scaleObject('MonoBG02', 1.0, 1.0);

	-- sprites that only load if Low Quality is turned off
	
	if not lowQuality then


		makeLuaSprite('MonoFG01','MNN_fg01', -427.5, -400); 
		setLuaSpriteScrollFactor('MonoFG01', 1.05, 1.05);	
		scaleObject('MonoFG01', 1.0, 1.0);
	
		makeLuaSprite('MonoFG00','MNN_fg00', -540, -400); 
		setLuaSpriteScrollFactor('MonoFG00', 1.3, 1.3);	
		scaleObject('MonoFG00', 1.1, 1.1);

		makeLuaSprite('MonoBG04','MNN_bg04',-450, -200);  
		setLuaSpriteScrollFactor('MonoBG04', 0.338, 0.338); 
		scaleObject('MonoBG04', 1.0, 1.0);

		makeLuaSprite('MonoBG03','MNN_bg03',-450, -300);  
		setLuaSpriteScrollFactor('MonoBG03', 0.478, 0.378); 
		scaleObject('MonoBG03', 1.0, 1.0);

		makeLuaSprite('MonoBG01','MNN_bg01',-450, -400);  
		setLuaSpriteScrollFactor('MonoBG01', 0.704, 0.704); 
		scaleObject('MonoBG01', 1.0, 1.0);


	end

	addLuaSprite('MonoBG05', false);
	
	if not lowQuality then
		addLuaSprite('MonoBG04', false);
		addLuaSprite('MonoBG03', false);
	end
	
	addLuaSprite('MonoBG02', false);
	
	if not lowQuality then
		addLuaSprite('MonoBG01', false);
	end
	
	addLuaSprite('MonoBG00', false);
	
	if not lowQuality then
		addLuaSprite('MonoFG01', true);
		addLuaSprite('MonoFG00', true);
	end

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end