package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var bg2:FlxSprite;
	var bg3:FlxSprite;
	var bg4:FlxSprite;

	var intendedColor:Int;
	var colorTween:FlxTween;
	var colorTween2:FlxTween;
	var colorTween3:FlxTween;
	var colorTween4:FlxTween;
	private static var thisIsSoDumbJustWorkPlease:Bool = false;

	override function create()
	{
		thisIsSoDumbJustWorkPlease = false;
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];
			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				// trace( song[3]!=null );
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}

				if(song[3]!=null){
					addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), song[3]);
				}
				else{
					addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), []);
				}
			}
		}
		WeekData.setDirectoryFromWeek();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		bg = new FlxSprite().loadGraphic(Paths.image('menuAlbums'));
		bg2 = new FlxSprite().loadGraphic(Paths.image('menuAlbums'));
		bg3 = new FlxSprite().loadGraphic(Paths.image('menuAlbums'));
		bg4 = new FlxSprite().loadGraphic(Paths.image('menuAlbums'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		bg3.antialiasing = ClientPrefs.globalAntialiasing;
		bg4.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		add(bg2);
		add(bg3);
		add(bg4);
		
		bg.scale.x = bg.scale.y = 1;
		bg2.scale.x = bg.scale.y = 1;
		bg3.scale.x = bg.scale.y = 1;
		bg4.scale.x = bg.scale.y = 1;
		bg.screenCenter();
		bg2.screenCenter();
		bg3.screenCenter();
		bg4.screenCenter();
		bg.x = -bg.width;
		bg.y = -bg.height;
		
		bg2.x = -bg.width;
		bg2.y = 0;
		
		bg3.x = 0;
		bg3.y = -bg.height;
		
		bg4.x = 0;
		bg4.y = 0;

		FlxTween.tween(bg, {x: bg.width*0/2, y:bg.height*0/2},  32,  { type: FlxTween.LOOPING});
		FlxTween.tween(bg2, {x: bg.width*0/2, y:bg.height*2/2}, 32,  { type: FlxTween.LOOPING});
		FlxTween.tween(bg3, {x: bg.width*2/2, y:bg.height*0/2}, 32,  { type: FlxTween.LOOPING});
		FlxTween.tween(bg4, {x: bg.width*2/2, y:bg.height*2/2}, 32,  { type: FlxTween.LOOPING});
		

		var menuRight:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menu02'));
		menuRight.alpha = 0.8;
		menuRight.scrollFactor.set();
		menuRight.setGraphicSize(Std.int(FlxG.width));
		menuRight.updateHitbox();
		menuRight.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuRight);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		
		for (i in 0...songs.length)
		{

			
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			var lockState = 0;
			if(songs[i].prereqCompletions.length>0){
				lockState = 1;
			}
			
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.forceX = FlxG.width - 450 - 310 - songText.targetY * 70;
			grpSongs.add(songText);

			Paths.currentModDirectory = songs[i].folder;
			
			

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter, false, lockState);
			
			icon.sprTracker = songText;
			icon.alignTrack = -140;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
			if(icon.lockIcon != null){
				add(icon.lockIcon);
			}
			
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		bg2.color = songs[curSelected].color;
		bg3.color = songs[curSelected].color;
		bg4.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 16;
		#else
		var leText:String = "Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false, false);
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, prereqCompletions:Array<String>)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color, prereqCompletions));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	
	override function update(elapsed:Float)
	{
		if(!thisIsSoDumbJustWorkPlease){
			for (i in 0...songs.length)
			{
				var lockState = -1;
				
				if(songs[i].prereqCompletions.length>0){
					lockState = 1;
					var allCleared:Bool = true;
					for(prereq in 0...songs[i].prereqCompletions.length)
					{
						//var boolExists = Highscore.scoreExists(songs[i].prereqCompletions[prereq],0);
						var scoreP:Int = Highscore.getScore(songs[i].prereqCompletions[prereq],0);
						var songP:String = songs[i].prereqCompletions[prereq];
						
						//trace("Song:" + songP + "\tScore:" + scoreP); //+ "\tExists:" + boolExists );
						allCleared = allCleared && (scoreP>0);
					}
					if(allCleared) lockState = 2;
				}
				if( lockState>0 && iconArray[i].lockIcon!=null){
					iconArray[i].lockIcon.animation.curAnim.curFrame = lockState-1;
				}
			}
			thisIsSoDumbJustWorkPlease = true;
		}
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (upP)
		{
			changeSelection(-shiftMult,true,false);
		}
		if (downP)
		{
			changeSelection(shiftMult,true,false);
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
				colorTween2.cancel();
				colorTween3.cancel();
				colorTween4.cancel();
			}
			
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)  
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = false;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}

		else if (accepted)
		{
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);
			
			//Yeah I know its a stupid way to check its locked but like its only for three songs lol 
			var locked:Bool = false;
			if(iconArray[curSelected].lockIcon != null){
				locked = iconArray[curSelected].lockIcon.animation.curAnim.curFrame == 0;
			}
			
			if(locked){
				FlxTween.color(iconArray[curSelected].lockIcon, 1, FlxColor.RED, FlxColor.WHITE, {
					onComplete: function(twn:FlxTween) {
						colorTween = null;
					}
				});

				FlxTween.color(iconArray[curSelected].sprTracker, 1, FlxColor.RED, FlxColor.WHITE, {
					onComplete: function(twn:FlxTween) {
						colorTween = null;
					}
				});

				
				trace("locked");
			}
			else{
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				
				
				

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if(colorTween != null) {
					colorTween.cancel();
					colorTween2.cancel();
					colorTween3.cancel();
					colorTween4.cancel();
				}
				
				if (FlxG.keys.pressed.SHIFT){
					LoadingState.loadAndSwitchState(new ChartingState());
				}else{
					LoadingState.loadAndSwitchState(new PlayState());
				}

				FlxG.sound.music.volume = 0;
						
				destroyFreeplayVocals();
			}
		}
		else if(controls.RESET)
		{
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true, initialState:Bool = true)
	{
		var calculatedChange:Int = curSelected;
		
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
				colorTween2.cancel();
				colorTween3.cancel();
				colorTween4.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
			colorTween2 = FlxTween.color(bg2, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween2 = null;
				}
			});
			colorTween3 = FlxTween.color(bg3, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween3 = null;
				}
			});
			colorTween4 = FlxTween.color(bg4, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween4 = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			//CHANGE THIS LATER!!!
			var moreBS:Float = FlxG.width - 450 - 70 - 310 - item.targetY * 70;
			
			if(initialState){
				item.forceX = moreBS;
			}
			else{
				item.forceX = Math.NEGATIVE_INFINITY;
			}
			item.targetX = moreBS;

			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var prereqCompletions:Array<String>  = [];

	public function new(song:String, week:Int, songCharacter:String, color:Int, prereqCompletions:Array<String>)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(prereqCompletions != null) this.prereqCompletions = prereqCompletions;
		if(this.folder == null) this.folder = '';
	}
}