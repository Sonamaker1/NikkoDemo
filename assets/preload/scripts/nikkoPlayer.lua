
function onCreate()
	if(boyfriendName=="nikkoplayer") then
		setProperty('gfGroup.visible', false);
		setPropertyFromClass('GameOverSubstate', 'characterName', 'nikkoplayer'); --Character json file for the death animation
		setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'loss_sfx'); --put in mods/sounds/
		setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --put in mods/music/
		setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/
	end
end
