package net.noiseinstitute.ld18
{
	import org.flixel.FlxSprite;
	
	public class SpawnPoint extends LD18Sprite
	{
		[Embed(source="SpawnPoint.png")]
		private static const SpawnPointImage:Class;
		
		public function SpawnPoint(x:Number=0, y:Number=0)
		{
			super(x, y, SpawnPointImage);
			centreX = x;
			centreY = y;
		}
	}
}