package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class GameOverState extends FlxState
	{
		public static const FIXED:FlxPoint = new FlxPoint(0,0);

		override public function create():void {
			var gameOverMsg:FlxText = new FlxText(0, FlxG.height/2, FlxG.width);
			gameOverMsg.text = "GAME OVER"
			gameOverMsg.color = 0xd8eba2;
			gameOverMsg.size = 32;
			gameOverMsg.alignment = "center";
			gameOverMsg.scrollFactor = FIXED;
			gameOverMsg.shadow = 0x131c1b;
			add(gameOverMsg);
		}
	}
}