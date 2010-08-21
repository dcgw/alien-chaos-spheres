package net.noiseinstitute.ld18
{
	import org.flixel.FlxSprite;
	
	public class AlienDeathBall extends FlxSprite
	{
		[Embed(source="AlienDeathBall.png")] private static const AlienDeathBallImage:Class;
		
		public function AlienDeathBall(x:Number=0, y:Number=0)
		{
			super(x, y, AlienDeathBallImage);
			offset.x = width/2;
			offset.y = height/2;
			solid = true;
		}
	}
}