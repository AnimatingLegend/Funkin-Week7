package ui;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.FlxG;
import flixel.math.FlxMath;
import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.util.FlxColor;

class FPSCounter extends TextField
{
	private var memMax:Float = 0;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;
	
	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000) 
	{
		super();

		this.x = x;
		this.y = y;

		selectable = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);

		autoSize = LEFT;
		multiline = true;
		mouseEnabled = false;

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{	
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000) {
			times.shift();
		}

		var currentCount = times.length;

		var mem:Float = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 2));
		if (mem > memMax) 
			memMax = mem;

		var memInfo = (FlxG.save.data.fps ? "MEM: " + mem + " MB" + "\n"
		+ "MEM PEAK: " + memMax + " MB" : "");

		if (visible && currentCount != cacheCount)
			text = "FPS: " + Math.round((currentCount + cacheCount) / 2) 
		+ "\n" + memInfo 
		+ "\n";
		
		textColor = 0xFFFFFFFF;

		if (memMax > 3000 || currentCount <= FlxG.save.data.framerateDraw / 2) {
				textColor = 0xFFFF0000;
			}

		cacheCount = currentCount;
	}
}  