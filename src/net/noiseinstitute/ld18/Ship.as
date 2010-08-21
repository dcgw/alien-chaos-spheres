package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class Ship extends LD18Sprite
	{
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		private static const RATE_OF_FIRE:uint = 10;
		
		[Embed(source="ship.png")] private static const ShipGraphic:Class; 

		private var lastFired:uint;
		
		public function Ship()
		{
			super(0, 0, ShipGraphic);
			centreX = 0;
			centreY = 0;
			antialiasing = true;
			lastFired = 0;
		}
		
		override public function update():void {
			// Move
			var angleRad:Number = angle * DEGREES_TO_RADIANS;
			if (FlxG.keys.LEFT) {
				angle -= 2;
			} else if(FlxG.keys.RIGHT) {
				angle += 2;
			} else if(FlxG.keys.UP) {
				velocity.x += 10 * Math.sin(angleRad);
				velocity.y -= 10 * Math.cos(angleRad);
			} else if(FlxG.keys.DOWN) {
				velocity.x -= 10 * Math.sin(angleRad);
				velocity.y += 10 * Math.cos(angleRad);
			}
			
			// Shoot
			if(FlxG.keys.X) {
				fire();
			}
			
			super.update();
		}
		
		public function fire():void {
			var s:PlayState = PlayState(FlxG.state);

			// Only fire a bullet if enough ticks have passed
			if(s.tick >= lastFired + RATE_OF_FIRE) {
				s.bullets.add(new Bullet(centreX, centreY, angle, velocity));
				lastFired = s.tick;
			}
		}
	}
}