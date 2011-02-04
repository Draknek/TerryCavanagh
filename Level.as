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
		
		public var ledges:Array = [];
		public var lastLedge:Entity;
		
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
			
			camera.y += (rope.y + 50 - camera.y - 240) * 0.2;
			
			while (! lastLedge || camera.y + 480 > lastLedge.y + lastLedge.height + 30) {
				var y:Number = lastLedge ? lastLedge.y + lastLedge.height : 0;
				lastLedge = new Entity;
				lastLedge.type = "ledge";
				
				lastLedge.width = FP.random * 30 + 30;
				lastLedge.height = FP.random * 30 + 30;
				
				lastLedge.x = FP.random*(640 - lastLedge.width);
				lastLedge.y = y + FP.random * 30;
				
				lastLedge.graphic = Image.createRect(lastLedge.width, lastLedge.height, 0x888888);
				
				add(lastLedge);
				
				ledges.push(lastLedge);
			}
			
			for each (var e:Entity in ledges) {
				if (e.y + e.height < Math.min(p1.y, p2.y) - 1000) {
					remove(e);
				}
			}
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

