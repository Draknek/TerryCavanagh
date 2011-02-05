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
		
		public var maxLength:Number = 600;
		
		public var snapped:Boolean = false;
		
		public function Rope (_p1:Player, _p2:Player)
		{
			p1 = _p1;
			p2 = _p2;
			
			layer = -9;
		}
		
		public override function update (): void
		{
			x = (p1.x + p2.x)*0.5;
			y = (p1.y + p2.y)*0.5;
			
			if (snapped) {
				y = Math.min(p1.y, p2.y);
				return;
			}
			
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
				
				if (dz > maxLength) {
					snapped = true;
				}
				
				p1.vx += dx * force;
				p1.vy += dy * force;
				
				p2.vx -= dx * force;
				p2.vy -= dy * force;
			}
		}
		
		public override function render (): void
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			var dzSq:Number = dx*dx + dy*dy;
			var dz:Number = Math.sqrt(dzSq);
			
			dx /= dz;
			dy /= dz;
			
			if (snapped) {
				Draw.line(p1.x, p1.y, p1.x + dx*maxLength*0.5, p1.y + dy*maxLength*0.5, 0x0);
				Draw.line(p2.x, p2.y, p2.x - dx*maxLength*0.5, p2.y - dy*maxLength*0.5, 0x0);
				return;
			}
			
			x = (p1.x + p2.x)*0.5;
			y = (p1.y + p2.y)*0.5;
			
			if (length < dz) {
				var t:Number = (dz - length) / (maxLength - length);
				if (t > 1) t = 1;
				t = 1 - t;
				var c:uint = FP.getColorRGB(t*255, t*255, t*255);
				Draw.linePlus(p1.x, p1.y, p2.x, p2.y, c);
			} else {
				var extra:Number = length - dz;
				Draw.curve(p1.x, p1.y, x, y + extra, p2.x, p2.y, 0xFFFFFF);
			}
		}
	}
}

