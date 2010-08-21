package net.noiseinstitute.ld18
{
	import org.flixel.FlxSprite;
	
	public class AlienDeathBall extends LD18Sprite
	{
		[Embed(source="AlienDeathBall.png")] private static const AlienDeathBallImage:Class;
		
		private var dieSound:SfxrSynth;
		
		public function AlienDeathBall(x:Number=0, y:Number=0)
		{
			super(x, y, AlienDeathBallImage);
			centreX = x;
			centreY = y;
			solid = true;
			
			dieSound = new SfxrSynth();
			dieSound.setSettingsString("3,,0.303,0.461,0.4565,0.148,,-0.3558,,,,,,,,,0.5001,-0.0673,1,,,,,0.5");
			dieSound.cacheMutations(4);
		}
		
		override public function kill():void {
			dieSound.playCachedMutation(4);
			super.kill();
		} 
	}
}