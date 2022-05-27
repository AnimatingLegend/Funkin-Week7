package options;

import flixel.FlxSprite;
import flash.text.TextField;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSubState;

using StringTools;

class PrefrencesSubState extends MusicBeatState
{
    
   public function new()
    {
        super();

        if (controls.BACK)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxG.switchState(new OptionsState());
            }	
    }
}