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
            if (controls.BACK)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxG.switchState(new OptionsMenuState());
            }  
    }
}