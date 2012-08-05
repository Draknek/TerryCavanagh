package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Player extends Entity
	{
		public var vx: Number = 0;
		public var vy: Number = 0;
		
		public var image:Image;
		public var rope:Rope;
		
		public var scale:Number = 1.0;
		
		public function Player ()
		{
			x = FP.width*0.5 + 5;
			y = FP.width*0.5 + 10;
			
			image = Image.createRect(40, 40, 0xFF0000);
			image.centerOO();
			
			graphic = image;
			
			layer = -10;
		}
		
		public override function update (): void
		{
			x += vx;
			y += vy;
			
			vy += 0.7;
			
			if (vx < -4 || vx > 4) vx *= 0.99;
			//vy *= 0.99;
			
			vx += FP.random * 0.2 - 0.1;
			
			if (x < 50) {
				vx += FP.random * 0.001 * (50 - x);
			}
			
			if (x > FP.width - 50) {
				vx -= FP.random * 0.001 * (x - (FP.width - 50));
			}
			
			if (world.collidePoint("orifice", x, y)) {
				active = false;
				
				Level(world).newPlayer();
				
				var dist:Number = FP.distance(rope.p1.x, rope.p1.y, rope.p2.x, rope.p2.y);
				
				FP.tween(rope, {maxLength: dist + 500 + FP.random*500}, 90);
				FP.tween(this, {scale: 0.0}, 60, {tweener:FP.tweener});
			}
		}
		
		public override function render (): void
		{
			if (scale == 0.0) visible = false;
			
			var dx:Number = x - rope.p2.x;
			var dy:Number = y - rope.p2.y;
			var dzSq:Number = dx*dx + dy*dy;
			var dz:Number = Math.sqrt(dzSq);
			
			dx /= dz;
			dy /= dz;
			
			var c:uint = 0x0;
			
			var ox:Number = 0;
			var oy:Number = 6;
			
			Draw.circlePlus(x + (dx*oy + dy*ox)*scale, y + (dy*oy - dx*ox)*scale, 7*scale, c);
			oy = -10;
			Draw.circlePlus(x + (dx*oy + dy*ox)*scale, y + (dy*oy - dx*ox)*scale, 10*scale, c);
			
			c = 0xFF0000;
			
			ox = 2.5;
			oy = 11;
			Draw.circlePlus(x + (dx*oy + dy*ox)*scale, y + (dy*oy - dx*ox)*scale, 1*scale, c);
			ox *= -1;
			Draw.circlePlus(x + (dx*oy + dy*ox)*scale, y + (dy*oy - dx*ox)*scale, 1*scale, c);
			
			c = 0x0;
			
			for (var i:int = 0; i < 2; i++) {
				for (var j:int = 0; j < 4; j++) {
					var angle:Number = (j - 1.5) * (15 + FP.clamp(vy, 0, 1));
					angle += FP.clamp((vy - 1)*5, -20, 20);
					ox = Math.cos(angle * FP.RAD) * 15;
					oy = Math.sin(angle * FP.RAD) * 15;
					
					
					if (i == 0) ox *= -1;
					
					Draw.linePlus(x, y, x + (dx*oy + dy*ox)*scale, y + (dy*oy - dx*ox)*scale, c, 1.0, 2.0*scale);
				}
			}
		}
	}
}

