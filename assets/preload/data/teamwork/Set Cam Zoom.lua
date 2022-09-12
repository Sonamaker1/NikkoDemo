local iter = 0;
local prevTween;
function onEvent(name,value1,value2)

    if name == "Set Cam Zoom" then
        
        if value2 == '' then
      	  setProperty("defaultCamZoom",value1)
	debugPrint(value2 )
	else
            doTweenZoom('camz','camGame',tonumber(value1),tonumber(value2),'sineInOut')
	end
            
    end

    if not lowQuality and name == "Set Cam Zoom" and songName:lower()=="teamwork" then
        if value2 == '' then
			local y = tonumber(value1);
			if(y > 1) then
				local w = math.max(1-y,0.01);
				if(math.abs(w-getProperty("crowd.alpha"))<0.3) then
					--crash prevention, spamming this should cause a "jump" instead of a crash or flickering 
					setProperty("crowd.alpha",w)
				else
					if prevTween ~= nil then cancelTween(prevTween) end
					prevTween = 'crowdTWN_0000'..tostring(iter)
					doTweenAlpha('crowdTWN_0000'..tostring(iter),'crowd',w,1,'sineInOut')
					iter = iter + 1
				end
			else
				if prevTween ~= nil then cancelTween(prevTween) end
				prevTween = 'crowdTWN_0000'..tostring(iter)
				doTweenAlpha(prevTween, 'crowd', 1,1,'sineInOut')
				iter = iter + 1 
			end
			
		end
    end
end

function onTweenCompleted(name)

if name == 'camz' then


      	 setProperty("defaultCamZoom",getProperty('camGame.zoom')) 

end


end