package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class GameOverState extends FlxState
	{
		public static const FIXED:FlxPoint = new FlxPoint(0,0);

		override public function create():void {
			var gameOverMsg:FlxText = new FlxText(0, FlxG.height/2 - 20, FlxG.width);
			gameOverMsg.text = "GAME OVER"
			gameOverMsg.color = 0xd8eba2;
			gameOverMsg.size = 32;
			gameOverMsg.alignment = "center";
			gameOverMsg.scrollFactor = FIXED;
			gameOverMsg.shadow = 0x131c1b;
			add(gameOverMsg);

			var score:FlxText = new FlxText(0, FlxG.height/2 + 20, FlxG.width);
			var strScore:String = FlxG.score.toString();
			while(strScore.length < 6) strScore = "0" + strScore;
			score.text = strScore + " pts";
			score.color = 0xd8eba2;
			score.size = 16;
			score.alignment = "center";
			score.scrollFactor = FIXED;
			score.shadow = 0x131c1b;
			add(score);
		}
	}
}