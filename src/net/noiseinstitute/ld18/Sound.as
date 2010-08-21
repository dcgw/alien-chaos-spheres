package net.noiseinstitute.ld18
{
	public class Sound {
		
		public var alienDie:SfxrSynth;
		public var alienSpawn:SfxrSynth;
		public var shipShoot:SfxrSynth;
		public var shipDie:SfxrSynth;
		public var menuBlip:SfxrSynth;
		
		private var progress:Number;
		
		public function Sound() {
			progress = -1;
		}
		
		public function loadNext():Boolean {
			progress++;
			switch(progress) {
				case 0:
					// Alien death sound
					alienDie = new SfxrSynth();
					alienDie.setSettingsString("3,,0.303,0.461,0.4565,0.148,,-0.3558,,,,,,,,,0.5001,-0.0673,1,,,,,0.5");
					alienDie.cacheMutations(4);
					return false;
				case 1:
					// Alien spawn sound
					alienSpawn = new SfxrSynth();
					alienSpawn.setSettingsString("0,,0.3551,,0.6399,0.25,,-0.1,,,,,,0.0409,,0.1199,,,0.3499,,0.2,,,0.68");
					alienSpawn.cacheSound();
					return false;
				case 2:
					// The sound to play when shooting
					shipShoot = new SfxrSynth();
					shipShoot.setSettingsString("0,,0.1564,0.2223,0.2657,0.7463,0.2,-0.3115,,,,,,0.1768,0.0694,,0.1957,-0.139,1,,,0.2701,,0.5");
					shipShoot.cacheMutations(4);
					return false;
				case 3:
					// The sound to play on death
					shipDie = new SfxrSynth();
					shipDie.setSettingsString("3,,0.3926,0.6813,0.2557,0.0716,,,,,,0.1538,0.822,,,,,,1,,,,,0.5");
					shipDie.cacheMutations(4);
					return false;
				case 4:
					// The sound to play on death
					menuBlip = new SfxrSynth();
					menuBlip.setSettingsString("0,,0.1366,,0.0834,0.4391,,,,,,,,0.5536,,,,,1,,,0.1,,0.43");
					menuBlip.cacheSound();
					return false;
				default:
					return true;
			}
		}
	}
}