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
		
		public var key:int;
		
		public var image:Image;
		public var text:Text;
		
		public var grabbing:Boolean = false;
		public var touchingLedge:Boolean = false;
		
		public function Player (_key:int, _x:Number)
		{
			key = _key;
			
			x = _x;
			y = Level.startY - 20;
			
			image = Image.createRect(40, 40, (_x < 320) ? 0xFF0000 : 0x0000FF);
			image.centerOO();
			
			text = new Text(Key.name(key));
			text.centerOO();
			
			graphic = new Graphiclist(image, text);
			
			vy = -FP.random * 5 - 10;
			
			setHitbox(40, 40, 20, 20);
			
			layer = -10;
		}
		
		public override function update (): void
		{
			var wasTouchingLedge:Boolean = touchingLedge;
			touchingLedge = collide("ledge", x, y) != null;
			text.color = 0xFFFFFF;
			
			if (touchingLedge && ! wasTouchingLedge) {
				vy *= 0.75;
				
				if (Input.check(key)) {
					vy *= 0.5;
				}
			}
			
			if (touchingLedge) {
				vy *= 0.95;
				
				text.color = grabbing ? 0xFFFFFF : 0x0;
				
				/*if (Input.check(key)) {
					vx *= 0.95;
					vy *= 0.9;
				}*/
			}
			
			if (Input.pressed(key) && collide("ledge", x, y)) {
				grabbing = true;
			}
			
			if (grabbing) {
				if (Input.check(key)) {
					vx = 0;
					vy = 0;
					return;
				}
				
				grabbing = false;
			}
			
			x += vx;
			y += vy;
			
			vy += 0.7;
			
			if (vx < -4 || vx > 4) vx *= 0.99;
			vy *= 0.99;
			
			vx += FP.random * 0.2 - 0.1;
			
			if (x < 50) {
				vx += FP.random * 0.001 * (50 - x);
			}
			
			if (x > 640 - 50) {
				vx -= FP.random * 0.001 * (x - (640 - 50));
			}
		}
	}
}

