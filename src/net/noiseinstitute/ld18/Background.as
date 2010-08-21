package net.noiseinstitute.ld18
{
	import org.flixel.FlxTileblock;
	
	public class Background extends FlxTileblock
	{
		[Embed(source="Background.png")]
		private static const BackgroundImage:Class;
		
		public function Background(x:int, y:int, width:uint, height:uint)
		{
			super(x, y, width, height);
			loadGraphic(BackgroundImage);
		}
	}
}