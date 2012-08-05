package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		public var player:Player;
		public var rope:Rope;
		
		[Embed(source="images/bg.png")]
		public static const BgGfx: Class;
		
		public function Level ()
		{
			addGraphic(new Backdrop(BgGfx), 100);
			
			player = new Player();
			
			add(player);
			
			add(rope = new Rope(player));
		}
		
		public override function update (): void
		{
			if (Input.pressed(Key.R)) {
				FP.world = new Level;
				return;
			}
			
			super.update();
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

