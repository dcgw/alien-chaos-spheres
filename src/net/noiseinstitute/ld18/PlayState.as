package net.noiseinstitute.ld18
{
	import org.flixel.FlxState;
	
	public class PlayState extends FlxState
	{
		public function PlayState()
		{
			super();
			add(new Bullet(0, 0, 0.1)); // for no reason
		}
	}
}