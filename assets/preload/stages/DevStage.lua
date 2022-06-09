function onCreate()

	
	makeLuaSprite('BG_Dev','BG_Dev', -902, -400);  
	setScrollFactor('BG_Dev', 1, 1); 
	scaleObject('BG_Dev', 1.2, 1.2);

	addLuaSprite('BG_Dev', false);

	if(songName:lower()=="teamwork") then 
		addLuaScript('scripts/multichar') 
	else
		addLuaScript('stages/DevStageFG') 
	end

end


function onBeatHit()

	if (curBeat % 2 == 0) 
	then
		objectPlayAnimation('crowd','cheer',true);
	end
end
