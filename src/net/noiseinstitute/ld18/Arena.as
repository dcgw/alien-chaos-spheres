package net.noiseinstitute.ld18
{
	public class Arena extends LD18Sprite
	{
		[Embed(source="Arena.png")]
		private static const ArenaImage :Class;
		
		public function Arena()
		{
			super(0, 0, ArenaImage);
			centreX = 0;
			centreY = 0;
		}
	}
}