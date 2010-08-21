package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class Ship extends FlxSprite
	{
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		
		[Embed(source="ship.png")] private static const ShipGraphic:Class; 
		
		public function Ship(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(120, 100, ShipGraphic);
			offset.x = frameWidth / 2;
			offset.y = frameHeight / 2;
			maxVelocity.x = 300;
			maxVelocity.y = 300;
			angle = 90;
			antialiasing = true;
		}
		
		override public function update():void {
			var angleRad:Number = angle * DEGREES_TO_RADIANS;
			if (FlxG.keys.LEFT) {
				angle -= 2;
			} else if(FlxG.keys.RIGHT) {
				angle += 2;
			} else if(FlxG.keys.UP) {
				velocity.x += 10 * Math.sin(angleRad);
				velocity.y -= 10 * Math.cos(angleRad);
			} else if(FlxG.keys.DOWN) {
				velocity.x -= 10 * Math.sin(angleRad);
				velocity.y += 10 * Math.cos(angleRad);
			}
			
			super.update();
		}
	}
}