---@diagnostic disable: undefined-global, lowercase-global
-- Script made by RealReal
-- uhhhh I made it before Catbrother so it's mine right?
-- https://www.youtube.com/channel/UCBiEI00nFRfvR8it0z8zmzw


-- These Comment is made for Helping People to understand the code
-- Put this in new Created Folder in mods/ur mod folder/new created folder


-- local singing = 0;

-- Whatify: Sup, I edited this... a lot
-- This script is now modified to support multiple lua characters at once
-- added a CharSprite class that handles each character

-- Ne_Eo: I edited this so its more easier and streamline to add more characters
-- And fixed some bugs


function string.startsWith(String, Start)
	return string.sub(String,1,string.len(Start))==Start
end

local CharSprite = {curAnimName = "",charAsset=""} -- the objects implementation
local lastDadName =''


function CharSprite:new(o)
	
	setmetatable(o, self)
	self.__index = self
	self.curAnimName = o.charAsset .. ".animation.curAnim.name"
	self.specialAnim = 0
	if self.danceIdle == nil then
		self.danceIdle = 0 -- Modify this in the object if you want danceLeft danceRight
	end
	if self.singDuration == nil then
		self.singDuration = 4
	end

	if self.charAsset == "" then
		self.charAsset=o.charAsset
	end
	self.danced = 0
	self.holdTimer = 0
	self.customNoteName = o.customNoteName:lower()
	self.isSinging = false
	--[[
	print("o")
	for i,v in pairs(o) do print(i,v) end
	print("self")
	for i,v in pairs(self) do print(i,v) end
	--]]
	return o
	
end

function CharSprite:setAlpha()
	return setProperty(self.charAsset .. ".alpha", self.alpha or 1)
end

function CharSprite:setupInit(x, y)
	makeAnimatedLuaSprite(self.charAsset, 'characters/'..self.charAsset, x + self.globalOffX, y + self.globalOffY)
	--addLuaScript('custom_notetypes/'.. self.customNoteName);
	for anim, prefix in pairs(self.animNames) do
		addAnimationByPrefix(self.charAsset, anim, prefix, self.fps, false)
	end

	self:setAlpha()
	
	self:playAnim("idle")
	addLuaSprite(self.charAsset, false)
end

function CharSprite:playAnim(animName, force)
	if force == nil then
		force = false
	end
	objectPlayAnimation(self.charAsset, animName, force)

	self.isSinging = animName:startsWith("sing")

	if self.offsetsExist then
		local xOffset = 0
		local yOffset = 0
		if self.offsets[animName] then
			local offsets = self.offsets[animName];
			xOffset = offsets.x
			yOffset = offsets.y
		end

		setProperty(self.charAsset .. '.offset.x', xOffset)
		setProperty(self.charAsset .. '.offset.y', yOffset)
	end
end


function CharSprite:onUpdatePost(elapsed, changeChar) -- Sync Function
	--self:onStepHit(elapsed, curBeat)
	if changeChar then
		self:setAlpha()
	end

	if self.alpha>0.01 and dadName:lower() == self.charAsset:lower()  then
		local x = getProperty(self.charAsset .. ".x")
		local y = getProperty(self.charAsset .. ".y")
		local dadx = getProperty("dad.x");
		local dady = getProperty("dad.y");

		if dadx ~= x then
			setProperty("dad.x",x)
		end

		if dady ~= y then
			setProperty("dad.y",y)
		end
		
		--setProperty(self.charAsset .. ".alpha", 0.00001)
		setProperty("dad.alpha",0.00001)

		objectPlayAnimation(self.charAsset, getProperty("dad.animation.curAnim.name"), true);
   		setProperty(self.charAsset .. ".animation.frameIndex", getProperty("dad.animation.frameIndex"))
	end
end

function CharSprite:dance()
	if self.danceIdle == 0 then
		self:playAnim('idle')
	else
		if self.danced == 1 then
			self:playAnim('danceRight')
			self.danced = 0
		else
			self:playAnim('danceLeft')
			self.danced = 1
		end
	end
end

