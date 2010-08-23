package net.noiseinstitute.ld18
{
	import flash.events.*;
	import flash.utils.*;
	
	import org.flixel.*;

	public class AlienMaladyGlobe extends AlienChaosSphere {
		
		private static const MIN_LEAP_INTERVAL:Number = 5000;
		private static const MAX_LEAP_INTERVAL:Number = 7000;
		private static const LEAP_STRENGTH:Number = 200;
		private static const FLASH_INTERVAL:uint = 5;
		
		[Embed(source="AlienTurmoilOrb.png")] private static const AlienMaladyGlobeImage:Class;

		private var leapTimer:Timer;
		private var flashTimer:Timer;
		private var leapFlash:Boolean;
		private var flashOn:Boolean;
		
		public function AlienMaladyGlobe(x:Number, y:Number) {
			super(x, y, 5, AlienMaladyGlobeImage);
			
			leapFlash = false;
			flashOn = false;
			
			var leapInterval:Number = (Math.random() * (MAX_LEAP_INTERVAL - MIN_LEAP_INTERVAL)) + MIN_LEAP_INTERVAL;
			leapTimer = new Timer(leapInterval);
			leapTimer.addEventListener(TimerEvent.TIMER, function ():void {
				leapFlash = false;
				
				if(!dead) {
					var s:PlayState = PlayState(FlxG.state);
					var thrustDir:Number = Math.atan2(y - s.ship.y, x - s.ship.x);
					velocity.x = (-Math.cos(thrustDir) * LEAP_STRENGTH);
					velocity.y = (-Math.sin(thrustDir) * LEAP_STRENGTH);					
				}
			});
			leapTimer.start();
			
			flashTimer = new Timer(leapTimer.delay - 1000);
			flashTimer.addEventListener(TimerEvent.TIMER, function ():void {
				leapFlash = true;
			});
			flashTimer.start();
		}
		
		override public function update():void {
			var s:PlayState = PlayState(FlxG.state);
			updateVelocity();
			
			if(leapFlash) {
				if(s.tick % FLASH_INTERVAL == 0) {
					flashOn = !flashOn;
					color = (flashOn) ? 0xffffffff : null;
				}
			}
			
			super.update();
		}
	}
}