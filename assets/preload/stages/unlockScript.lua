local hudSetting = false


function onDestroy()
	if hudSetting == false then
		setPropertyFromClass('ClientPrefs', 'hideHud', false);
	elseif hudSetting == true then
		hudSetting = false;
	end
end

local allowMake = true;

local checkNo = 1;

local playCutsceneBool = true;
		
local allowEndShit = false

local teamworkCheck = '';

function badCheckUnlock() 
	--fullCheckUnlocked
	playCutsceneBool = true
	--teamworkCheck = ''
	return songName
end

function onEndSong()
	if not allowEndShit then
		
		if allowMake then
			allowMake =false;
			--startDialogue('stages/cutsceneLackluster', 'breakfast'); 
			makeLuaSprite("HideScr1",'',-screenWidth/2,-screenHeight/2)
			makeGraphic("HideScr1",2,2, '211222') --'000000')
			scaleObject("HideScr1",screenWidth*2, screenHeight*2);
			addLuaSprite("HideScr1",true)
		end

		playCutsceneBool = false
	
		if checkNo == 1 then
			teamworkCheck= badCheckUnlock('Teamwork-Check','Rusty|Groovy|Slick|Monotonous|Harmony|Hype|Salutations|Bipolarity|Abstract-Obstruction|Sugary-Sweet|What|Charred|Blaster')
			
			-- Plays only once all the unlocked songs are cleared, in any order
			playCutsceneBool = (teamworkCheck == songName) -- or (teamworkCheck == '')
			if playCutsceneBool then startDialogue("stages/cutsceneTeamwork", '', '0xFF000000')  
			else
				checkNo = 60;
			end
			return Function_Stop;
		end

		if checkNo == 2 then
			badCheckUnlock()
			-- Plays only on the first clear of Teamwork
			playCutsceneBool = (teamworkCheck == '') and badCheckUnlock('Lackluster-Check','Teamwork') == songName
			checkNo = checkNo + 1;
			if playCutsceneBool then startDialogue("stages/cutsceneLackluster", '', '0xFF000000') 
			else
				checkNo = 60;
			end
			return Function_Stop;
		end

		if checkNo == 3 then
			-- Plays only on the first clear of Lackluster
			playCutsceneBool = (teamworkCheck == '') and badCheckUnlock('Missing-Check','Lackluster') == songName
			checkNo = checkNo + 1;
			if playCutsceneBool then startDialogue("stages/cutsceneMissing", '', '0xFF000000')  
			else
				checkNo = 60;
			end
			return Function_Stop;
		end

		if checkNo == 4 then
			-- Plays only on the first clear of Missing
			playCutsceneBool = (teamworkCheck == '') and badCheckUnlock('Wackluster-Check','Missing') == songName
			checkNo = checkNo + 1;
			if playCutsceneBool then startDialogue("stages/cutsceneWackluster", '', '0xFF000000')  
			else
				checkNo = 60;
			end
			return Function_Stop;
		end

		if checkNo > 4 then 
			allowEndShit = true;
		end

		

		
		


	end
	return Function_Continue;
end

--[[
function onEndSong()

	if getPropertyFromClass('ClientPrefs', 'hideHud') == true then
		hudSetting = true;
	elseif getPropertyFromClass('ClientPrefs', 'hideHud') == false then
		setPropertyFromClass('ClientPrefs', 'hideHud', true);
	end
	
	-- Block the first song end and start a timer of 0.8 seconds to play the dialogue
	if checkNo == 2 then -- 1 then
		makeLuaSprite("HideScr1",'',-screenWidth/2,-screenHeight/2)
		makeGraphic("HideScr1",2,2, '211222') --'000000')
		scaleObject("HideScr1",screenWidth*2, screenHeight*2);
		addLuaSprite("HideScr1",true)
	end 

	if checkNo >= 4 or not playCutsceneBool then
		allowCountdown = true;
		endSong()
		return Function_Continue;
	end

	if not allowCountdown and playCutsceneBool then
		setProperty('inCutscene', true);
		startDialogueLoop();
		
		return Function_Stop;
	end


	removeLuaSprite("HideScr1",true)
	return Function_Continue;
end
--]]




function startDialogueLoop(tag, loops, loopsLeft)
		
end

-- Dialogue (When a dialogue is finished, it calls startCountdown again)
function onNextDialogue(count)
	
	
	-- triggered when the next dialogue line starts, 'line' starts with 1
end

function onSkipDialogue(count)
	
	-- triggered when you press Enter and skip a dialogue line that was still being typed, dialogue line starts with 1
end