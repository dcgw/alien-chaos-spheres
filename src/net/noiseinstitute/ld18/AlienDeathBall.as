package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class AlienDeathBall extends LD18Sprite
	{
		private static const SPLOSION_PARTICLES:Number = 20;
		
		[Embed(source="AlienDeathBall.png")] private static const AlienDeathBallImage:Class;
		
		private var splosion:FlxEmitter;
		
		public function AlienDeathBall(x:Number=0, y:Number=0) {
			super(x, y, AlienDeathBallImage);
			centreX = x;
			centreY = y;
			solid = true;
			
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
	}
}