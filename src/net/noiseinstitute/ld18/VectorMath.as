package net.noiseinstitute.ld18
{
	import org.flixel.FlxPoint;

	public class VectorMath
	{
		public static function add(v1:FlxPoint, v2:FlxPoint):FlxPoint {
			return new FlxPoint(v1.x+v2.x, v1.y+v2.y);
		}
		
		public static function subtract(v1:FlxPoint, v2:FlxPoint):FlxPoint {
			return new FlxPoint(v1.x-v2.x, v1.y-v2.y);
		}
		
		public static function dotProduct(v1:FlxPoint, v2:FlxPoint):Number {
			return v1.x*v2.x + v1.y*v2.y;
		}
		
		public static function crossProduct(v1:FlxPoint, v2:FlxPoint):Number {
			return v1.x*v2.y - v1.y*v2.x;
		}
		
		public static function multiply(v:FlxPoint, s:Number):FlxPoint {
			return new FlxPoint(v.x*s, v.y*s);
		}
		
		public static function unitVector(angle:Number):FlxPoint {
			return new FlxPoint(Math.sin(angle), -Math.cos(angle));
		}
		
		public static function addScalar(v:FlxPoint, s:Number):FlxPoint {
			return new FlxPoint(v.x+s, v.y+s);
		}
		
		public static function negate(v:FlxPoint):FlxPoint {
			return new FlxPoint(-v.x, -v.y);
		}
		
		public static function magnitude(v:FlxPoint):Number {
			return Math.sqrt(v.x*v.x + v.y*v.y);
		}
		
		public static function normalize(v:FlxPoint):FlxPoint {
			var m:Number = magnitude(v);
			return new FlxPoint(v.x/m, v.y/m);
		}
		
		public static function distance(v1:FlxPoint, v2:FlxPoint):Number {
			return magnitude(subtract(v1, v2));
		}
	}
}