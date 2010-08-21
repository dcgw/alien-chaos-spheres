package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class Ship extends LD18Sprite
	{
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		private static const RATE_OF_FIRE:uint = 10;
		private static const DEATH_TIME:uint = 100;
		private static const FLICKER_DURATION:Number = 3;
		private static const SPLOSION_PARTICLES:Number = 12;
		private static const NUM_LIVES:Number = 3;
		
		private var shootSound:SfxrSynth;
		private var dieSound:SfxrSynth;
		private var splosion:FlxEmitter;
		
		public var lives:Number;
		
		[Embed(source="ship.png")] private static const ShipGraphic:Class; 

		private var lastFired:uint;
		private var dieTick:uint;
		
		public function Ship()
		{
			super(0, 0, ShipGraphic);
			lives = NUM_LIVES;
			centreX = 0;
			centreY = 0;
			antialiasing = true;
			lastFired = 0;
			
			// The sound to play when shooting
			shootSound = new SfxrSynth();
			shootSound.setSettingsString("0,,0.1564,0.2223,0.2657,0.7463,0.2,-0.3115,,,,,,0.1768,0.0694,,0.1957,-0.139,1,,,0.2701,,0.5");
			shootSound.cacheMutations(4);

			// The sound to play on death
			dieSound = new SfxrSynth();
			dieSound.setSettingsString("3,,0.3926,0.6813,0.2557,0.0716,,,,,,0.1538,0.822,,,,,,1,,,,,0.5");
			dieSound.cacheMutations(4);
			
			// Set up the asplosion
			splosion = new FlxEmitter(0,0); 
			splosion.gravity = 0;
			splosion.particleDrag.x = 50;
			splosion.particleDrag.y = 50;
			splosion.delay = 1;
			splosion.width = width;
			splosion.height = height;
			
			for(var i:Number = 0; i < SPLOSION_PARTICLES; i++) {
				var particle:FlxSprite = new FlxSprite();
				particle.createGraphic(2, 2, 0xffffffff);
				splosion.add(particle);
			}
			
			var s:PlayState = PlayState(FlxG.state);
			s.add(splosion);
		}
		
		override public function render():void {
			if(dead) return;
			super.render();
		}
		
		override public function update():void {			
			var s:PlayState = PlayState(FlxG.state);

			if(dead) {
				if(s.tick > dieTick + DEATH_TIME) {
					respawn();
				} else {
					return;	
				}
			}
			
			// Turn
			if (FlxG.keys.LEFT) {
				angle -= 4;
			} else if(FlxG.keys.RIGHT) {
				angle += 4;
			}
			
			// Move
			if(FlxG.keys.UP) {
				velocity.x += 10 * Math.sin(angle * DEGREES_TO_RADIANS);
				velocity.y -= 10 * Math.cos(angle * DEGREES_TO_RADIANS);
			} else if(FlxG.keys.DOWN) {
				velocity.x -= 10 * Math.sin(angle * DEGREES_TO_RADIANS);
				velocity.y += 10 * Math.cos(angle * DEGREES_TO_RADIANS);
			}
			
			// Shoot
			if(FlxG.keys.X) {
				fire();
			}
			
			super.update();
		}
		
		override public function kill():void {
			if(dead || flickering()) return;
			
			// We are now dead
			dead = true;
			lives--;
			
			// Come to a dead stop
			velocity.x = 0;
			velocity.y = 0;
			
			// Asplode
			dieSound.playCachedMutation(4);
			splosion.x = x;
			splosion.y = y;
			splosion.start();
			
			// Kill the ship, but keep it in existence
			super.kill();
			exists = true;
			
			// Save the tick on which we died
			var s:PlayState = PlayState(FlxG.state);
			dieTick = s.tick;
		}
		
		public function respawn():void {
			if(lives > 0) {
				dead = false;
				flicker(FLICKER_DURATION);
				x = 0;
				y = 0;
				angle = 0;
			}
		}
		
		public function fire():void {
			var s:PlayState = PlayState(FlxG.state);

			// Only fire a bullet if enough ticks have passed
			if(s.tick >= lastFired + RATE_OF_FIRE) {
				shootSound.playCachedMutation(4);
				s.bullets.add(new Bullet(centreX, centreY, angle, velocity));
				lastFired = s.tick;
			}
		}
	}
}