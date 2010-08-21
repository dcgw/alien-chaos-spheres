package net.noiseinstitute.ld18
{
	import org.flixel.FlxState;
	
	public class PlayState extends FlxState
	{
		public function PlayState()
		{
			super();
			add(new Bullet(160, 120, 135)); // for no reason
		}
	}
}