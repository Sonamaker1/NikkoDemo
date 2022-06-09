function onEvent(name,value1)
    if name == "Visibility Opponent Group" then
	doTweenAlpha("OpponentGroupTWN", "dad", 0.000001, 0.1)
	
	--[[
	if tonumber(value1) == 0 then
	    local y = getProperty('dadGroup.length');
	    for i = 0,y-1,1  do
		setPropertyFromGroup('dadGroup', i,"visible", true);
	    end
	else
	    
	    triggerEvent('Camera Follow Pos','',500)
	end
	--]]
    end
end