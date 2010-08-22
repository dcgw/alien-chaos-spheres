package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class InstructionsState extends FlxState
	{
		public static const FIXED:FlxPoint = new FlxPoint(0,0);

		override public function create():void {
			var titleMsg:FlxText = new FlxText(0, 20, FlxG.width);
			titleMsg.text = "Instructions"
			titleMsg.color = 0xffffff;
			titleMsg.size = 16;
			titleMsg.alignment = "center";
			titleMsg.scrollFactor = FIXED;
			titleMsg.shadow = 0x666666;
			add(titleMsg);

			var controlsMsg:FlxText = new FlxText(20, 60, FlxG.width-40);
			controlsMsg.text = "Using your laser cannon, push Alien Chaos Spheres into each other to destroy them."
			controlsMsg.color = 0xd8eba2;
			controlsMsg.size = 12;
			controlsMsg.alignment = "left";
			controlsMsg.scrollFactor = FIXED;
			controlsMsg.shadow = 0x131c1b;
			add(controlsMsg);

			var controlsMsg:FlxText = new FlxText(40, 120, FlxG.width-80);
			controlsMsg.text = "Fire: X\nTurn: Left, Right\nThrust: Up\nReverse: Down"
			controlsMsg.color = 0xd8eba2;
			controlsMsg.size = 12;
			controlsMsg.alignment = "left";
			controlsMsg.scrollFactor = FIXED;
			controlsMsg.shadow = 0x131c1b;
			add(controlsMsg);

			var contMsg:FlxText = new FlxText(0, FlxG.height - 20, FlxG.width);
			contMsg.text = "[ Continue ]"
			contMsg.color = 0xffffff;
			contMsg.size = 16;
			contMsg.alignment = "center";
			contMsg.scrollFactor = FIXED;
			contMsg.shadow = 0x666666;
			add(contMsg);
		}
		
		override public function update():void {
			if(FlxG.keys.SPACE || FlxG.keys.X || FlxG.keys.ENTER) {
				Game.sound.menuBlip.playCached();
				FlxG.state = new TitleState();
			}
		}
	}
}