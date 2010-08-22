package net.noiseinstitute.ld18
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private static const PLAY_AREA_RADIUS:Number = 128;
		private static const SAFE_AREA_SIZE:Number = 48;
		private static const NUM_ENEMIES:Number = 4;
		private static const GAME_END_TIME:uint = 100;
		private static const INITIAL_SPAWN_INTERVAL:uint = 500;
		private static const MIN_SPAWN_INTERVAL:uint = 20;
		private static const MULTIPLIER_BASE_VALUE:uint = 300;
		
		public var tick:uint;
		public var gameEndTick:uint;
		public var spawnInterval:uint;

		// Sprites
		private var ship:Ship;
		protected var aliens:FlxGroup;
		public var bullets:FlxGroup;
		public var collidables:FlxGroup;
		
		// HUD Elements
		private var score:FlxText;
		private var lives:FlxGroup;
		
		private var multiplier:uint;
		
		override public function create():void {
			// Setup defalt values
			tick = 0;
			gameEndTick = 0;
			spawnInterval = INITIAL_SPAWN_INTERVAL;
			
			// Set the bounding box of the world
			FlxU.setWorldBounds(-PLAY_AREA_RADIUS*2, -PLAY_AREA_RADIUS*2, PLAY_AREA_RADIUS*4, PLAY_AREA_RADIUS*4);
			
			// Create background graphic
			var background:Background = new Background(-PLAY_AREA_RADIUS*4, -PLAY_AREA_RADIUS*2,
						PLAY_AREA_RADIUS*8, PLAY_AREA_RADIUS*4);
			background.scrollFactor.x = 0.5;
			background.scrollFactor.y = 0.5;
			background.angle = 32;
			add(background);
			
			// Create arena boundary graphic
			add(new Arena());
			
			// Create some alien death balls
			aliens = new FlxGroup();
			add(aliens);

			// Create a group for bullets
			bullets = new FlxGroup();
			add(bullets);

			// Create the ship
			ship = new Ship();
			add(ship);

			// Collisions group
			collidables = new FlxGroup();
			collidables.add(aliens);
			collidables.add(bullets);
			collidables.add(ship);

			// Position the aliens randomly
			for(var i:Number = 0; i < NUM_ENEMIES; i++) {
				spawnAlien(true);
			}
			
			// HUD
			var fixed:FlxPoint = new FlxPoint(0,0);
			
			score = new FlxText(0, FlxG.height - 30, FlxG.width / 3);
			score.color = 0xd8eba2;
			score.size = 16;
			score.alignment = "center";
			score.scrollFactor = fixed;
			score.shadow = 0x131c1b;
			add(score);
			
			lives = new FlxGroup();
			add(lives);
			var xpos:Number = FlxG.width - 30;
			for(var l:Number = 0; l < 3; l++) {
				var heart:FlxSprite = new FlxSprite(xpos, FlxG.height - 30, Ship.ShipGraphic);
				heart.width = 16;
				heart.height = 16;
				xpos -= 20;
				heart.scrollFactor = fixed;
				lives.add(heart);
			}
			
			multiplier = MULTIPLIER_BASE_VALUE;
		}
		
		public function spawnAlien(safeArea:Boolean):void {
			var spawnPoint:SpawnPoint = new SpawnPoint();
			if (tick > 0) {
				Game.sound.alienSpawn.playCached();
			}
			
			do {
				var ang:Number = Math.random() * Math.PI*2;
				var dist:Number;
				
				if(safeArea) {
					dist = (Math.random() * (PLAY_AREA_RADIUS - SAFE_AREA_SIZE - spawnPoint.width/2)) + SAFE_AREA_SIZE;
				} else {
					dist = Math.random() * (PLAY_AREA_RADIUS - spawnPoint.width/2);
				}
				
				spawnPoint.centreX = Math.sin(ang) * dist;
				spawnPoint.centreY = -Math.cos(ang) * dist;
			} while(FlxU.overlap(spawnPoint, aliens, function ():Boolean {return true;}));
			
			aliens.add(spawnPoint);
			
			var timer:Timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function ():void {
				var alien:AlienDeathBall = new AlienDeathBall(spawnPoint.centreX, spawnPoint.centreY);
				aliens.add(alien);
				spawnPoint.kill();
			});
			timer.start();
		}
		
		override public function update():void {
			tick++;
			
			if (multiplier > MULTIPLIER_BASE_VALUE) {
				--multiplier;
			}
			
			trace(multiplier);
			
			// Spawn aliens at an interval
			if(tick % spawnInterval == 0) {
				spawnAlien(false);
				spawnInterval = Math.max(MIN_SPAWN_INTERVAL, spawnInterval - 10);
			}
			
			// Check if the game is over
			if(ship.lives == 0 && tick >= gameEndTick + GAME_END_TIME) {
				FlxG.state = new GameOverState();
			}
			
			// Bounce the ship and aliens off the edge
			bounceOffEdge(ship);
			var i:Number;
			for(i = 0; i < aliens.members.length; i++) {
				bounceOffEdge(LD18Sprite(aliens.members[i]));
			}
			
			// Kill bullets that hit the edge
			for(i = 0; i < bullets.members.length; i++) {
				var bullet:Bullet = bullets.members[i];
				var distanceFromCentre:Number = VectorMath.magnitude(bullet.centre);

				if(distanceFromCentre >= PLAY_AREA_RADIUS) {
					bullet.kill();
				}
			}
			
			// Update the HUD
			var strScore:String = FlxG.score.toString();
			while(strScore.length < 6) strScore = "0" + strScore;
			score.text = strScore;

			// Perform the standard update
			super.update();
			
			// Move the camera
			FlxG.follow(ship);
			
			// Collide things
			FlxU.overlap(collidables, aliens, overlapped);
		}
		
		public function bounceOffEdge(obj:LD18Sprite):void {
			var distanceFromCentre:Number = Math.sqrt(obj.centreX*obj.centreX + obj.centreY*obj.centreY);
			
			if (distanceFromCentre + obj.width/2 >= PLAY_AREA_RADIUS) {
				var angleFromCentre:Number = Math.atan2(obj.centreY, obj.centreX) - Math.PI/2;
				obj.centreX = -Math.sin(angleFromCentre) * (PLAY_AREA_RADIUS - obj.width/2);
				obj.centreY = Math.cos(angleFromCentre) * (PLAY_AREA_RADIUS - obj.width/2);
				
				var normal:FlxPoint = VectorMath.unitVector(angleFromCentre + Math.PI+Math.PI);
				var uMag:Number = VectorMath.dotProduct(normal, obj.velocity);
				var u:FlxPoint = VectorMath.multiply(normal, uMag);
				obj.velocity = VectorMath.subtract(obj.velocity, VectorMath.multiply(u, 2));
			} 
		}
		
		protected function overlapped(obj1:LD18Sprite, obj2:LD18Sprite):void {
			if (obj2 is AlienDeathBall) {
				var alien:AlienDeathBall = AlienDeathBall(obj2);
				if(obj1 is Ship && !obj1.dead) {
					if (VectorMath.distance(obj1.centre, alien.centre) < (obj1.width*0.3 + alien.width*0.5)) {
						// Destroy the ship
						FlxG.quake.start(0.003, 0.5);
						ship.kill();
						lives.remove(lives.members[ship.lives]);
						gameEndTick = tick;
						
						// Penalize the point value of the alien
						alien.penalize();
						
						// Reset the multiplier
						multiplier = MULTIPLIER_BASE_VALUE;
					}
				} else if (obj1 is Bullet) {
					var bulletToAlien:FlxPoint = VectorMath.subtract(alien.centre, obj1.centre);
					var distance:Number = VectorMath.magnitude(bulletToAlien);
					if (distance < (1 + alien.width*0.5)) {
						var bulletToAlienUnitVector:FlxPoint = VectorMath.normalize(bulletToAlien);
						var projectedBulletSpeed:Number = VectorMath.dotProduct(obj1.velocity, bulletToAlienUnitVector);
						var projectedBulletVelocity:FlxPoint = VectorMath.multiply(bulletToAlienUnitVector, projectedBulletSpeed);
						var alienVelocityChange:FlxPoint = VectorMath.multiply(projectedBulletVelocity, 0.1);
						alien.velocity = VectorMath.add(alien.velocity, alienVelocityChange);
						obj1.kill();
					}
				} else if (obj1 is AlienDeathBall) {
					if (VectorMath.distance(obj1.centre, alien.centre) < (obj1.width)) {
						// Destroy the two
						Game.sound.alienDie.playCachedMutation(4);
						obj1.kill();
						alien.kill();
						
						// Score some points. Woot.
						FlxG.score += AlienDeathBall(alien).pointValue * multiplier / MULTIPLIER_BASE_VALUE;
						FlxG.score += AlienDeathBall(obj1).pointValue * multiplier / MULTIPLIER_BASE_VALUE;
						
						multiplier+=300;
					}
				}
			}
		}
	}
}