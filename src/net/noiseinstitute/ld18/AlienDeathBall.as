package net.noiseinstitute.ld18
{
	import org.flixel.FlxSprite;
	
	public class AlienDeathBall extends LD18Sprite
	{
		[Embed(source="AlienDeathBall.png")] private static const AlienDeathBallImage:Class;
		
		public function AlienDeathBall(x:Number=0, y:Number=0)
		{
			super(x, y, AlienDeathBallImage);
			centreX = x;
			centreY = y;
			solid = true;
		}
	}
}