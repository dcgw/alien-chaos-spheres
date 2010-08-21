package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private static const PLAY_AREA_SIZE:Number = 256;
		
		public var tick:uint;
		private var ship:Ship;
		
		public function PlayState()
		{
			super();
			
			tick = 0;
			
			FlxU.setWorldBounds(-PLAY_AREA_SIZE*2, -PLAY_AREA_SIZE*2, PLAY_AREA_SIZE*4, PLAY_AREA_SIZE*4);
			
			ship = new Ship();
			add(ship);
			add(new AlienDeathBall());
		}
		
		override public function update():void {
			tick++;
			
			var shipDistanceFromCentre:Number = Math.sqrt(ship.x*ship.x + ship.y*ship.y);
			if (shipDistanceFromCentre >= PLAY_AREA_SIZE) {
				var shipAngleFromCentre:Number = Math.atan2(ship.y, ship.x) - Math.PI/2;
				ship.x = -Math.sin(shipAngleFromCentre) * PLAY_AREA_SIZE;
				ship.y = Math.cos(shipAngleFromCentre) * PLAY_AREA_SIZE;
				if (ship.x < 0) {
					if (ship.velocity.x < 0) {
						ship.velocity.x = -ship.velocity.x / 2;
					}
				} else {
					if (ship.velocity.x > 0) {
						ship.velocity.x = -ship.velocity.x / 2;
					}
				}
				if (ship.y < 0) {
					if (ship.velocity.y < 0) {
						ship.velocity.y = -ship.velocity.y / 2;
					}
				} else {
					if (ship.velocity.y > 0) {
						ship.velocity.y = -ship.velocity.y / 2;
					}
				}
			} 
			
			super.update();
			FlxG.follow(ship);
		}
	}
}