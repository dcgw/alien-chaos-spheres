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
		private static const INITIAL_NUM_ENEMIES:Number = 2;
		private static const GAME_END_TIME:uint = 100;
		private static const INITIAL_SPAWN_INTERVAL:uint = 500;
		private static const MIN_SPAWN_INTERVAL:uint = 20;
		private static const MULTIPLIER_BASE_VALUE:uint = 300;
		private static const INCREASE_MIN_ENEMIES_INTERVAL:uint = 2400; 
		
		public var tick:uint;
		private var gameEndTick:uint;
		private var spawnInterval:uint;

		// Sprites
		private var ship:Ship;
		protected var aliens:FlxGroup;
		public var bullets:FlxGroup;
		private var collidables:FlxGroup;
		public var splosions:FlxGroup;
		
		// HUD Elements
		private var score:FlxText;
		private var lives:FlxGroup;
		
		// Gameplay state
		private var multiplier:uint;
		private var minEnemies:uint;
		
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
			add(new Arena(PLAY_AREA_RADIUS));
			
			// Create a group for bullets
			bullets = new FlxGroup();
			add(bullets);
			
			// Create group to contain alien death balls and their spawners
			aliens = new FlxGroup();
			add(aliens);

			// Create group to contain splosions, but don't add it yet.
			splosions = new FlxGroup();
			
			// Create the ship
			ship = new Ship();
			add(ship);
			
			// Add splosions group last, so it appears above other sprites
			add(splosions);

			// Collisions group
			collidables = new FlxGroup();
			collidables.add(aliens);
			collidables.add(bullets);
			collidables.add(ship);

			// Position the aliens randomly
			minEnemies = INITIAL_NUM_ENEMIES;
			spawnAliens(minEnemies, true);
			
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
		
		private function spawnAliens(count:uint=1, safeArea:Boolean=false):void {
			Game.sound.alienSpawn.playCached();
			
			function spawnAlien():void {
				var spawnPoint:SpawnPoint = new SpawnPoint();
				var i:uint = 0;
				var overlapping:Boolean;
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
					
					overlapping = FlxU.overlap(spawnPoint, aliens, function ():Boolean {return true;})
					++i;
				} while(overlapping && i<3);
				
				if (!overlapping) {
					aliens.add(spawnPoint);
					
					var timer:Timer = new Timer(1000, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, function ():void {
						var alien:AlienDeathBall = new AlienDeathBall(spawnPoint.centreX, spawnPoint.centreY);
						aliens.add(alien);
						spawnPoint.kill();
						aliens.remove(spawnPoint, true);
					});
					timer.start();
				}
			}
			
			for (var i:uint=0; i<count; ++i) {
				spawnAlien();
			}
		}
		
		override public function update():void {
			tick++;
			
			if (multiplier > MULTIPLIER_BASE_VALUE) {
				--multiplier;
			}
			
			// Spawn aliens at an interval
			if(tick % spawnInterval == 0) {
				spawnAliens(1, false);
				spawnInterval = Math.max(MIN_SPAWN_INTERVAL, spawnInterval - 10);
			}
			
			// Periodically increase the minimum number of aliens
			if (tick % INCREASE_MIN_ENEMIES_INTERVAL === 0) {
				minEnemies = Math.max(minEnemies+1);
			}
			
			// If there aren't enough aliens (or spawners) on screen, spawn more,
			// and increase the player's multiplier as a reward.
			if (aliens.countLiving() < minEnemies) {
				spawnAliens(minEnemies - aliens.countLiving(), false);
				multiplier += MULTIPLIER_BASE_VALUE;
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
				if (bullet !== null) {
					var distanceFromCentre:Number = VectorMath.magnitude(bullet.centre);
	
					if(distanceFromCentre >= PLAY_AREA_RADIUS) {
						bullet.kill();
						bullets.remove(bullet, true);
					}
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
			
			// Cull dead splosions
			splosions.members.forEach(function (splosion:FlxObject, index:int, array:Array):void {
				if (splosion === null || splosion.dead) {
					splosions.remove(splosion, true);
				}
			});
			
			// Uncomment to check for leaks
			/*trace("dead aliens " + aliens.countDead());
			trace("dead bullets " + bullets.countDead());
			trace("dead collidables " + collidables.countDead());
			trace("null aliens " + (aliens.members.length - Math.max(0, aliens.countLiving())));
			trace("null bullets " + (bullets.members.length - Math.max(0, bullets.countLiving())));*/
			trace("live splosions " + splosions.countLiving());
			trace("dead splosions " + splosions.countDead());
			trace("null splosions " + (splosions.members.length - Math.max(0, splosions.countLiving())));
		}
		
		public function bounceOffEdge(obj:LD18Sprite):void {
			if (obj !== null) {
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
		}
		
		protected function overlapped(obj1:LD18Sprite, obj2:LD18Sprite):void {
			if (obj2 is AlienDeathBall) {
				var alien:AlienDeathBall = AlienDeathBall(obj2);
				if(obj1 is Ship && !obj1.dead) {
					if (VectorMath.distance(obj1.centre, alien.centre) < (obj1.width*0.3 + alien.width*0.5)) {
						// Destroy the ship
						FlxG.quake.start(0.003, 0.5);
						ship.kill();
						lives.remove(lives.members[ship.lives], true);
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
						bullets.remove(obj1, true);
					}
				} else if (obj1 is AlienDeathBall) {
					if (VectorMath.distance(obj1.centre, alien.centre) < (obj1.width)) {
						// Destroy the two
						Game.sound.alienDie.playCachedMutation(4);
						obj1.kill();
						aliens.remove(obj1, true);
						alien.kill();
						aliens.remove(alien ,true);
						
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