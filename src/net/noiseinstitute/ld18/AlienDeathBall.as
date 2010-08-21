package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class AlienDeathBall extends LD18Sprite
	{
		private static const SPLOSION_PARTICLES:Number = 20;
		private static const MAX_SINUS_VELOCITY:Number = Math.PI/90;
		private static const MAX_ROTATION_LIMIT:Number = 45;
		
		[Embed(source="AlienDeathBall.png")] private static const AlienDeathBallImage:Class;
		
		private var splosion:FlxEmitter;
		private var sinusVelocity:Number;
		private var sinusPosition:Number;
		private var angleLimit:Number;
		
		public function AlienDeathBall(x:Number=0, y:Number=0) {
			super(x, y, AlienDeathBallImage);
			centreX = x;
			centreY = y;
			solid = true;
			
			sinusPosition = 0;
			sinusVelocity = (Math.random() - 0.5) * MAX_SINUS_VELOCITY * 2;
			angleLimit = Math.random() * MAX_ROTATION_LIMIT;
			antialiasing = true;
			
			// Set up the asplosion
			splosion = new FlxEmitter(0,0); 
			splosion.gravity = 0;
			splosion.particleDrag.x = 75;
			splosion.particleDrag.y = 75;
			splosion.delay = 1;
			splosion.width = width;
			splosion.height = height;
			
			for(var i:Number = 0; i < SPLOSION_PARTICLES; i++) {
				var particle:FlxSprite = new FlxSprite();
				particle.createGraphic(2, 2, 0xffaa0000);
				splosion.add(particle);
			}
			
			var s:PlayState = PlayState(FlxG.state);
			s.add(splosion);
		}
		
		override public function kill():void {
			splosion.x = x;
			splosion.y = y;
			splosion.start();
			super.kill();
		}
		
		override public function update():void {
			sinusPosition += sinusVelocity;
			angle = Math.sin(sinusPosition) * angleLimit;
			super.update();
		}
	}
}