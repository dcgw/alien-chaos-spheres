package net.noiseinstitute.ld18
{
	import org.flixel.FlxGame;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	
	public class Game extends FlxGame {

		public static var sound:Sound;
		
		public function Game() {
			super(320, 240, LoadState, 2);
		}
	}
}