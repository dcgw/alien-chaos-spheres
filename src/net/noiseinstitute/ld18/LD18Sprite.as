package net.noiseinstitute.ld18
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class LD18Sprite extends FlxSprite
	{
		public function LD18Sprite(x:Number=0, y:Number=0, SimpleGraphic:Class=null)
		{
			super(x, y, SimpleGraphic);
		}
		
		public function get centreX():Number {
			return x + width/2;
		}
		
		public function set centreX(centreX:Number):void {
			x = centreX - width/2;
		}
		
		public function get centreY():Number {
			return y + height/2;
		}
		
		public function set centreY(centreY:Number):void {
			y = centreY - height/2;
		}
		
		public function get centre():FlxPoint {
			return new FlxPoint(centreX, centreY);
		}
	}
}