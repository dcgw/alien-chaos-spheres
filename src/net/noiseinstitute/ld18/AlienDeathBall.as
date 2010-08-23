package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class AlienDeathBall extends AlienChaosSphere {
		
		[Embed(source="AlienDeathBall.png")] private static const AlienDeathBallImage:Class;
		
		private static const MAX_SINUS_VELOCITY:Number = Math.PI/90;
		private static const MAX_ROTATION_LIMIT:Number = 45;
		
		protected var sinusVelocity:Number;
		protected var sinusPosition:Number;
		protected var angleLimit:Number;
		
		public function AlienDeathBall(x:Number, y:Number) {
			super(x, y, 1, AlienDeathBallImage);
			
			sinusPosition = 0;
			sinusVelocity = (Math.random() - 0.5) * MAX_SINUS_VELOCITY * 2;
			angleLimit = Math.random() * MAX_ROTATION_LIMIT;
		}
		
		override public function update():void {
			sinusPosition += sinusVelocity;
			angle = Math.sin(sinusPosition) * angleLimit;
			super.update();
		}
	}
}