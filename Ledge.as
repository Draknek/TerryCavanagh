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
			
			initialStrength = 10 //+ 90 / (Math.sqrt(y) * 0.01 + 1);
			
			strength = initialStrength;
		}
		
		public override function update (): void
		{
			if (strength < 4) {
				graphic.x = FP.random*8 - 4;
				graphic.y = FP.random*8 - 4;
				
				if (strength < 1) {
					Image(graphic).alpha = strength;
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

