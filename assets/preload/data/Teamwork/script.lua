function onCreate()
	setProperty('gfGroup.visible', false);
	--setProperty('dadGroup.visible', false);
	setPropertyFromClass('GameOverSubstate', 'characterName', 'nikkoplayer'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'loss_sfx'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --put in mods/music/
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/
end

function onBeatHit()
	if (curBeat==192) then
		health=getProperty('health');
		if getProperty('health') > 1 then


      			setProperty('health', 1);
    		end
	end
	if (curBeat==384) then
		health=getProperty('health');
		if getProperty('health') > 1 then


      			setProperty('health', 1);
    		end
	end
	if (curBeat==528) then
		health=getProperty('health');
		if getProperty('health') > 1 then


      			setProperty('health', 1);
    		end
	end
end
