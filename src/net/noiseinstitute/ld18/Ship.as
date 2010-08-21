package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class Ship extends FlxSprite
	{
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		
		[Embed(source="ship.png")] private static const ShipGraphic:Class; 
		
		public function Ship()
		{
			super(0, 0, ShipGraphic);
			offset.x = width / 2;
			offset.y = height / 2;
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
			
			if(FlxG.keys.X) {
				fire();
			}
			
			super.update();
		}
		
		public function fire():void {
			FlxG.state.add(new Bullet(x, y, angle, velocity));
		}
	}
}