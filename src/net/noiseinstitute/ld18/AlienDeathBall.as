package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class AlienDeathBall extends AlienChaosSphere {
		
		[Embed(source="AlienDeathBall.png")] private static const AlienDeathBallImage:Class;
		
		public function AlienDeathBall(x:Number, y:Number, level:Number) {
			super(x, y, level, AlienDeathBallImage);
		}
	}
}