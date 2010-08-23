package net.noiseinstitute.ld18
{
	public class ShipDebris extends LD18Sprite
	{
		[Embed(source="ShipDebris.png")]
		private static const ShipDebris:Class;
		
		private static const ANIMATION_LENGTH:Number = 60;
		
		private var fadeFrame:uint;
		
		public function ShipDebris(x:Number=0, y:Number=0) {
			super(x, y);
			
			loadGraphic(ShipDebris, true);
			addAnimation("0", [0]);
			addAnimation("1", [1]);
			addAnimation("2", [2]);
			addAnimation("3", [3]);
			play(String(Math.random()*4));
			
			angle = Math.random() * Math.PI * 2;
			angularAcceleration = Math.random() * 30;
			
			this.fadeFrame = 0;
		}
		
		override public function update():void {
			fadeFrame++;
			alpha = (ANIMATION_LENGTH - fadeFrame)/ANIMATION_LENGTH;
			super.update();
		}
	}
}