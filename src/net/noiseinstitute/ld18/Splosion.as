package net.noiseinstitute.ld18
{
	import flash.text.engine.GroupElement;
	
	import org.flixel.FlxSprite;
	
	public class Splosion extends ThingThatScores
	{
		private static var RADIUS:Number = 16;
		
		private var _pointValue :Number;
		
		public function Splosion(x:Number=0, y:Number=0)
		{
			super(x, y);
			width = RADIUS*2;
			height = RADIUS*2;
			centreX = x;
			centreY = y;
			_pointValue = 0;
		}
		
		override public function render():void {
		}
		
		public function set pointValue (pointValue:Number):void {
			_pointValue = pointValue;
		}
		
		override public function get pointValue():Number {
			return _pointValue;
		}
	}
}