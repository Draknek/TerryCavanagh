package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.geom.*;
	
	public class Rope extends Entity
	{
		public var p1:Player;
		public var p2:Point;
		
		public var length:Number = 150;
		public var maxLength:Number = 300;
		public var lengthSq:Number = length*length;
		
		public var web:WebStrand;
		public var webT:Number;
		
		public function Rope (_p1:Player, _web:WebStrand)
		{
			web = _web;
			
			webT = Math.random()*0.8 + 0.1;
			
			p1 = _p1;
			p2 = new Point;
			p2.x = FP.lerp(web.p1.x, web.p2.x, webT);
			p2.y = FP.lerp(web.p1.y, web.p2.y, webT);
			
			p1.rope = this;
			
			layer = -9;
		}
		
		public override function update (): void
		{
			p2.x = FP.lerp(web.p1.x, web.p2.x, webT);
			p2.y = FP.lerp(web.p1.y, web.p2.y, webT);
			
			if (! p1.active) return;
			
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
				
				if (Input.pressed(Key.SPACE)) {
					force *= 5;
					dx += (FP.random - 0.5) * 0.2;
				}
				
				p1.vx += dx * force;
				p1.vy += dy * force;
				
				force *= 0.5;
				
				Level(world).applyForceToWeb(p2, dx, dy, force);
			}
			
			p2.x = FP.lerp(web.p1.x, web.p2.x, webT);
			p2.y = FP.lerp(web.p1.y, web.p2.y, webT);
		}
		
		public override function render (): void
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			var dzSq:Number = dx*dx + dy*dy;
			var dz:Number = Math.sqrt(dzSq);
			
			dx /= dz;
			dy /= dz;
			
			x = (p1.x + p2.x)*0.5;
			y = (p1.y + p2.y)*0.5;
			
			var renderLength:Number = FP.lerp(length, maxLength, 0.5);
			
			if (renderLength < dz) {
				var c:uint = 0xFFFFFF;
				
				Draw.linePlus(p1.x, p1.y, p2.x, p2.y, c);
			} else {
				var extra:Number = renderLength - dz;
				Draw.curve(p1.x, p1.y, x, y + extra, p2.x, p2.y, 0xFFFFFF);
			}
		}
	}
}

