package;	
import Controls.Control;	
import flixel.FlxG;	
import flixel.FlxSprite;	
import flixel.FlxSubState;	
import flixel.addons.transition.FlxTransitionableState;	
import flixel.group.FlxGroup.FlxTypedGroup;	
import flixel.input.keyboard.FlxKey;	
import flixel.system.FlxSound;	
import flixel.text.FlxText;	
import flixel.tweens.FlxEase;	
import flixel.tweens.FlxTween;	
import flixel.util.FlxColor;	
import flixel.FlxCamera;	
import flixel.util.FlxStringUtil;	
class PauseSubState extends MusicBeatSubstate	
{	
	var grpMenuShit:FlxTypedGroup<Alphabet>;	
	var menuItems:Array<String> = [];	
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'About', 'Change Difficulty', 'Exit to menu'];	
	var difficultyChoices = [];	
	var curSelected:Int = 0;	
	var maes4thWallBreak:HealthIcon;	
	var pauseMusic:FlxSound;	
	var practiceText:FlxText;
	var skipTimeText:FlxText;	
	var skipTimeTracker:Alphabet;	
	var curTime:Float = Math.max(0, Conductor.songPosition);

	var loreLmaoHeading:FlxText;
	var loreLmao:FlxText;

	var loreHeadingStr:String;
	var loreStr:String;

	var bg0:FlxSprite;
	var alphaTween:FlxTween;
	//var botplayText:FlxText;

	public static var transCamera:FlxCamera;

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();
		
		var lore:String = "";
		if (PlayState.SONG.lore != null){
			lore = PlayState.SONG.lore;
		}
		if (PlayState.SONG.loreHeading != null){
			loreHeadingStr = PlayState.SONG.loreHeading;
		}
		
		if(CoolUtil.difficulties.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!
		if(lore.length < 2) menuItemsOG.remove('About'); //No more blank lore screens
		 
		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(3, 'Leave Charting Mode');	
				
			var num:Int = 0;	
			if(!PlayState.instance.startingSong)	
			{	
				num = 1;	
				menuItemsOG.insert(4, 'Skip Time');	
			}	
			menuItemsOG.insert(4 + num, 'End Song');	
			menuItemsOG.insert(5 + num, 'Practice Mode');	
			menuItemsOG.insert(6 + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('coffeeAndNothingElse'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		//loreLmao = 

		bg0 = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, 0xFF222222);
		bg0.alpha = 0; 
		bg0.scrollFactor.set();
		bg0.setGraphicSize(Std.int(FlxG.width));
		add(bg0);

		var extraX:Int = (menuItemsOG.length>5?1000:450);
		
		var bg:FlxSprite = new FlxSprite((1000-extraX)/2, 0).loadGraphic(Paths.image('menu02'));
		bg.alpha = 0;
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(FlxG.width));
		//bg.flipX  = true;
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		/**.loadGraphic(Paths.image('CoverInfo_3'));
		var bg:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);
		**/
		loreHeadingStr = "Game Paused";

		var lore:String = "";
		if (PlayState.SONG.lore != null){
			lore = PlayState.SONG.lore;
		}
		if (PlayState.SONG.loreHeading != null){
			loreHeadingStr = PlayState.SONG.loreHeading;
		}
		
		loreLmaoHeading = new FlxText(20, FlxG.height - 580 , 0, "", 32);
		loreLmaoHeading.text += loreHeadingStr;
		loreLmaoHeading.scrollFactor.set();
		loreLmaoHeading.setFormat(Paths.font("play.ttf"), 50, FlxColor.WHITE);
		loreLmaoHeading.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
		loreLmaoHeading.updateHitbox();
		add(loreLmaoHeading);

		
		//StringTools.replace("$song")
		loreLmao = new FlxText(20, FlxG.height - 500 , 0, "", 32);
		loreLmao.text += lore;
		loreLmao.scrollFactor.set();
		loreLmao.setFormat(Paths.font("play.ttf"), 32, FlxColor.WHITE);
		loreLmao.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK, 1.5);
		loreLmao.updateHitbox();
		add(loreLmao);

		loreLmaoHeading.visible = false;
		loreLmao.visible = false;

		var levelInfo:FlxText = new FlxText(20, FlxG.height - 15 - 96, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 30);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, FlxG.height - 15 - 64, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 30);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, FlxG.height - 15 - 32 , 0, "", 32);
		blueballedTxt.text = "Blueballed: " + PlayState.deathCounter;
		
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 30);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		var lowerSong = PlayState.SONG.song.toLowerCase();
		
		if(lowerSong == "salutations" || lowerSong == "abstract-obstruction" || lowerSong == "bipolarity"){
			maes4thWallBreak = new HealthIcon(PlayState.instance.dad.healthIcon, false);
			maes4thWallBreak.x = 50;
			maes4thWallBreak.y = FlxG.height - 450;
			maes4thWallBreak.alpha = 0;
			add(maes4thWallBreak);
		}

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		loreLmaoHeading.alpha = 0;
		loreLmao.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);
		
		FlxTween.tween(bg0, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: levelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		
		//FlxTween.tween(loreLmaoHeading, {alpha: 1, y: loreLmaoHeading.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		//FlxTween.tween(loreLmao, {alpha: 1, y: loreLmao.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		
		

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		
		add(grpMenuShit);

		regenMenu();
		

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];	
	}	
	var holdTime:Float = 0;	
	override function update(elapsed:Float)	
	{	
		if (pauseMusic.volume < 0.5)	
			pauseMusic.volume += 0.01 * elapsed;	
		super.update(elapsed);	
		updateSkipTextStuff();	
		var upP = controls.UI_UP_P;	
		var downP = controls.UI_DOWN_P;	
		var accepted = controls.ACCEPT;	
		if (upP)	
		{	
			changeSelection(-1);	
		}	
		if (downP)	
		{	
			changeSelection(1);	
		}
		var daSelected:String = menuItems[curSelected];	
		switch (daSelected)	
		{	
			case 'Skip Time':	
				if (controls.UI_LEFT_P)	
				{	
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);	
					curTime -= 1000;	
					holdTime = 0;	
				}	
				if (controls.UI_RIGHT_P)	
				{	
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);	
					curTime += 1000;	
					holdTime = 0;	
				}	
				if(controls.UI_LEFT || controls.UI_RIGHT)	
				{	
					holdTime += elapsed;	
					if(holdTime > 0.5)	
					{	
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);	
					}	
					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;	
					else if(curTime < 0) curTime += FlxG.sound.music.length;	
					updateSkipTimeText();	
				}	
		}	

		if (accepted)
		{
			if (menuItems == difficultyChoices)	
			{	
				if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {	
					var name:String = PlayState.SONG.song;	
					var poop = Highscore.formatSong(name, curSelected);	
					PlayState.SONG = Song.loadFromJson(poop, name);	
					PlayState.storyDifficulty = curSelected;	
					MusicBeatState.resetState();	
					FlxG.sound.music.volume = 0;	
					PlayState.changedDifficulty = true;	
					PlayState.chartingMode = false;	
					return;	
				}	
				menuItems = menuItemsOG;	
				regenMenu();
			}

			switch (daSelected)
			{
				case "Resume":
					close();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				case 'Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case 'About':		
					if(alphaTween != null){}
					else{
						var lowerSong = PlayState.SONG.song.toLowerCase();
						var maesTalk:Bool = lowerSong == "tutorial-ft.-maes" || lowerSong == "salutations" || lowerSong == "abstract-obstruction" || lowerSong == "bipolarity";
						if(loreLmao.alpha == 0){
							if(maesTalk)
							{
								maes4thWallBreak.alpha = 0;
								FlxTween.tween(maes4thWallBreak, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
							}
							loreLmaoHeading.alpha = 0;
							loreLmao.alpha = 0;
							bg0.alpha = 0;
							loreLmaoHeading.visible=true;
							loreLmao.visible=true;
							alphaTween = FlxTween.tween(loreLmaoHeading, {alpha: 1, y: loreLmaoHeading.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3,
								onComplete: function(twn:FlxTween) {
									alphaTween = null;
								}
							});
							
							FlxTween.tween(loreLmao, {alpha: 1, y: loreLmao.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
							FlxTween.tween(bg0, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
						}
						else {
							if(maesTalk)
							{
								maes4thWallBreak.alpha = 0.9;
								FlxTween.tween(maes4thWallBreak, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
							}
							loreLmaoHeading.alpha = 0.9;
							loreLmao.alpha = 0.9;
							bg0.alpha = 0.6;
							
							alphaTween = FlxTween.tween(loreLmaoHeading, {alpha: 0, y: loreLmaoHeading.y - 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3,
								onComplete: function(twn:FlxTween) {
									alphaTween = null;
									loreLmaoHeading.visible=false;
									loreLmao.visible=false;
								}
							});
							FlxTween.tween(loreLmao, {alpha: 0, y: loreLmao.y - 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
							FlxTween.tween(bg0, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
							
						}
					}
				case "Restart Song":	
					restartSong();	
				case "Leave Charting Mode":	
					restartSong();	
					PlayState.chartingMode = false;	
				case 'Skip Time':
					if(curTime < Conductor.songPosition)
					{
						PlayState.startOnTime = curTime;
						restartSong(true);
					}
					else
					{
						if (curTime != Conductor.songPosition)
						{
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case "End Song":
					close();
					PlayState.instance.finishSong(true);
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case "Exit to menu":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					FlxG.sound.playMusic(Paths.music('funkyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
				case 'BACK':
					menuItems = menuItemsOG;
					regenMenu();
			}
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		var calculatedChange:Int = curSelected;
		
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		calculatedChange -= curSelected;

		var bullShit:Int = 0;
		var extraX:Int = (menuItems.length>5?(1000-170):450);
		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			//CHANGE THIS LATER!!!

			var moreBS:Float = FlxG.width - extraX - 70 - item.targetY * 70;
			
			item.forceX = Math.NEGATIVE_INFINITY;
			item.targetX = moreBS;

			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				// item.forceX = moreBS-70;
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
				if(item == skipTimeTracker)	
				{	
					curTime = Math.max(0, Conductor.songPosition);	
					updateSkipTimeText();	
				}
			}
		}
	}

	
	/**
	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
		}
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
	}
	**/

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}	
			
		var extraX:Int = (menuItems.length>5?1000:450);
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			item.forceX = FlxG.width - extraX - item.targetY * 70;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}
