package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		[Embed(source="images/bg.png")] public static const BgGfx: Class;
		[Embed(source="images/mouth.png")] public static const MouthGfx: Class;
		[Embed(source="images/nostril.png")] public static const NostrilGfx: Class;
		
		public function Level ()
		{
			var bg:Image = new Image(BgGfx);
			bg.scale = 2;
			//bg.smooth = true;
			addGraphic(bg, 100);
			
			add(new Orifice(MouthGfx, 328, 370));
			add(new Orifice(NostrilGfx, 264, 362));
			
			newPlayer();
		}
		
		public function newPlayer ():void
		{
			var player:Player = new Player();
			
			add(player);
			
			add(new Rope(player));
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

