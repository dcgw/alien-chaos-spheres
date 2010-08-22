package net.noiseinstitute.ld18
{
	import flash.display.Sprite;
	
	import org.flixel.*;
	
	public class Arena extends LD18Sprite
	{
		private var circle:Sprite;
		private var _radius:Number;
		private var lastDrawnRadius:Number;
		
		public function Arena(radius:Number)
		{
			super(0, 0);
			circle = new Sprite();
			this.radius = radius;
			antialiasing = true;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(radius:Number):void {
			_radius = radius;
			width = radius*2;
			height = radius*2;
			centreX = 0;
			centreY = 0;
		}
		
		private function redrawCircleIfNecessary():void {
			if (_radius != lastDrawnRadius) {
				circle.graphics.clear();
				circle.graphics.lineStyle(1, 0xd7d7d7);
				circle.graphics.drawCircle(_radius, _radius, _radius);
				lastDrawnRadius = _radius;
			}
		}
		
		override public function update():void {
			++angle;
			super.update();
		}
		
		override public function getScreenXY(point:FlxPoint=null):FlxPoint {
			if(point == null) point = new FlxPoint();
			point.x = x + FlxG.scroll.x*scrollFactor.x - offset.x;
			point.y = y + FlxG.scroll.y*scrollFactor.y - offset.y;
			return point;
		}
		
		override public function render():void {
			redrawCircleIfNecessary();
			
			getScreenXY(_point);
			_mtx.identity();
			_mtx.translate(-_radius, -_radius);
			if(angle != 0) {
				_mtx.rotate(Math.PI * 2 * (angle / 360));
			}
			_mtx.translate(_point.x+_radius,_point.y+_radius);
			FlxG.buffer.draw(circle, _mtx);
		}
	}
}