package net.noiseinstitute.ld18
{
	import org.flixel.FlxGame;
	
	[SWF(width="640", height="360", backgroundColor="#000000")]
	public class Game extends FlxGame
	{
		public function Game()
		{
			super(320, 240, PlayState, 2);
		}
	}
}