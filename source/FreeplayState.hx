package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.tweens.FlxTween;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var speedText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	public static var coolColors:Array<Int> = [0xFF9271FD, 0xFF7C689E, -14535868, 0xFFA8E060, 0xFFFF87FF, 0xFF8EE8FF, 0xFFFF8CCD, 0xFFFF9900];
	private var scoreBG:FlxSprite;
	private	var bg:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	//stolen from psych engine lolol
	var colorTween:FlxTween;
	var intendedColor:Int;

	var actualColor:Null<FlxColor> = null;

	override function create()
	{
					// DONT MIND THIS IS IS PRACTICALLY USELESS RN \\
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var listArray = initSonglist[i].split(":");
			var color = listArray[4];

			if(color != null)
				actualColor = FlxColor.fromString(color);
		}

	/*	for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
		}
	*/
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Tutorial', 'Bopeebo', 'Fresh', 'Dadbattle'], 1, ['gf', 'dad', 'dad', 'dad']); // This is the only option i have tbh

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Spookeez', 'South'], 2, ['spooky']);

		if (StoryMenuState.weekUnlocked[3] || isDebug)
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		if (StoryMenuState.weekUnlocked[4] || isDebug)
			addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);

		if (StoryMenuState.weekUnlocked[5] || isDebug)
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);

		if (StoryMenuState.weekUnlocked[6] || isDebug)
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit']);
		
		if (StoryMenuState.weekUnlocked[7] || isDebug)
			addWeek(['Ugh', 'Guns', 'Stress'], 7, ['tankman']);

		// LOAD MUSIC
		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

			
		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		speedText = new FlxText(FlxG.width, diffText.y + 36, 0, "", 24);
		speedText.font = scoreText.font;

		add(scoreText);
	
		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

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

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;


		var funnyObject:FlxText = scoreText;
	
		if(speedText.width >= scoreText.width && speedText.width >= diffText.width)
			funnyObject = speedText;

		if(diffText.width >= scoreText.width && diffText.width >= speedText.width)
			funnyObject = diffText;
	
		scoreText.text = "PERSONAL BEST:" + lerpScore;
	//	scoreText.x = FlxG.width - scoreText.width;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) 
		{
			if(colorTween != null) 
			{
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, 
			{
				onComplete: function(twn:FlxTween) 
				{
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
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
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}

}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:FlxColor = FlxColor.WHITE;

	public function new(song:String, week:Int, songCharacter:String, ?color:FlxColor)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;

		if(color != null)
			this.color = color;

		else
			{
				if(FreeplayState.coolColors.length - 1 >= this.week)
					this.color = FreeplayState.coolColors[this.week];
				else
					this.color = FreeplayState.coolColors[0];
			}
	}
}