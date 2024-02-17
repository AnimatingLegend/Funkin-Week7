package;

import lime.app.Application;
import openfl.text.FontType;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;
import flixel.FlxState;
import flixel.FlxSubState;

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

	public final function getName()
	{
		return _name;
	}

	public function new(catName:String, options:Array<Option>)
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
	private var description:String = "";
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

	public final function getDescription():String
	{
		return description;
	}

	// Returns whether the label is to be updated.
	public function press(changeData:Bool):Bool
	{
		return false;
	}

	private function updateDisplay():String
	{
		return "";
	}

	public function left():Bool
	{
		return false;
	}

	public function right():Bool
	{
		return false;
	}

	public static function setupSaveData()
	{
		if(FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if(FlxG.save.data.middlescroll == null)
			FlxG.save.data.middlescroll = false;

		if(FlxG.save.data.framerateDraw == null)
			FlxG.save.data.framerateDraw = 120;

		if(FlxG.save.data.ghostTapping == null)
			FlxG.save.data.ghostTapping = false;

		if(FlxG.save.data.notesplash == null)
			FlxG.save.data.notesplash = true;

		if(FlxG.save.data.glowStrums == null)
			FlxG.save.data.glowStrums = true;

		if(FlxG.save.data.explicitContent == null)
			FlxG.save.data.explicitContent = true;

		if(FlxG.save.data.camhudZoom == null)
			FlxG.save.data.camhudZoom = true;

		if(FlxG.save.data.weekUnlocked == null)
			FlxG.save.data.weekUnlocked = 8;

		if(FlxG.save.data.fps == null)
			FlxG.save.data.fps = true;
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		if (changeData)
		{
			FlxG.save.data.fps = !FlxG.save.data.fps;
			(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		}

		acceptValues = FlxG.save.data.fps;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS counter ";
	}
}

class FramerateOption extends Option
{
	public function new(desc:String)
	{
		withoutCheckboxes = true;
		boldDisplay = false;
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		withoutCheckboxes = true;
		return true;
	}

	public override function left():Bool
	{
		if (FlxG.drawFramerate > 60)
			FlxG.drawFramerate -= 1 * (FlxG.keys.pressed.SHIFT || FlxG.keys.pressed.CONTROL ? 10 : 1);
		FlxG.save.data.framerateDraw = FlxG.drawFramerate;
		FlxG.updateFramerate = FlxG.drawFramerate;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (FlxG.drawFramerate < 240)
			FlxG.drawFramerate += 1 * (FlxG.keys.pressed.SHIFT || FlxG.keys.pressed.CONTROL ? 10 : 1);
		FlxG.save.data.framerateDraw = FlxG.drawFramerate;
		FlxG.updateFramerate = FlxG.drawFramerate;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Cap " + FlxG.drawFramerate;
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		if (changeData)
			FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		acceptValues = FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "downscroll ";
	}
}

class MiddlescrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		if (changeData)
			FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
		acceptValues = FlxG.save.data.middlescroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "middlescroll ";
	}
}

class NotesplashOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		if (changeData)
			FlxG.save.data.notesplash = !FlxG.save.data.notesplash;
		acceptValues = FlxG.save.data.notesplash;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "notesplashes ";
	}
}

class GhostTappingOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		if (changeData)
			FlxG.save.data.ghostTapping = !FlxG.save.data.ghostTapping;
		acceptValues = FlxG.save.data.ghostTapping;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "ghost tapping ";
	}
}

class NaughtyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		if (changeData)
			FlxG.save.data.explicitContent = !FlxG.save.data.explicitContent;
		acceptValues = FlxG.save.data.explicitContent;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "naughtyness";
	}
}

class CameraZoomOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		if (changeData)
			FlxG.save.data.camhudZoom = !FlxG.save.data.camhudZoom;
		acceptValues = FlxG.save.data.camhudZoom;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "camera zooming on beat";
	}
}

class OpponentLightStrums extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		if (changeData)
			FlxG.save.data.glowStrums = !FlxG.save.data.glowStrums;
		acceptValues = FlxG.save.data.glowStrums;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Opponents light strums ";
	}
}

class LockWeeksOption extends Option
{
	var confirm:Bool = false;

	public function new(desc:String)
	{
		super();
		withoutCheckboxes = true;
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		withoutCheckboxes = true;

		if (!confirm)
		{
			confirm = true;
			display = updateDisplay();
			return true;
		}

		if (changeData)
			FlxG.save.data.weekUnlocked = !FlxG.save.data.weekUnlocked;

		FlxG.save.data.weekUnlocked = 1;
		StoryMenuState.weekUnlocked = [true, true];
		trace('Weeks Locked');

		acceptValues = FlxG.save.data.weekUnlocked;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return confirm ? "Confirm Story Reset" : "Reset Story Progress";
	}
}

class ResetHighscore extends Option
{
	var confirm:Bool = false;

	public function new(desc:String)
	{
		super();
		withoutCheckboxes = true;
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		withoutCheckboxes = true;

		if (!confirm)
		{
			confirm = true;
			display = updateDisplay();
			return true;
		}

		if (changeData)
			FlxG.save.data.resetHighscore = !FlxG.save.data.resetHighscore;

		FlxG.save.data.songScores = null;
		for (key in Highscore.songScores.keys())
		{
			Highscore.songScores[key] = 0;
		}

		FlxG.save.data.songCombos = null;
		trace('Highscores Wiped');

		acceptValues = FlxG.save.data.resetHighscore;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return confirm ? "Confirm Score Reset" : "Reset Score";
	}
}

class ResetSettings extends Option
{
	var confirm:Bool = false;

	public function new(desc:String)
	{
		super();
		withoutCheckboxes = true;
		description = desc;
	}

	public override function press(changeData:Bool):Bool
	{
		withoutCheckboxes = true;

		if (!confirm)
		{
			confirm = true;
			display = updateDisplay();
			return true;
		}

		if (changeData)
			FlxG.save.data.resetSettings = !FlxG.save.data.resetSettings;

		FlxG.save.data.downscroll = null;
		FlxG.save.data.middlescroll = null;
		FlxG.save.data.framerateDraw = null;
		FlxG.save.data.fps = null;
		FlxG.save.data.ghostTapping = null;
		FlxG.save.data.notesplash = null;
		FlxG.save.data.glowStrums = null;
		FlxG.save.data.cursingShit = null;
		FlxG.save.data.camhudZoom = null;
		// FlxG.save.data.weekUnlocked = null;

		Option.setupSaveData();
		trace('All settings have been reset');

		acceptValues = FlxG.save.data.resetSettings;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return confirm ? "Confirm Settings Reset" : "Reset Settings";
	}
}
