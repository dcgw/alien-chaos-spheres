package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private static const PLAY_AREA_SIZE:Number = 256;
		private static const SAFE_AREA_SIZE:Number = 64;
		private static const NUM_ENEMIES:Number = 10;
		private static const NUM_LIVES:Number = 3;
		
		public var tick:uint;
		private var ship:Ship;
		protected var aliens:FlxGroup;
		public var bullets:FlxGroup;
		public var collidables:FlxGroup;
		
		private var lives:Number;
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void {
			// Setup defalt values
			tick = 0;
			lives = NUM_LIVES;
			
			// Set the bounding box of the world
			FlxU.setWorldBounds(-PLAY_AREA_SIZE*2, -PLAY_AREA_SIZE*2, PLAY_AREA_SIZE*4, PLAY_AREA_SIZE*4);
			
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
				var alien:AlienDeathBall = new AlienDeathBall();
				
				do {
					var ang:Number = Math.random() * 360;
					var dist:Number = (Math.random() * (PLAY_AREA_SIZE - SAFE_AREA_SIZE)) + SAFE_AREA_SIZE;
					alien.x = Math.sin(ang) * dist;
					alien.y = -Math.cos(ang) * dist;
					FlxU.collide(aliens, alien);
					FlxU.overlap(aliens, alien)
				} while(alien.overlaps(aliens));

				aliens.add(alien);
			}
		}
		
		override public function update():void {
			tick++;
			
			var shipDistanceFromCentre:Number = Math.sqrt(ship.x*ship.x + ship.y*ship.y);
			if (shipDistanceFromCentre >= PLAY_AREA_SIZE) {
				var shipAngleFromCentre:Number = Math.atan2(ship.y, ship.x) - Math.PI/2;
				ship.x = -Math.sin(shipAngleFromCentre) * PLAY_AREA_SIZE;
				ship.y = Math.cos(shipAngleFromCentre) * PLAY_AREA_SIZE;
				if (ship.x < 0) {
					if (ship.velocity.x < 0) {
						ship.velocity.x = -ship.velocity.x / 2;
					}
				} else {
					if (ship.velocity.x > 0) {
						ship.velocity.x = -ship.velocity.x / 2;
					}
				}
				if (ship.y < 0) {
					if (ship.velocity.y < 0) {
						ship.velocity.y = -ship.velocity.y / 2;
					}
				} else {
					if (ship.velocity.y > 0) {
						ship.velocity.y = -ship.velocity.y / 2;
					}
				}
			} 
			
			super.update();
			FlxG.follow(ship);
			
			FlxU.overlap(collidables, aliens, overlapped);
		}
		
		protected function overlapped(obj:FlxObject, alien:FlxObject):void {
			if(obj is Ship) {
				ship.kill();
			} else if (obj is Bullet) {
				alien.velocity.x += obj.velocity.x / 10;
				alien.velocity.y += obj.velocity.y / 10;
				obj.kill();
			} else if (obj is AlienDeathBall) {
				obj.kill();
				alien.kill();
			}
		}
	}
}