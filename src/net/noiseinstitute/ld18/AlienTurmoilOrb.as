package net.noiseinstitute.ld18
{
	import org.flixel.*;

	public class AlienTurmoilOrb extends AlienChaosSphere {
	
		private static const MAX_SPEED:Number = 20;
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		private static const THRUST:Number = .1;

		[Embed(source="AlienTurmoilOrb.png")] private static const AlienTurmoilOrbImage:Class;

		public function AlienTurmoilOrb(x:Number, y:Number) {
			super(x, y, 3, AlienTurmoilOrbImage);
		}
		
		override public function update():void {
			updateVelocity();
			
			var s:PlayState = PlayState(FlxG.state);
			var thrustDir:Number = Math.atan2(y - s.ship.y, x - s.ship.x);
			velocity.x += (-Math.cos(thrustDir) * THRUST);
			velocity.y += (-Math.sin(thrustDir) * THRUST);

			super.update();
		}
	}
}