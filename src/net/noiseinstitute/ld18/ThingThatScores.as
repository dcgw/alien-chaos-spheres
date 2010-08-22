package net.noiseinstitute.ld18
{
	public class ThingThatScores extends LD18Sprite
	{
		public var chainMultiplier :Number;
		
		public function ThingThatScores(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			chainMultiplier = 1;
		}
		
		public function get pointValue ():Number {
			return 0;
		}
	}
}