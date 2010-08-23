package net.noiseinstitute.ld18
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.*;
	
	public class Ship extends LD18Sprite
	{
		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
		private static const RATE_OF_FIRE:uint = 10;
		private static const DEATH_TIME:uint = 100;
		private static const FLICKER_DURATION:Number = 3;
		private static const DEBRIS_PARTICLES:Number = 24;
		private static const NUM_LIVES:Number = 3;
		private static const THRUST:Number = 7;
		
		public var lives:Number;
		
		[Embed(source="ship.png")] public static const ShipGraphic:Class; 

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
				velocity.x += THRUST * Math.sin(angle * DEGREES_TO_RADIANS);
				velocity.y -= THRUST * Math.cos(angle * DEGREES_TO_RADIANS);
			} else if(FlxG.keys.DOWN) {
				velocity.x -= THRUST * Math.sin(angle * DEGREES_TO_RADIANS);
				velocity.y += THRUST * Math.cos(angle * DEGREES_TO_RADIANS);
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
			asplode();
			
			// Kill the ship, but keep it in existence
			super.kill();
			exists = true;
			
			// Save the tick on which we died
			var s:PlayState = PlayState(FlxG.state);
			dieTick = s.tick;
		}
		
		private function asplode():void {
			Game.sound.shipDie.playCachedMutation(4);
			
			var s:PlayState = PlayState(FlxG.state);
			
			// Set up the asplosion
			var splosion:PlayerSplosion = new PlayerSplosion(centreX, centreY);
			s.playerGroup.add(splosion);
			var timer:Timer = new Timer(5000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function ():void {
				s.playerGroup.remove(splosion);
			});
			timer.start();
			
			// Set up the debris
			var debrisEmitter:FlxEmitter;
			debrisEmitter = new FlxEmitter(0,0); 
			debrisEmitter.gravity = 0;
			debrisEmitter.particleDrag.x = 50;
			debrisEmitter.particleDrag.y = 50;
			debrisEmitter.delay = 1;
			debrisEmitter.width = width;
			debrisEmitter.height = height;
			
			for(var i:Number = 0; i < DEBRIS_PARTICLES; i++) {
				var particle:ShipDebris = new ShipDebris();
				debrisEmitter.add(particle);
			}
			
			s.debris.add(debrisEmitter);
			
			debrisEmitter.x = x;
			debrisEmitter.y = y;
			debrisEmitter.start();
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
				Game.sound.shipShoot.playCachedMutation(4);
				s.bullets.add(new Bullet(centreX, centreY, angle, velocity));
				lastFired = s.tick;
			}
		}
	}
}