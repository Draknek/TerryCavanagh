package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.geom.*;
	
	public class WebStrand extends Entity
	{
		public var p1:Point;
		public var p2:Point;
		
		public var start1:Point;
		public var start2:Point;
		
		public var length:Number;
		public var lengthSq:Number;
		
		public function WebStrand (_p1:Point, _p2:Point)
		{
			p1 = _p1;
			p2 = _p2;
			
			start1 = p1.clone();
			start2 = p2.clone();
			
			layer = -8;
			
			length = Point.distance(p1, p2);
			
			lengthSq = length*length
		}
		
		public override function update (): void
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			var dzSq:Number = dx*dx + dy*dy;
			var dz:Number;
			
			if (dzSq > lengthSq) {
				dz = Math.sqrt(dzSq);
				
				var force:Number = dz - length;
				
				force *= 0.01;
				
				dx /= dz;
				dy /= dz;
				
				p1.x += dx * force;
				p1.y += dy * force;
				
				p2.x -= dx * force;
				p2.y -= dy * force;
			}
			
			force = 0.1 * FP.random;
			
			p1.x += (start1.x - p1.x) * force;
			p1.y += (start1.y - p1.y) * force;
			
			p2.x += (start2.x - p2.x) * force;
			p2.y += (start2.y - p2.y) * force;
		}
		
		public override function render (): void
		{
			var c:uint = 0xFFFFFF;
			
			Draw.linePlus(p1.x, p1.y, p2.x, p2.y, c);
		}
	}
}

