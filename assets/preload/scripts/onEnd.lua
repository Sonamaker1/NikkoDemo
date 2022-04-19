local notSeen = true;
luaDebugMode = true;

function onEndSong()
    debugPrint("playing cutscene")
    
    if notSeen then
        runTimer('endTime', 0.8);
        return Function_Stop;
    end

    return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'endTime' then -- Timer completed, play dialogue
		endTime()
	end
end

function makeHideScr()
    addLuaSprite("HideScr1",true)
    makeGraphic("HideScr1",2,2, '211222') --'000000')
    scaleObject("HideScr1",screenWidth*2, screenHeight*2);
end 


function endTime()
    makeLuaSprite("HideScr1",'',-screenWidth/2,-screenHeight/2)
    makeGraphic("HideScr1",2,2, '777777') --'000000')
    scaleObject("HideScr1",screenWidth*2, screenHeight*2);
    setProperty('healthBarBG.alpha', 0.00001);
    setProperty('healthBar.alpha', 0.00001);
    setProperty('iconP1.alpha'  , 0.00001);
    setProperty('iconP2.alpha' , 0.00001);
    setProperty('scoreTxt.alpha', 0.00001);
    setProperty('rating.alpha'  , 0.00001);
    setProperty('comboSpr.alpha', 0.00001);
    setProperty('numScore.alpha', 0.00001);
    
    notSeen = false;
    
    for i=0,4,1 do
        setPropertyFromGroup('opponentStrums', i, 'x', -2000)
        setPropertyFromGroup('playerStrums', i, 'x', -2000)
    end
    
    local teamworkCheck= fullCheckUnlocked('Teamwork-Check','Rusty|Groovy|Slick|Monotonous|Harmony|Hype|Salutations|Bipolarity|Abstract-Obstruction|Sugary-Sweet|What|Charred|Blaster')
    local practiced = botPlay or getPropertyFromClass('PlayState','instance.practiceMode'); 
    if not practiced then      
        --debugPrint(teamworkCheck)  
        if teamworkCheck == songName then 
            addLuaSprite("HideScr1",true)
            startDialogue('stages/cutsceneTeamwork', 'Teamwork-noLoop','ebbfeb'); 
            return Function_Stop;
        elseif teamworkCheck == '' then
            local tempBool = fullCheckUnlocked('Lackluster-Check','Missing|Lackluster|Teamwork'); -- gotta flip it and reverse it apparently
            if tempBool == songName then
                if songName =='Teamwork' then
                    makeHideScr()
                    startDialogue('stages/cutsceneLackluster', 'Lackluster-noLoop','000000'); 
                elseif songName =='Lackluster' then
                    makeHideScr()
                    startDialogue('stages/cutsceneMissing', 'Missing-noLoop','000000'); 
                elseif songName =='Missing' then
                    makeHideScr()
                    startDialogue('stages/cutsceneWackluster', 'WackBecomesCanny-noLoop','000000'); 
                else
                    endSong() --  if this one is ever called, reality has collapsed
                end
            else
                endSong() -- maybe next time, but this is not the song
            end
        else
            endSong() -- still some stuff to unlock but you can do it
        end
    else
        endSong() --no rewards for bots or practice sorry lol
    end
end