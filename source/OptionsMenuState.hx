package;

import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;

class OptionsMenuState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	public static var ingame:Bool = false;

	var options:Array<OptionCatagory> = [
		new OptionCatagory("Preferences", [
			new NaughtyOption(),
			new DownscrollOption(),
			new GhostTappingOption(),
			new CameraZoomOption(),
			new NotesplashOption(),
			new FPSOption(),
		]),
		new OptionCatagory("Controls",[]),
		new OptionCatagory("Exit",[]),
	];
	
	private var grpControls:FlxTypedGroup<Alphabet>;
	private var checkBoxesArray:Array<CheckboxThingie> = [];

	var currentSelectedCat:OptionCatagory;
	var camFollow:FlxObject;
	var menuBG:FlxSprite;

	override function create()
	{
		
		menuBG = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.scrollFactor.x = 0;
        menuBG.scrollFactor.y = 0.18;
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter(X);
		add(camFollow);

		

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (100 * i) + 105, options[i].getName(), true, false);
			controlLabel.screenCenter();
			controlLabel.y += (100 * (i - (options.length / 2))) + 50;
			grpControls.add(controlLabel);
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		changeSelection(0);
		

		super.create();
	}

	var isCat:Bool = false;

	
	
	public static function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		Conductor.offset = FlxG.save.data.notesOffset;
		FlxG.fullscreen = FlxG.save.data.fullscreen;
		FlxG.camera.followLerp = CoolUtil.camLerpShit(0.06);

		if(!isCat)
		{
			grpControls.forEach(function(controlLabel:Alphabet)
			{
				controlLabel.screenCenter(X);
			
			});
		}
		else
		{
			grpControls.forEach(function(controlLabel:Alphabet)
			{
				controlLabel.x = 120;
			});
		}

			if (controls.BACK)
			{
				isCat = false;
				grpControls.clear();
				for (i in 0 ... checkBoxesArray.length) 
				{
			        
					remove(checkBoxesArray[i]);
					checkBoxesArray[i].destroy();
				}
				
				checkBoxesArray = [];

				for (i in 0...options.length)
					{
						var controlLabel:Alphabet = new Alphabet(0, (100 * i) + 105, options[i].getName(), true, false);
						controlLabel.screenCenter();
						controlLabel.y += (100 * (i - (options.length / 2))) + 50;
						grpControls.add(controlLabel);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
				curSelected = 0;
				changeSelection(0);
			}
			if (controls.UI_UP_P)
				changeSelection(-1);
			if (controls.UI_DOWN_P)
				changeSelection(1);
			
			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT)
						{
							if (controls.UI_RIGHT_P)
								currentSelectedCat.getOptions()[curSelected].right();
							if (controls.UI_LEFT_P)
								currentSelectedCat.getOptions()[curSelected].left();
						}
					else
					{
						if (controls.UI_RIGHT_P)
							currentSelectedCat.getOptions()[curSelected].right();
						if (controls.UI_LEFT_P)
							currentSelectedCat.getOptions()[curSelected].left();
					}
				}
				
			}
			

			if (controls.ACCEPT)
			{
				
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press(true))
					{
						grpControls.remove(grpControls.members[curSelected]);
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(), currentSelectedCat.getOptions()[curSelected].boldDisplay, false);
						grpControls.add(ctrl);
						ctrl.isMenuItem = true;
						checkBoxesArray[curSelected].sprTracker = grpControls.members[curSelected];
						checkBoxesArray[curSelected].set_daValue(currentSelectedCat.getOptions()[curSelected].getAccept());
					}
				}
				else
				{
					
                        if(options[curSelected].getName() == "Controls")
						{
							FlxG.switchState(new ControlsSubState());

						}
						else if(options[curSelected].getName() == "Exit")
						{
							FlxG.switchState(new MainMenuState());

							FlxG.sound.play(Paths.sound("cancelMenu"), false);
						}
						else
						{
							currentSelectedCat = options[curSelected];
							isCat = true;
							grpControls.clear();
							for (i in 0...currentSelectedCat.getOptions().length)
								{
									var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), currentSelectedCat.getOptions()[i].boldDisplay, false);
									controlLabel.isMenuItem = true;
									controlLabel.targetY = i;
									grpControls.add(controlLabel);
									// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
									/*var checkbox:CheckboxThingie = new CheckboxThingie(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getAccept());
									checkbox.sprTracker = controlLabel;

									// using a FlxGroup is too much fuss!
									checkBoxesArray.push(checkbox);
									add(checkbox);*/
								}
							curSelected = 0;
							updateCheckboxes();
						}
                    
					
					
				}
			}
			else if(controls.UI_LEFT_P && isCat)
			{
				if(currentSelectedCat.getOptions()[curSelected].left())
				{
					grpControls.remove(grpControls.members[curSelected]);
					var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(), currentSelectedCat.getOptions()[curSelected].boldDisplay, false);
					grpControls.add(ctrl);
					ctrl.isMenuItem = true;
				}
			}
			else if (controls.UI_RIGHT_P && isCat)
			{
				if(currentSelectedCat.getOptions()[curSelected].right())
				{
					grpControls.remove(grpControls.members[curSelected]);
					var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(), currentSelectedCat.getOptions()[curSelected].boldDisplay, false);
					grpControls.add(ctrl);
					ctrl.isMenuItem = true;
				}
			}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function updateCheckboxes()
	{
		for (i in 0 ... checkBoxesArray.length)
		{
			checkBoxesArray[i].destroy();
			remove(checkBoxesArray[i]);
		}
		checkBoxesArray = [];
		for (i in 0...currentSelectedCat.getOptions().length)
		{
			currentSelectedCat.getOptions()[i].press(false);
			var checkbox:CheckboxThingie = new CheckboxThingie(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getAccept());
			checkbox.sprTracker = grpControls.members[i];
			// using a FlxGroup is too much fuss!
			checkBoxesArray.push(checkbox);
			if(!currentSelectedCat.getOptions()[i].withoutCheckboxes)
				add(checkbox);
			
		}
	}

	function changeSelection(change:Int = 0)
	{	
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.5, false);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		camFollow.screenCenter();

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
			
		}		
	}
}
