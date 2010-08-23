package net.noiseinstitute.ld18
{
	public class ThingThatScores extends LD18Sprite
	{
		public var chainMultiplier :Number;
		protected var _pointValue:Number;
		
		public function ThingThatScores(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			chainMultiplier = 1;
			_pointValue = 0;
		}
		
		public function set pointValue (pointValue:Number):void {
			_pointValue = pointValue;
		}

		public function get pointValue ():Number {
			return _pointValue;
		}
	}
}