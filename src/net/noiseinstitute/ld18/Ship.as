package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class Ship extends FlxSprite
	{
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		private static const RATE_OF_FIRE:uint = 10;
		
		[Embed(source="ship.png")] private static const ShipGraphic:Class; 

		private var lastFired:uint;
		
		public function Ship()
		{
			super(120, 100, ShipGraphic);
			offset.x = frameWidth / 2;
			offset.y = frameHeight / 2;
			maxVelocity.x = 300;
			maxVelocity.y = 300;
			angle = 90;
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
			var currentTick:uint = PlayState(FlxG.state).tick;

			// Only fire a bullet if enough ticks have passed
			if(currentTick >= lastFired + RATE_OF_FIRE) {
				FlxG.state.add(new Bullet(x, y, angle, velocity));
				lastFired = currentTick;
			}
		}
	}
}