package net.noiseinstitute.ld18
{
	import org.flixel.FlxState;
	
	public class PlayState extends FlxState
	{
		public var tick:uint;
		
		public function PlayState()
		{
			super();
			
			tick = 0;
			
			add(new Ship());
		}
		
		override public function update():void {
			tick++;
			super.update();
		}
	}
}