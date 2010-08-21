package net.noiseinstitute.ld18
{
	import org.flixel.*;

	public class Bullet extends FlxSprite
	{
		private static const SPEED:Number = 100;
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		
		[Embed(source="Bullet.png")]
		private static const BulletImage:Class;
		
		public function Bullet(x:Number, y:Number, angle:Number, inertia:FlxPoint)
		{
			super(x, y, BulletImage);
			offset.x = width/2;
			offset.y = height/2;
			velocity.x = inertia.x + (Math.sin(angle * DEGREES_TO_RADIANS) * SPEED);
			velocity.y = -inertia.y - (Math.cos(angle * DEGREES_TO_RADIANS) * SPEED);
			antialiasing = true;
			this.angle = angle;
		}
	}
}