package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class StartGameState extends FlxState {
		
		public static const FIXED:FlxPoint = new FlxPoint(0,0);
		private static const MENU_COLOUR_SELECTED:uint = 0xFFFFFF;
		private static const MENU_COLOUR_SHADED:uint = 0xAAAAAA;
		
		private var menu:FlxGroup;
		private var menuItem:Number;

		override public function create():void {
			FlxG.score = 0;
			
			var titleGTS:FlxText = new FlxText(0, 10, FlxG.width);
			titleGTS.text = "GREEN TRIANGLE SHIP"
			titleGTS.color = 0x006600;
			titleGTS.size = 24;
			titleGTS.alignment = "center";
			titleGTS.scrollFactor = FIXED;
			titleGTS.shadow = 0x333333;
			add(titleGTS);

			var titleVs:FlxText = new FlxText(0, 39, FlxG.width);
			titleVs.text = "vs"
			titleVs.color = 0x666666;
			titleVs.size = 24;
			titleVs.alignment = "center";
			titleVs.scrollFactor = FIXED;
			titleVs.shadow = 0x333333;
			add(titleVs);

			var titleACS:FlxText = new FlxText(0, 70, FlxG.width);
			titleACS.text = "ALIEN CHAOS"
			titleACS.color = 0xaa0000;
			titleACS.size = 32;
			titleACS.alignment = "center";
			titleACS.scrollFactor = FIXED;
			titleACS.shadow = 0x333333;
			add(titleACS);

			var titleS:FlxText = new FlxText(0, 110, FlxG.width);
			titleS.text = "SPHERES"
			titleS.color = 0xaa0000;
			titleS.size = 48;
			titleS.alignment = "center";
			titleS.scrollFactor = FIXED;
			titleS.shadow = 0x333333;
			add(titleS);
			
			menu = new FlxGroup();
			add(menu);
			menuItem = 0;

			var menuPlay:FlxText = new FlxText(0, FlxG.height - 60, FlxG.width);
			menuPlay.text = "[ Play ]"
			menuPlay.color = 0xffffff;
			menuPlay.size = 16;
			menuPlay.alignment = "center";
			menuPlay.scrollFactor = FIXED;
			menuPlay.shadow = 0x666666;
			menuPlay.flicker(0);
			menu.add(menuPlay);

			var menuInstructions:FlxText = new FlxText(0, FlxG.height - 40, FlxG.width);
			menuInstructions.text = "Instructions"
			menuInstructions.color = 0xaaaaaa;
			menuInstructions.size = 16;
			menuInstructions.alignment = "center";
			menuInstructions.scrollFactor = FIXED;
			menuInstructions.shadow = 0x666666;
			menuInstructions.flicker(0);
			menu.add(menuInstructions);
		
			var menuQuit:FlxText = new FlxText(0, FlxG.height - 20, FlxG.width);
			menuQuit.text = "Do Nothing"
			menuQuit.color = MENU_COLOUR_SHADED;
			menuQuit.size = 16;
			menuQuit.alignment = "center";
			menuQuit.scrollFactor = FIXED;
			menuQuit.shadow = 0x666666;
			menuQuit.flicker(0);
			menu.add(menuQuit);
		}
		
		override public function update():void {
			if(FlxG.keys.SPACE || FlxG.keys.X || FlxG.keys.ENTER) {
				Game.sound.menuBlip.playCached();
				switch(menuItem) {
					case 0:
						FlxG.state = new PlayState();
						return;
					case 1:
						FlxG.state = new InstructionsState();
						return;
					case 2:
						return;
				}
			} else if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("DOWN")) {
				Game.sound.menuBlip.playCached();

				var m:FlxText = FlxText(menu.members[menuItem]);
				m.text = m.text.substr(2, m.text.length - 4);
				m.color = MENU_COLOUR_SHADED;

				if(FlxG.keys.justPressed("UP")) {
					menuItem = (menuItem == 0) ? menu.members.length - 1 : menuItem - 1;
				} else {
					menuItem = (menuItem + 1) % menu.members.length;
				}

				m = FlxText(menu.members[menuItem]);
				m.text = "[ " + m.text + " ]";
				m.color = MENU_COLOUR_SELECTED;
			}
		}
	}
}