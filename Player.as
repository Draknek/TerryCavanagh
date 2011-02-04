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
		
		public function Player (_key:int, _x:Number)
		{
			key = _key;
			
			x = _x;
			y = 50;
			
			image = Image.createRect(40, 40, 0x0000FF);
			image.centerOO();
			
			graphic = image;
		}
		
		public override function update (): void
		{
			if (Input.check(key)) {
				if (Input.pressed(key)) {
					x += FP.random * 20 - 10;
				}
				
				vx = 0;
				vy = 0;
				return;
			}
			
			x += vx;
			y += vy;
			
			vy += 0.4;
			
			vx *= 0.99;
			vy *= 0.99;
		}
	}
}

