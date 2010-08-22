package net.noiseinstitute.ld18
{
	import org.flixel.*;

	public class Bullet extends LD18Sprite
	{
		private static const SPEED:Number = 500;
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		
		[Embed(source="Bullet.png")] private static const BulletImage:Class;
		
		public function Bullet(x:Number, y:Number, angle:Number, inertia:FlxPoint)
		{
			super(x, y);
			loadGraphic(BulletImage, true, false, 2, 6);
			addAnimation("bullet", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 10);
			play("bullet");
			width = 2;
			height = 2;
			centreX = x;
			centreY = y;
			velocity.x = inertia.x + (Math.sin(angle * DEGREES_TO_RADIANS) * SPEED);
			velocity.y = inertia.y - (Math.cos(angle * DEGREES_TO_RADIANS) * SPEED);
			antialiasing = true;
			this.angle = angle;
		}

		override public function hitLeft(Contact:FlxObject, Velocity:Number):void {
			kill();
		}
		override public function hitRight(Contact:FlxObject, Velocity:Number):void {
			kill();
		}
		override public function hitTop(Contact:FlxObject, Velocity:Number):void {
			kill();
		}
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void {
			kill();
		}
	}
}