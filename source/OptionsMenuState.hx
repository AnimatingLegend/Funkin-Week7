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
			new NaughtyOption("If checked, any explicit content will be censored/removed from the game."),
			#if !html5
			new FramerateOption("self explanatory"), // HTML5 has some Vsync enabled by default so this option is pretty much useless on web builds
			#end
			new DownscrollOption("If checked, your note strums appears on the bottom of the screen instead of up."),
			new MiddlescrollOption("If checked, your note strums appear in the middle of the screen, & your opponents note strums disappear."),
			new GhostTappingOption("If checked, you won't get misses from mashing keys while there are no notes to hit."),
			new CameraZoomOption("If unchecked, the camera won't zoom on every concurring beat."),
			new RatingHudOption("If checked, the rating sprites with appear on the games HUD."),
			new NotesplashOption("If unchecked, hitting 'Sick!' notes won't show firework particles."),
			new OpponentLightStrums("If checked, your opponents note strums light up whenever its their turn to sing."),
			new FPSOption("If unchecked, your fps counter & memory counter disappear's."),
		]),
		new OptionCatagory("Controls", []),
		new OptionCatagory("Exit", []),
	];

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	private var checkBoxesArray:Array<CheckboxThingie> = [];
	private var descTxt:FlxText;

	var currentSelectedCat:OptionCatagory;
	var checkbox:CheckboxThingie;
	var camFollow:FlxObject;
	var menuBG:FlxSprite;
	var textBG:FlxSprite;

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

		textBG = new FlxSprite(0, FlxG.height - 45).makeGraphic(FlxG.width, 50, 0xFF000000);
		textBG.alpha = 0.6;

		descTxt = new FlxText(textBG.x, textBG.y + 4, FlxG.width, currentDescription, 30);
		descTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER);
		descTxt.scrollFactor.set();

		FlxG.camera.follow(camFollow, null, 0.06);

		changeSelection(0);

		super.create();
	}

	var isCat:Bool = false;

	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		descTxt.text = currentDescription;

		Conductor.offset = FlxG.save.data.notesOffset;
		FlxG.fullscreen = FlxG.save.data.fullscreen;
		FlxG.camera.followLerp = CoolUtil.camLerpShit(0.06);

		if (!isCat)
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
			for (i in 0...checkBoxesArray.length)
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

			remove(textBG);
			remove(descTxt);

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
					var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(),
						currentSelectedCat.getOptions()[curSelected].boldDisplay, false);
					grpControls.add(ctrl);
					ctrl.isMenuItem = true;
					checkBoxesArray[curSelected].sprTracker = grpControls.members[curSelected];
					checkBoxesArray[curSelected].set_daValue(currentSelectedCat.getOptions()[curSelected].getAccept());
				}
			}
			else
			{
				if (options[curSelected].getName() == "Controls")
				{
					FlxG.switchState(new ControlsSubState());
				}
				else if (options[curSelected].getName() == "Exit")
				{
					FlxG.switchState(new MainMenuState());
					FlxG.sound.play(Paths.sound("cancelMenu"), false);
				}
				else
				{
					currentSelectedCat = options[curSelected];
					grpControls.clear();
					for (i in 0...currentSelectedCat.getOptions().length)
					{
						var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(),
							currentSelectedCat.getOptions()[i].boldDisplay, false);
						controlLabel.isMenuItem = true;
						controlLabel.targetY = i;
						grpControls.add(controlLabel);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						/*var checkbox:CheckboxThingie = new CheckboxThingie(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getAccept());
							checkbox.sprTracker = controlLabel;

							// using a FlxGroup is too much fuss!
							checkBoxesArray.push(checkbox);
							add(checkbox); */
					}
					curSelected = 0;
					updateCheckboxes();

					isCat = true;

					add(textBG);
					add(descTxt);
				}
			}
		}
		else if (controls.UI_LEFT_P && isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].left())
			{
				grpControls.remove(grpControls.members[curSelected]);
				var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(),
					currentSelectedCat.getOptions()[curSelected].boldDisplay, false);
				grpControls.add(ctrl);
				ctrl.isMenuItem = true;
			}
		}
		else if (controls.UI_RIGHT_P && isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].right())
			{
				grpControls.remove(grpControls.members[curSelected]);
				var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(),
					currentSelectedCat.getOptions()[curSelected].boldDisplay, false);
				grpControls.add(ctrl);
				ctrl.isMenuItem = true;
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function updateCheckboxes()
	{
		for (i in 0...checkBoxesArray.length)
		{
			checkBoxesArray[i].destroy();
			remove(checkBoxesArray[i]);
		}
		checkBoxesArray = [];
		for (i in 0...currentSelectedCat.getOptions().length)
		{
			currentSelectedCat.getOptions()[i].press(false);
			checkbox = new CheckboxThingie(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getAccept());
			checkbox.sprTracker = grpControls.members[i];
			
		 // using a FlxGroup is too much fuss!
			checkBoxesArray.push(checkbox);

			if (!currentSelectedCat.getOptions()[i].withoutCheckboxes)
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

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = 'Please select a category.';

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