package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;

class BGSprite extends FlxSprite
{
	public var idleAnim:String = null;

	override public function new(image:String, x:Float = 0, y:Float = 0, scrollX:Float = 1, scrollY:Float = 1, animations:Array<String> = null, loopAnims:Bool = false, ?library:String)
	{
		super(x, y);
		
		if (animations != null)
		{
			frames = Paths.getSparrowAtlas(image, library);
			for (anim in animations)
			{
				animation.addByPrefix(anim, anim, 24, loopAnims);
				animation.play(anim);
				if (idleAnim == null)
					idleAnim = anim;
			}
		}
		else
		{
			loadGraphic(Paths.image(image, library));
			active = false;
		}
		scrollFactor.set(scrollX, scrollY);
		antialiasing = true;
	}

	public function dance()
	{
		if (idleAnim != null)
			animation.play(idleAnim);
	}
}