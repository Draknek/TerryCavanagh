package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		public var p1:Player;
		public var p2:Player;
		public var rope:Rope;
		
		[Embed(source="images/bg.png")]
		public static const BgGfx: Class;
		
		public function Level ()
		{
			addGraphic(new Backdrop(BgGfx), 100);
			add(p1 = new Player(Key.Z, 220));
			add(p2 = new Player(Key.M, 420));
			add(rope = new Rope(p1, p2));
		}
		
		public override function update (): void
		{
			super.update();
			
			camera.y += (Math.max(p1.y, p2.y) + 50 - camera.y - 480) * 0.2;
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

