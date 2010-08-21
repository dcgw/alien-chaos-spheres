package net.noiseinstitute.ld18
{
	import org.flixel.FlxSprite;

	public class Bullet extends FlxSprite
	{
		private static const SPEED:Number = 100;
		
		[Embed(source="Bullet.png")]
		private static const BulletImage:Class;
		
		public function Bullet(x:Number, y:Number, angle:Number)
		{
			super(x, y, BulletImage);
			offset.x = width/2;
			offset.y = height/2;
			velocity.x = Math.sin(angle) * SPEED;
			velocity.y = Math.cos(angle) * SPEED;
		}
	}
}