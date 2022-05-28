package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
    var options:Array<String> = ['Prefrences', 'Controls', 'Graphics', 'Exit'];

    private var grpOptions:FlxTypedGroup<Alphabet>;
    private var curSelected: Int = 0;
    private var menuBG:FlxSprite;

    override function create() {
        #if Desktop
        DiscordClient.changePresenece("In the Menus");
        #end

        menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        add(menuBG);

        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);

        for (i in 0...options.length)
        {
            var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
            optionText.screenCenter();
            optionText.y += (100 * (i - options.length / 2)) + 50;
            grpOptions.add(optionText);
        }
        
        changeSelection();

        super.create();
    }

    override function closeSubState() {
        super.closeSubState();
        changeSelection();
    }

    override function update(elasped:Float) 
    {
        super.update(elasped);

        if (controls.UP_P)
        {
            changeSelection(-1);
        }

        if (controls.DOWN_P)
        {
            changeSelection(1);
        }
        
        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.switchState(new MainMenuState());
        }  
        
        if (controls.ACCEPT)
        {
            for (item in grpOptions.members)
            {
                item.alpha = 0;
            }

            var optionChoices:String = options[curSelected];

            switch(optionChoices)
            {
                case 'Prefrences':
                    FlxG.switchState(new PrefrencesSubState());
                    trace("Prefrence Option Seleceted");
                case 'Controls': 
                    FlxG.switchState(new ControlsSubState());
                    trace("Control Option Selected");
                case 'Graphics': 
                     FlxG.switchState(new GraphicsSubState());
                    trace("Graphic Option Selected");
                case 'Exit':
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    FlxG.switchState(new MainMenuState());
                    trace("Back to MainMenu");
            }
        }    
    }
    
    function changeSelection(change:Int = 0) 
     {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var shit:Int = 0;

		for (item in grpOptions.members) 
        {
			item.targetY = shit - curSelected;
			shit++;

			item.alpha = 0.6;
			if (item.targetY == 0) 
            {
				item.alpha = 1;
			}
		}
	}
}