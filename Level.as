package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.geom.*;
	
	public class Level extends World
	{
		[Embed(source="images/bg.png")] public static const BgGfx: Class;
		[Embed(source="images/mouth.png")] public static const MouthGfx: Class;
		[Embed(source="images/nostril.png")] public static const NostrilGfx: Class;
		
		public var strand:WebStrand;
		
		public function Level ()
		{
			var bg:Image = new Image(BgGfx);
			bg.scale = 2;
			//bg.smooth = true;
			addGraphic(bg, 100);
			
			var p1:Point = new Point(FP.width*0.5 - 60, 20 + FP.random * 20);
			var p2:Point = new Point(FP.width*0.5 + 60, 20 + FP.random * 20);
			
			strand = new WebStrand(p1, p2);
			
			add(strand);
			
			add(new Orifice(MouthGfx, 328, 370));
			add(new Orifice(NostrilGfx, 264, 362));
			
			newPlayer();
		}
		
		public function newPlayer ():void
		{
			var player:Player = new Player();
			
			add(player);
			
			add(new Rope(player, strand));
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

