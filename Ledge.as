package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Ledge extends Entity
	{
		public var initialStrength:Number;
		public var strength:Number;
		public var c:uint;
		
		public function Ledge ()
		{
			type = "ledge";
			layer = 50;
		}
		
		public function weaken ():void
		{
			strength -= 0.1;
		}
		
		public function recalculate (): void
		{
			c = FP.getColorRGB(FP.rand(100), FP.rand(100)+155, FP.rand(100));
			
			graphic = Image.createRect(width, height, c);
			
			initialStrength = 10 + 90 / (Math.sqrt(y) * 0.1 + 1) + 4;
			
			strength = initialStrength;
		}
		
		public override function update (): void
		{
			if (strength < 8) {
				graphic.x = FP.random*8 - 4;
				graphic.y = FP.random*8 - 4;
				
				weaken();
				
				if (strength < 2) {
					Image(graphic).alpha = strength*0.5;
				}
			}
			super.update();
		}
		
		public override function render (): void
		{
			Image(graphic).color = FP.colorLerp(0x0, c, strength / initialStrength);
			super.render();
		}
	}
}

