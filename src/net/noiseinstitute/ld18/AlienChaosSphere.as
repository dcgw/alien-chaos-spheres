package net.noiseinstitute.ld18
{
	import flash.events.*;
	import flash.utils.*;
	
	import org.flixel.*;

	public class AlienChaosSphere extends ThingThatScores {

		private static const DEBRIS_PARTICLES:Number = 40;
		private static const MAX_SINUS_VELOCITY:Number = Math.PI/90;
		private static const MAX_ROTATION_LIMIT:Number = 45;
		private static const MIN_POINT_VALUE:Number = 100;
		private static const LEVEL_COLOURS:Array = new Array(0xffff0000, 0xff0000ff, 0xffff00ff, 0xff00ffff);
		private static const CHAIN_REACTION_TIME:uint = 100;
		
		protected var splosion:FlxEmitter;
		protected var sinusVelocity:Number;
		protected var sinusPosition:Number;
		protected var angleLimit:Number;
		protected var level:Number;
	
		public function AlienChaosSphere(x:Number, y:Number, lvl:Number, image:Class) {
			super(x, x, image);

			centreX = x;
			centreY = y;
			solid = true;
			_pointValue = 1000;
			setLevel(lvl);
			
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
			
			for(var i:Number = 0; i < DEBRIS_PARTICLES; i++) {
				var particle:FlxSprite = new AlienDebris();
				particle.createGraphic(2, 2, 0xffaa0000);
				splosion.add(particle);
			}
			
			if (FlxG.state is PlayState) {
				var s:PlayState = PlayState(FlxG.state);
				s.debris.add(splosion);
			}
		}

		override public function kill():void {
			var s:PlayState = PlayState(FlxG.state);
			
			Game.sound.alienDie.playCachedMutation(4);
			velocity.x = 0;
			velocity.y = 0;
			splosion.x = x;
			splosion.y = y;
			splosion.start();
			super.kill();
			
			
			//s.aliens.remove(this, true);
			
			// Thingy	
		}

		public function asplode(cause:ThingThatScores):AlienSplosion {
			var splosion:AlienSplosion = new AlienSplosion(centreX, centreY);
			splosion.chainMultiplier = cause.chainMultiplier + 1;
			splosion.pointValue = pointValue;
			
			var timer:Timer = new Timer(CHAIN_REACTION_TIME, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function ():void {
				splosion.dead = true;
			});
			timer.start();
			
			return splosion;
		}
		
		public function setLevel(lvl:Number):void {
			health = Math.max(0, Math.min(lvl, LEVEL_COLOURS.length - 1));
			color = LEVEL_COLOURS[health];
		}

		override public function hurt(dmg:Number):void {
			super.hurt(dmg);
			//setLevel(Math.max(0, level - dmg));
			color = LEVEL_COLOURS[health];			
		}

		override public function update():void {
			var s:PlayState = PlayState(FlxG.state);
			sinusPosition += sinusVelocity;
			angle = Math.sin(sinusPosition) * angleLimit;
			if(_pointValue > MIN_POINT_VALUE) _pointValue--;
			super.update();
		}
		
		override public function get pointValue():Number {
			var speed:Number = VectorMath.magnitude(velocity);
			var multiplier:Number = (speed / 100.0) + 1;
			return _pointValue * multiplier * 0.1;
		}
		
		public function penalize():void {
			_pointValue /= 2;
		}
	}
}