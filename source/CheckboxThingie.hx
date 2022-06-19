package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;

using StringTools;

class CheckboxThingie extends FlxSprite
{

	public var sprTracker:FlxSpriteGroup;

	public override function new(x:Float, y:Float, ?checked:Bool = false)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('checkboxThingie');
		animation.addByPrefix("selecting", "Check Box selecting animation0", 24, false);
		animation.addByPrefix("selected", "Check Box Selected Static0", 24, false);
		animation.addByPrefix('unchecked', "Check Box unselected0", 24, false);
		antialiasing = true;
		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
		set_daValue(checked);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (animation.curAnim.name) 
		{
			case "unchecked":
				offset.set(5, 15);
			case "selected":
				offset.set(15, 27);
		}

		if (sprTracker != null)
			setPosition(10, sprTracker.y - 30);
		else
			destroy();

	}

	public function set_daValue(checked:Bool)
	{
		checked ? animation.play("selected", true) : animation.play("unchecked");
	}
}