function CharSprite:onUpdate(elapsed) -- Avoid Playing Idle While Playing Animation
	--local anim = getProperty(self.curAnimName)
	local finished = getProperty(self.charAsset .. ".animation.curAnim.finished")

	--print("onUpdate:" .. self.charAsset)
	if self.specialAnim == 1 and finished then
		--print("dance1:" .. self.charAsset)
		self:dance()
	end

	if self.isSinging then
		self.holdTimer = self.holdTimer + elapsed
	end

	if self.holdTimer >= stepCrochet * 0.001 * self.singDuration then
		self.holdTimer = 0
		--print("dance2:" .. self.charAsset)
		self:dance()
	end
end

function CharSprite:onBeatHit(beat) -- Avoid Playing Idle While Playing Animation
	-- Make Bopping Idle Match the Dad and Boyfriend
	if getProperty(self.curAnimName) == nil then
		return
	end

	-- avoiding Glitchy animation like Kade Engine LMAO
	if not self.isSinging and self.specialAnim == 0 then
		if beat % 2 == 0 then
			self:dance()
		elseif self.danceIdle == 1 then
			self:dance()
		end
	end
end

local singDirs = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}

function CharSprite:opponentNoteHit(id, noteData, noteType, isSustainNote)
	--if noteData == 0 then
	--	objectPlayAnimation(self.charAsset, 'singLEFT',true)
	--elseif noteData == 1 then
	--	objectPlayAnimation(self.charAsset, 'singDOWN',true)
	--elseif noteData == 2 then
	--	objectPlayAnimation(self.charAsset, 'singUP',true)
	--elseif noteData == 3 then
	--	objectPlayAnimation(self.charAsset, 'singRIGHT',true)
	--end
	self:playAnim(singDirs[noteData + 1], true)
end

function CharSprite:playSpecialAnim(animName)
	self:playAnim(animName, true)
	self.specialAnim = 1
end


local function newChar(table1)
	return CharSprite:new(table1)
end

local charkol = newChar({
	charAsset = 'charkol',
	customNoteName = 'charkolNotes',
	customNoteNameAlts = {'teamNotes'},
	animNames = {
		idle='charkol idle',
		singLEFT='charkol left',
		singDOWN='charkol down',
		singUP='charkol up',
		singRIGHT='charkol right'
	},
	offsetsExist=false,
	globalOffX = -160,
	globalOffY = -20,
	offsets = {
		idle={x=0,y=0},
		singLEFT={x=0,y=0},
		singDOWN={x=0,y=0},
		singUP={x=0,y=0},
		singRIGHT={x=0,y=0}
	},
	fps = 12
})

local sugar = newChar({
	charAsset = 'sugar',
	customNoteName = 'sugarNotes',
	customNoteNameAlts = {'teamNotes'},
	animNames = {
		idle='Sugar idle',
		singLEFT='Sugar left',
		singDOWN='Sugar down',
		singUP='Sugar up',
		singRIGHT='Sugar right'
	},
	offsetsExist=false,
	globalOffX = 0,
	globalOffY = 10,
	offsets = {
		idle={x=0,y=0},
		singLEFT={x=0,y=0},
		singDOWN={x=0,y=0},
		singUP={x=0,y=0},
		singRIGHT={x=0,y=0}
	},
	fps = 12
})

local void = newChar({
	charAsset = 'void',
	customNoteName = 'voidNotes',
	customNoteNameAlts = {'teamNotes'},
	animNames = {
		idle='Void idle',
		singLEFT='Void left',
		singDOWN='Void down',
		singUP='Void up',
		singRIGHT='Void right'
	},
	offsetsExist=false,
	globalOffX = -420,
	globalOffY = -360,
	offsets = {
		idle={x=0,y=0},
		singLEFT={x=0,y=0},
		singDOWN={x=0,y=0},
		singUP={x=0,y=0},
		singRIGHT={x=0,y=0}
	},
	fps = 12
})

local whatify = newChar({
	charAsset = 'whatify',
	customNoteName = 'whatifyNotes',
	customNoteNameAlts = {'teamNotes'},
	animNames = {
		idle='whatify idle',
		singLEFT='whatify left',
		singDOWN='whatify down',
		singUP='whatify up',
		singRIGHT='whatify right'
	},
	offsetsExist=false,
	globalOffX = -30,
	globalOffY = 30,
	offsets = {
		idle={x=0,y=0},
		singLEFT={x=0,y=0},
		singDOWN={x=0,y=0},
		singUP={x=0,y=0},
		singRIGHT={x=0,y=0}
	},
	fps = 12
})

