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
				new Point(midX - 160, 0),
				new Point(midX - 110, 35),
				new Point(midX - 40, 50),
				new Point(midX + 40, 50),
				new Point(midX + 110, 35),
				new Point(midX + 160, 0),
				
				new Point(midX - 150, -20),
				new Point(midX - 80, 10),
				new Point(midX - 30, 25),
				new Point(midX + 30, 25),
				new Point(midX + 80, 10),
				new Point(midX + 150, -20),
				
				new Point(midX - 150, -50),
				new Point(midX - 50, -5),
				new Point(midX - 20, 5),
				new Point(midX + 20, 5),
				new Point(midX + 50, -5),
				new Point(midX + 150, -50),
			];
			
			webPoints =	points;
			
			for each (var p:Point in points) {
				p.x += FP.random*10 - 5;
				p.y += FP.random*6 - 3;
			}
			
			var rows:int = 3;
			var columns:int = 6;
			
			var pairs:Array = [];
			
			for (var i:int = 0; i < columns; i++) {
				for (var j:int = 0; j < rows; j++) {
					var k:int;
					
					if (i < columns - 1) {
						k = i + j*columns;
						pairs.push([k, k+1]);
					}
					
					if (j < rows - 1) {
						k = i + j*columns;
						pairs.push([k, k+columns]);
					}
				}
			}
			
			for each (var pair:Array in pairs) {
				var p1:Point = points[pair[0]];
				var p2:Point = points[pair[1]];
				var strand:WebStrand = new WebStrand(p1, p2);
			
				add(strand);
				
				if (p1.y > 5 && p2.y > 5 && p1.x > 0 && p1.x < FP.width && p2.x > 0 && p2.x < FP.width) {
					strands.push(strand);
				}
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

