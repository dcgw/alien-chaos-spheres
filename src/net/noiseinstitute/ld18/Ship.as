package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class Ship extends FlxSprite
	{
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		
		private var state:PlayState;
		
		[Embed(source="ship.png")] private static const ShipGraphic:Class; 
		
		public function Ship(state:PlayState)
		{
			super(120, 100, ShipGraphic);
			this.state = state;
			offset.x = frameWidth / 2;
			offset.y = frameHeight / 2;
			maxVelocity.x = 300;
			maxVelocity.y = 300;
			maxAngular = 100;
			//angularAcceleration = 20;
			angularVelocity = 0;
			angle = 90;
			antialiasing = true;
		}
		
		override public function update():void {
			var angleRad:Number = angle * DEGREES_TO_RADIANS;
			if (FlxG.keys.LEFT) {
				angularVelocity -= 30;
			} else if(FlxG.keys.RIGHT) {
				angularVelocity += 30;
			} else if(FlxG.keys.UP) {
				velocity.x += 10 * Math.sin(angleRad);
				velocity.y -= 10 * Math.cos(angleRad);
			} else if(FlxG.keys.DOWN) {
				velocity.x -= 10 * Math.sin(angleRad);
				velocity.y += 10 * Math.cos(angleRad);
			}
			
			if(FlxG.keys.X) {
				state.add(new Bullet(x, y, angle));
			}
			
			super.update();
		}
	}
}