local charTable = {charkol,sugar,void,whatify}; -- characterList


function onCreate()
	--addLuaScript('custom_notetypes/your custom note name'); -- Load the Note Type

	-- ADD CUSTOM SPRITES
	
	--Immediate removing the custom sprites from view
	
	--Setting up the state machine
	lastDadName = dadName:lower()
	whatify.alpha = 0.000001;
	void.alpha = 0.000001;
	sugar.alpha = 0.000001;
	charkol.alpha = 0.000001;

	void:setupInit(0 ,430 )
	whatify:setupInit(340 ,470)
	charkol:setupInit(-200,430)
	sugar:setupInit(0, 470)
	


	--whatify:setAlpha(0.2)
	--void:setAlpha(0.2)
	--sugar:setAlpha(0.2)
	--charkol:setAlpha(0.2)

	
	addLuaScript('stages/DevStageFG') 
	--[[ --adding more inputs to setup crashes psych idk why
	--whatify offsets: -30, 30
	whatify:setupInit(430, 380, -30, 30)

	--void offsets: -420,-360
	void:setupInit(0, 340, -420, -360)

	--sugar offsets: 0, 10
	sugar:setupInit(0, 380, 0, 10)


	--charkol offsets: -160, -20
	charkol:setupInit(-200, 340, -160 , -20)
	--]]

	--[[ --Debug Text
	local t = { }
	local y = "";
	for key, value in ipairs(charTable) do
		t[#t+1] = tostring(value:test())
	end
	y = table.concat(t,"\n")

	makeLuaText("tag1", y, 400, 200, 200);
	addLuaText("tag1");
	--]]

	--makeLuaText("tag2", "", 400, 500, 200);
	--addLuaText("tag2");

end

function onEvent(eventName,value1,value2)   
	local charTable2 = {
        "charkol",
        "sugar",
        "void",
        "whatify"
    };
    -- characterList
    if eventName == "Show Dev Character" then
        local charName = charTable2[tonumber(value1)]:lower()
        setProperty(charName .. ".alpha", 1)
    
        local char = nil
        if charName == "whatify" then char = whatify
        elseif charName == "void" then char = void
        elseif charName == "sugar" then char = sugar
        elseif charName == "charkol" then char = charkol
        end

        if char ~= nil then
            char.alpha = 1
        end
    end
end

function onBeatHit()
	for i, char in ipairs(charTable) do
		char:onBeatHit(curBeat)
	end
end

function onUpdate(elapsed)
	for i, char in ipairs(charTable) do
		if(char.alpha>0.1) then
			char:onUpdate(elapsed)
		end
	end
	onUPost(elapsed)
end

local changeChar = false; 
local change = changeChar;

function onUPost(elapsed)
	if curBeat>685 then
		for key, char in ipairs(charTable) do
			if dadName:lower() ~= lastDadName then 
				char:onUpdatePost(elapsed,char.charAsset == lastDadName)
			else
				char:onUpdatePost(elapsed,false)
			end
		end

		lastDadName = dadName:lower()
	end
	--setTextString("tag1",dadName)
end

local function has_value (tab, val) -- bruh why is this not a built-in thing in lua lol
	if(tab==nil) then
		return false
	end

	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end


function opponentNoteHit(id, noteData, noteType, isSustainNote)
	local type = noteType:lower();
	for index, char in ipairs(charTable) do
		if type == char.customNoteName or has_value(char.customNoteNameAlts, noteType) then
			char:opponentNoteHit(id, noteData, noteType, isSustainNote)
		--[[else
			local charName = dadName:lower()
			local char = nil
			
			if charName == "whatify" then char = whatify 
			elseif charName == "void" then char = void 
			elseif charName == "sugar" then char = sugar 
			elseif charName == "charkol" then char = charkol 
			elseif char == nil then return end
			char:opponentNoteHit(id, noteData, noteType, isSustainNote)
		--]]
		end
		
	end
end