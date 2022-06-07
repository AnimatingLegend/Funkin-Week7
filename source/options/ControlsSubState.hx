package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flash.text.TextField;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSubState;
import flixel.util.FlxSave;
import flixel.input.FlxInput;
import Controls;

using StringTools;

class ControlsSubState extends MusicBeatState
{
	private static var curAlt:Bool = false;
	private var controlOptions:Array<String> = [''];
	private var menuBG:FlxSprite;

	public function new()
	{
		super();

		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        add(menuBG);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed); 
	
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(new OptionsMenuState());
			}
	}	
}
