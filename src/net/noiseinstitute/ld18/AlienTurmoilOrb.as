package net.noiseinstitute.ld18
{
	import org.flixel.*;

	public class AlienTurmoilOrb extends AlienChaosSphere {
	
		private static const MAX_SPEED:Number = 20;
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		private static const THRUST:Number = .1;

		[Embed(source="AlienTurmoilOrb.png")] private static const AlienTurmoilOrbImage:Class;

		public function AlienTurmoilOrb(x:Number, y:Number, level:Number) {
			super(x, y, level, AlienTurmoilOrbImage);
		}
		
		override public function update():void {
			var s:PlayState = PlayState(FlxG.state);
			var currentDir:Number = Math.atan2(velocity.y, velocity.x);
			var thrustDir:Number = Math.atan2(y - s.ship.y, x - s.ship.x);

			var nvx:Number = velocity.x + (-Math.cos(thrustDir) * THRUST);
			var nvy:Number = velocity.y + (-Math.sin(thrustDir) * THRUST);
			var newSpeed:Number = Math.sqrt(nvx*nvx + nvy*nvy);

			//if(newSpeed <= MAX_SPEED || Math.abs(thrustDir - currentDir) < 0.3) {
				//velocity.x += (-Math.cos(thrustDir) * THRUST);
				//velocity.y += (-Math.sin(thrustDir) * THRUST);
			//}

			super.update();
}
	}
}