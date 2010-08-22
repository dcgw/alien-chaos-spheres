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
		}
		
		public function set radius(radius:Number):void {
			_radius = radius;
			width = radius;
			height = radius;
			centreX = 0;
			centreY = 0;
		}
		
		private function redrawCircleIfNecessary():void {
			if (_radius != lastDrawnRadius) {
				circle.graphics.clear();
				circle.graphics.lineStyle(1, 0xd7d7d7);
				circle.graphics.drawCircle(_radius/2, _radius/2, _radius);
				lastDrawnRadius = _radius;
			}
		}
		
		override public function render():void {
			redrawCircleIfNecessary();
			
			getScreenXY(_point);
			_mtx.identity();
			_mtx.translate(_point.x,_point.y);
			FlxG.buffer.draw(circle, _mtx);
		}
	}
}