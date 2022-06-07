package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSubState;
import flixel.util.FlxSave;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class GraphicsSubState extends MusicBeatState
{
    private var menuBG:FlxSprite;
    private var curSelected: Int = 0;
    private var optionShit:Array<String> = [''];
    private var grpGraphics:FlxTypedGroup<Alphabet>;


    public function new()
    {
        super();

        menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        add(menuBG); /*adding the bg here so it wont just be a black screen with controls*/

        grpGraphics = new FlxTypedGroup<Alphabet>();
        add(grpGraphics);

        for (i in 0...optionShit.length)
        {
            var graphicText:Alphabet = new Alphabet(0, 0, optionShit[i], true, false);
            graphicText.y += (100 * (i - optionShit.length / 2)) + 50;
            grpGraphics.add(graphicText);
        }
    }
    
    // controls
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.UP_P)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(-1);
        } 
        
        if(controls.DOWN_P)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(1);   
        }    

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.switchState(new OptionsMenuState());
        }  
        
        if (controls.ACCEPT)
        {
            for (item in grpGraphics.members)
            {
                item.alpha = 0.5;
            }

            var dopeChoices:String = optionShit[curSelected];
            
            switch(dopeChoices)
            {}
        }    
    }
    
    function changeItem(change:Int = 0) 
    {
           curSelected += change;
           if (curSelected < 0)
               curSelected = optionShit.length - 1;
           if (curSelected >= optionShit.length)
               curSelected = 0;
    }
    
}