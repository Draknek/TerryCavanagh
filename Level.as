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
		
		public var strands:Array = [];
		public var webPoints:Array;
		
		public function Level ()
		{
			var bg:Image = new Image(BgGfx);
			bg.scale = 2;
			//bg.smooth = true;
			addGraphic(bg, 100);
			
			var midX:Number = FP.width*0.5;
			
			var points:Array = [
				new Point(midX - 90, 40),
				new Point(midX - 50, 50),
				new Point(midX + 50, 50),
				new Point(midX + 90, 40),
				new Point(midX - 120, 10),
				new Point(midX - 30, 25),
				new Point(midX + 30, 25),
				new Point(midX + 120, 10)
			];
			
			webPoints =	points;
			
			for each (var p:Point in points) {
				p.x += FP.random*20 - 10;
				p.y += FP.random*10 - 5;
			}
			
			var pairs:Array = [
				[0,1], [1,2], [2,3],
				[4,5], [5,6], [6,7],
				[0,4], [1,5], [2,6], [3,7]
			];
			
			for each (var pair:Array in pairs) {
				var p1:Point = points[pair[0]];
				var p2:Point = points[pair[1]];
				var strand:WebStrand = new WebStrand(p1, p2);
			
				add(strand);
				
				strands.push(strand);
			}
			
			add(new Orifice(MouthGfx, 328, 370));
			add(new Orifice(NostrilGfx, 264, 362));
			
			newPlayer();
		}
		
		public function newPlayer ():void
		{
			var player:Player = new Player();
			
			add(player);
			
			add(new Rope(player, FP.choose(strands)));
		}
		
		public function applyForceToWeb (origin:Point, dx:Number, dy:Number, force:Number):void
		{
			for each (var p:Point in webPoints) {
				var distance:Number = Point.distance(origin, p);
				
				var scale:Number;
				
				if (distance < 50) {
					scale = 0.2 + 0.8 * (1 - (distance / 50));
				} else {
					scale = 0.2;
				}
				
				p.x -= dx*force*scale;
				p.y -= dy*force*scale;
			}
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

