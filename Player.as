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
		
		public function Player ()
		{
			x = FP.width*0.5 + 5;
			y = FP.width*0.5 + 10;
			
			image = Image.createRect(40, 40, 0xFF0000);
			image.centerOO();
			
			graphic = image;
			
			setHitbox(40, 40, 20, 20);
			
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
		}
	}
}

