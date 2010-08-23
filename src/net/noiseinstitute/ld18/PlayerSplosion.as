package net.noiseinstitute.ld18
{
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import org.flixel.*;

	public class PlayerSplosion extends LD18Sprite
	{
		private static const START_RADIUS:Number = 8;
		private static const END_RADIUS:Number = 16;
		private static const COLOUR:uint = 0xffffff;
		private static const START_ALPHA:Number = 1
		private static const ANIMATION_LENGTH:uint = 30;
		
		private var drawSprite:Sprite;
		
		private var _pointValue :Number;
		
		public function PlayerSplosion(x:Number=0, y:Number=0) {
			super(x, y);
			width = START_RADIUS*2;
			height = START_RADIUS*2;
			centreX = x;
			centreY = y;
			_pointValue = 0;
			
			drawSprite = new Sprite();
			frame = 0;
		}
		
		override public function update():void {
			++frame;
			super.update();
		}
		
		override public function render():void {
			var graphics:Graphics = drawSprite.graphics;
			graphics.clear();
			graphics.beginFill(COLOUR, START_ALPHA - (frame * START_ALPHA / ANIMATION_LENGTH));
			graphics.drawCircle(0, 0, END_RADIUS + (START_RADIUS-END_RADIUS) * (ANIMATION_LENGTH-frame)/ANIMATION_LENGTH);
			
			getScreenXY(_point);
			_mtx.identity();
			if(angle != 0) {
				_mtx.rotate(Math.PI * 2 * (angle / 360));
			}
			_mtx.translate(_point.x+START_RADIUS,_point.y+START_RADIUS);
			FlxG.buffer.draw(drawSprite, _mtx, null, BlendMode.ADD);
		}
	}
}