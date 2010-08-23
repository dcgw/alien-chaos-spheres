package net.noiseinstitute.ld18
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import org.flixel.*;
	
	public class SpawnPoint extends LD18Sprite
	{
		private static const START_RADIUS:Number = 256;
		private static const END_RADIUS:Number = 12;
		private static const COLOUR:uint = 0xff6464;
		private static const ANIMATION_LENGTH:uint = 60;
		
		private var drawSprite:Sprite;
		
		public function SpawnPoint(x:Number=0, y:Number=0)
		{
			super(x, y);
			width = END_RADIUS*2;
			height = END_RADIUS*2;
			centreX = x;
			centreY = y;
			
			drawSprite = new Sprite();
			frame = 0;
		}
		
		override public function getScreenXY(point:FlxPoint=null):FlxPoint {
			if(point == null) point = new FlxPoint();
			point.x = x + FlxG.scroll.x*scrollFactor.x - offset.x;
			point.y = y + FlxG.scroll.y*scrollFactor.y - offset.y;
			return point;
		}
		
		override public function update():void {
			--angle;
			++frame;
			super.update();
		}
		
		override public function render():void {
			var graphics:Graphics = drawSprite.graphics;
			graphics.clear();
			graphics.lineStyle(1, COLOUR, frame/ANIMATION_LENGTH);
			graphics.drawCircle(0, 0, Math.max(END_RADIUS + (START_RADIUS-END_RADIUS) * (ANIMATION_LENGTH-frame)/ANIMATION_LENGTH, END_RADIUS));
			graphics.drawCircle(0, 0, Math.min(END_RADIUS * frame/ANIMATION_LENGTH, END_RADIUS));

			getScreenXY(_point);
			_mtx.identity();
			if(angle != 0) {
				_mtx.rotate(Math.PI * 2 * (angle / 360));
			}
			_mtx.translate(_point.x+END_RADIUS,_point.y+END_RADIUS);
			FlxG.buffer.draw(drawSprite, _mtx);
		}		
	}
}