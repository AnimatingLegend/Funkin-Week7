package;

import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
#if windows
import sys.io.Process;
#end
import flixel.math.FlxMath;
using StringTools;

class OptionCatagory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Catagory";
	
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var display:String;
	private var acceptValues:Bool = false;
	public var withoutCheckboxes:Bool = false;
	public var boldDisplay:Bool = true;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}
	
	// Returns whether the label is to be updated.
	public function press(changeData:Bool):Bool { return false; }
	private function updateDisplay():String { return ""; }
	public function left():Bool { return false; }
	public function right():Bool { return false; }
}

class FPSOption extends Option
{
	public function new()
	{
		super();
	}

	public override function press(changeData:Bool):Bool
	{
		if(changeData)
		{
			FlxG.save.data.fps = !FlxG.save.data.fps;
			(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		}
			
		acceptValues = FlxG.save.data.fps;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter ";
	}
}

class FullscreenOption extends Option
{
	public function new()
	{
		super();
	}

	public override function press(changeData:Bool):Bool
	{
		if(changeData)
			FlxG.save.data.fullscreen = !FlxG.save.data.fullscreen;
		acceptValues = FlxG.save.data.fullscreen;
		FlxG.fullscreen = FlxG.save.data.fullscreen;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Fullscreen ";
	}

}

class DownscrollOption extends Option
{
	public function new()
	{
		super();
	}

	public override function press(changeData:Bool):Bool
	{
		if(changeData)
			FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		acceptValues = FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Downscroll ";
	}
}

class NotesplashOption extends Option
{
	public function new()
	{
		super();
	}

	public override function press(changeData:Bool):Bool
	{
		if(changeData)
			FlxG.save.data.notesplash = !FlxG.save.data.notesplash;
		acceptValues = FlxG.save.data.notesplash;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Splashes ";
	}
}

class GhostTappingOption extends Option
{
	public function new()
	{
		super();
	}

	public override function press(changeData:Bool):Bool
	{
		if(changeData)
			FlxG.save.data.ghostTapping = !FlxG.save.data.ghostTapping;
		acceptValues = FlxG.save.data.ghostTapping;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping ";
	}
}