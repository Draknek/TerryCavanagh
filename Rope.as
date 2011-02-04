package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Rope extends Entity
	{
		public var p1:Player;
		public var p2:Player;
		
		public var length:Number = 250;
		public var lengthSq:Number = length*length;
		
		public function Rope (_p1:Player, _p2:Player)
		{
			p1 = _p1;
			p2 = _p2;
		}
		
		public override function update (): void
		{
			x = (p1.x + p2.x)*0.5;
			y = (p1.y + p2.y)*0.5;
			
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
				
				p1.vx += dx * force;
				p1.vy += dy * force;
				
				p2.vx -= dx * force;
				p2.vy -= dy * force;
			}
		}
		
		public override function render (): void
		{
			Draw.line(p1.x, p1.y, p2.x, p2.y, 0xFFFFFF);
		}
	}
}

