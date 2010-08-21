package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private static const PLAY_AREA_RADIUS:Number = 128;
		private static const SAFE_AREA_SIZE:Number = 48;
		private static const NUM_ENEMIES:Number = 4;
		private static const GAME_END_TIME:uint = 100;
		private static const SPAWN_INTERVAL:uint = 500;
		
		[Embed(source="Heart.png")] public static const HeartGraphic:Class; 
		
		public var tick:uint;
		public var gameEndTick:uint;

		// Sprites
		private var ship:Ship;
		protected var aliens:FlxGroup;
		public var bullets:FlxGroup;
		public var collidables:FlxGroup;
		
		// Sound effects
		private var alienDieSound:SfxrSynth;
		private var alienSpawnSound:SfxrSynth;
		
		// HUD Elements
		private var score:FlxText;
		private var lives:FlxGroup;
		
		override public function create():void {
			// Setup defalt values
			tick = 0;
			gameEndTick = 0;
			
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
				spawnAlien();
			}
			
			// Alien death sound
			alienDieSound = new SfxrSynth();
			alienDieSound.setSettingsString("3,,0.303,0.461,0.4565,0.148,,-0.3558,,,,,,,,,0.5001,-0.0673,1,,,,,0.5");
			alienDieSound.cacheMutations(4);
			
			// Alien spawn sound
			alienSpawnSound = new SfxrSynth();
			alienSpawnSound.setSettingsString("0,,0.3551,,0.6399,0.25,,-0.1,,,,,,0.0409,,0.1199,,,0.3499,,0.2,,,0.68");
			alienSpawnSound.cacheSound();
			
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
		}
		
		public function spawnAlien():void {
			var alien:AlienDeathBall = new AlienDeathBall();
			if (alienSpawnSound != null) {
				alienSpawnSound.playCached();
			}
			
			do {
				var ang:Number = Math.random() * Math.PI*2;
				var dist:Number = (Math.random() * (PLAY_AREA_RADIUS - SAFE_AREA_SIZE - alien.width/2)) + SAFE_AREA_SIZE;
				alien.x = Math.sin(ang) * dist;
				alien.y = -Math.cos(ang) * dist;
			} while(FlxU.overlap(alien, aliens, function ():Boolean {return true;}));
			
			aliens.add(alien);
		}
		
		override public function update():void {
			tick++;
			
			// Spawn aliens at an interval
			if(tick % SPAWN_INTERVAL == 0) {
				spawnAlien();
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
				var distanceFromCentre:Number = Math.sqrt(bullet.centreX*bullet.centreX + bullet.centreY*bullet.centreY);

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
		
		protected function overlapped(obj:FlxObject, alien:FlxObject):void {
			if(obj is Ship && !obj.dead) {
				// Destroy the ship
				ship.kill();
				lives.remove(lives.members[ship.lives]);
				gameEndTick = tick;
			} else if (obj is Bullet) {
				alien.velocity.x += obj.velocity.x / 10;
				alien.velocity.y += obj.velocity.y / 10;
				obj.kill();
			} else if (obj is AlienDeathBall) {
				// Destroy the two
				alienDieSound.playCachedMutation(4);
				obj.kill();
				alien.kill();
				
				// Score some points
				FlxG.score += AlienDeathBall(alien).pointValue;
				FlxG.score += AlienDeathBall(obj).pointValue;
			}
		}
	}
}