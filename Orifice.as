package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	public class Orifice extends Entity
	{
		public var sprite:Spritemap;
		
		public function Orifice (src:Class, _x:Number, _y:Number)
		{
			x = _x;
			y = _y;
			
			var bmp:BitmapData = FP.getBitmap(src);
			
			sprite = new Spritemap(src, bmp.width/3, bmp.height);
			sprite.scale = 2;
			sprite.add("anim", [0,1,2,1], 0.04);
			sprite.play("anim");
			
			graphic = sprite;
			
			setHitbox(sprite.scaledWidth, sprite.scaledHeight);
			
			layer = 90;
			
			type = "orifice";
		}
		
		public override function update (): void
		{
			
		}
	}
}

