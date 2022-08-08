package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	var randomGameover:Int = 1;
	var playingDeathSound:Bool = false;

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.stageCheck;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			default:
				daBf = 'bf';
		}
		if (PlayState.SONG.song.toLowerCase() == 'stress')
		{
			daBf = 'bf-holding-gf-DEAD';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		var exclude = [];

		randomGameover = FlxG.random.int(1, 25, exclude);

		if (FlxG.save.data.cursingShit)
		{
			exclude = [1, 3, 8, 13, 17, 21];
		}
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());

			PlayState.deathCounter = 0;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			// did this to avoid camera locking onto a character w/o the smooth camera tween
			#if html5
			FlxG.camera.follow(camFollow, LOCKON, 0.02);
			#end
			// OldFlag was here
			FlxG.camera.follow(camFollow, LOCKON, 0.02 * (30 / FlxG.save.data.framerateDraw));
		}

		if (PlayState.storyWeek == 7)
		{
			if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && !playingDeathSound)
			{
				playingDeathSound = true;
				bf.startedDeath = true;
				coolStartDeath(0.2);
				FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + randomGameover), 1, false, null, true, function()
				{
					FlxG.sound.music.fadeIn(4, 0.2, 1);
				});
			}
		}
		else if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			bf.startedDeath = true;
			coolStartDeath();
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}

		super.update(elapsed);
	}

	function coolStartDeath(startVol:Float = 1)
	{
		FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), startVol);
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
