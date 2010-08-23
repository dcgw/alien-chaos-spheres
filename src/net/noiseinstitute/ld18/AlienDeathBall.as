package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class AlienDeathBall extends ThingThatScores
	{
		private static const DEBRIS_PARTICLES:Number = 40;
		private static const MAX_SINUS_VELOCITY:Number = Math.PI/90;
		private static const MAX_ROTATION_LIMIT:Number = 45;
		private static const MIN_POINT_VALUE:Number = 100;
		
		[Embed(source="AlienDeathBall.png")] private static const AlienDeathBallImage:Class;
		
		private var debrisEmitter:FlxEmitter;
		private var sinusVelocity:Number;
		private var sinusPosition:Number;
		private var angleLimit:Number;
		private var _pointValue:Number;
		
		public function AlienDeathBall(x:Number=0, y:Number=0) {
			super(x, y, AlienDeathBallImage);
			centreX = x;
			centreY = y;
			solid = true;
			_pointValue = 1000;
			
			sinusPosition = 0;
			sinusVelocity = (Math.random() - 0.5) * MAX_SINUS_VELOCITY * 2;
			angleLimit = Math.random() * MAX_ROTATION_LIMIT;
			antialiasing = true;
			
			// Set up the debris emitter
			debrisEmitter = new FlxEmitter(0,0); 
			debrisEmitter.gravity = 0;
			debrisEmitter.particleDrag.x = 75;
			debrisEmitter.particleDrag.y = 75;
			debrisEmitter.delay = 1;
			debrisEmitter.width = width;
			debrisEmitter.height = height;
			
			for(var i:Number = 0; i < DEBRIS_PARTICLES; i++) {
				var particle:FlxSprite = new AlienDebris();
				debrisEmitter.add(particle);
			}
			
			if (FlxG.state is PlayState) {
				var s:PlayState = PlayState(FlxG.state);
				s.debris.add(debrisEmitter);
			}
		}
		
		override public function kill():void {
			debrisEmitter.x = x;
			debrisEmitter.y = y;
			debrisEmitter.start();
			super.kill();
		}
		
		override public function update():void {
			var s:PlayState = PlayState(FlxG.state);
			sinusPosition += sinusVelocity;
			angle = Math.sin(sinusPosition) * angleLimit;
			if(_pointValue > MIN_POINT_VALUE) _pointValue --;
			super.update();
		}
		
		override public function get pointValue():Number {
			var speed:Number = VectorMath.magnitude(velocity);
			var multiplier:Number = (speed / 100.0) + 1;
			return _pointValue * multiplier * 0.1;
		}
		
		public function penalize():void {
			_pointValue/=2;
		}
	}
}