package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flash.text.TextField;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSubState;
import flixel.util.FlxSave;
import Controls;

using StringTools;

class ControlsSubState extends MusicBeatState
{
	private static var curAlt:Bool = false;

	public var controlOptions:Array<String> = ['NOTES', 'UI'];

	public function new()
	{
		super();
	}
}
