package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		public var tick:uint;
		private var ship:Ship;
		
		public function PlayState()
		{
			super();
			
			tick = 0;
			
			ship = new Ship();
			add(ship);
			add(new AlienDeathBall());
		}
		
		override public function update():void {
			FlxG.follow(ship);
			tick++;
			super.update();
		}
	}
}