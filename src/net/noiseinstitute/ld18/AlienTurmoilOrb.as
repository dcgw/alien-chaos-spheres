package net.noiseinstitute.ld18
{
	import org.flixel.*;

	public class AlienTurmoilOrb extends AlienChaosSphere {
	
		private static const MAX_SPEED:Number = 20;
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		private static const THRUST:Number = .1;
		private static const STAY_STILL_THIS_LONG:uint = 30;

		[Embed(source="AlienTurmoilOrb.png")] private static const AlienTurmoilOrbImage:Class;
		
		private var haveStayedStillThisLong:uint = 0;
		
		public function AlienTurmoilOrb(x:Number, y:Number) {
			super(x, y, 3);
			loadGraphic(AlienTurmoilOrbImage, true);
			addAnimation("3lives", [0], 1);
			addAnimation("2lives", [1], 1);
			addAnimation("1lives", [2], 1);
		}
		
		override public function update():void {
			updateVelocity();
			
			play(Math.min(health, 3)+"lives");
			
			if (haveStayedStillThisLong > STAY_STILL_THIS_LONG) {
				var s:PlayState = PlayState(FlxG.state);
				var currentDir:Number = Math.atan2(velocity.y, velocity.x);
				var thrustDir:Number = Math.atan2(y - s.ship.y, x - s.ship.x);
	
				var nvx:Number = velocity.x + (-Math.cos(thrustDir) * THRUST);
				var nvy:Number = velocity.y + (-Math.sin(thrustDir) * THRUST);
				var newSpeed:Number = Math.sqrt(nvx*nvx + nvy*nvy);
	
				velocity.x += (-Math.cos(thrustDir) * THRUST);
				velocity.y += (-Math.sin(thrustDir) * THRUST);
			} else {
				++haveStayedStillThisLong;
			}
			
			super.update();
		}
	}
}