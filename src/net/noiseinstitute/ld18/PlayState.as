package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private var ship:Ship;
		
		public function PlayState()
		{
			super();
			
			ship = new Ship();
			add(ship);
			add(new AlienDeathBall());
		}
		
		override public function update():void {
			FlxG.follow(ship);
			super.update();
		}
	}
}