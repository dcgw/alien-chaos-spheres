package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class InstructionsState extends FlxState
	{
		public static const FIXED:FlxPoint = new FlxPoint(0,0);

		override public function create():void {
			var gameOverMsg:FlxText = new FlxText(0, 20, FlxG.width);
			gameOverMsg.text = "Instructions"
			gameOverMsg.color = 0xffffff;
			gameOverMsg.size = 20;
			gameOverMsg.alignment = "center";
			gameOverMsg.scrollFactor = FIXED;
			gameOverMsg.shadow = 0x666666;
			add(gameOverMsg);

			var gameOverMsg:FlxText = new FlxText(0, 80, FlxG.width);
			gameOverMsg.text = "Get on with it"
			gameOverMsg.color = 0xd8eba2;
			gameOverMsg.size = 16;
			gameOverMsg.alignment = "center";
			gameOverMsg.scrollFactor = FIXED;
			gameOverMsg.shadow = 0x131c1b;
			add(gameOverMsg);

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
				FlxG.state = new StartGameState();
			}
		}
	}
}