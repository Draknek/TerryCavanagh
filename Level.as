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
		
		public var lastLedge:Entity;
		
		public var starting:Boolean = true;
		public var startText:Text;
		
		public static const startY:Number = 150;
		
		public function Level ()
		{
			addGraphic(new Backdrop(BgGfx), 100);
			add(p1 = new Player(Key.Z, 220));
			add(p2 = new Player(Key.M, 420));
			add(rope = new Rope(p1, p2));
			
			startText = new Text("Press and hold Z or M to start\n\nFor goodness sake keep it held down\nor you'll put us in danger!", 320, (startY - 20)*0.5, {scrollY:false, align:"center"});
			startText.centerOO();
			addGraphic(startText);
		}
		
		public override function update (): void
		{
			addLedges();
			
			if (starting) {
				if (Input.check(p1.key)) {
					p1.vy = 0;
					p1.y += 1;
				}
				if (Input.check(p2.key)) {
					p2.vy = 0;
					p2.y += 1;
				}
				
				if (Input.check(p1.key) || Input.check(p2.key)) {
					starting = false;
					startText.text = "";
				} else {
					return;
				}
			}
			
			if (Input.pressed(Key.R)) {
				FP.world = new Level;
				return;
			}
			
			if (p1.grabbing && p2.grabbing) {
			//	return;
			}
			
			super.update();
			
			camera.y += (rope.y + 50 - camera.y - 240) * 0.2;
			
			addLedges();
		}
		
		public function addLedges ():void
		{
			while (! lastLedge || camera.y + 480 > lastLedge.y + lastLedge.height + 30) {
				var first:Boolean = (lastLedge == null);
				
				var y:Number = first ? 0 : lastLedge.y + lastLedge.height;
				lastLedge = create(Entity, true);
				lastLedge.type = "ledge";
				lastLedge.layer = 50;
				
				lastLedge.width = FP.random * 30 + 30 + int(first)*300;
				lastLedge.height = FP.random * 30 + 30;
				
				lastLedge.x = first ? 320 - lastLedge.width*0.5 : FP.random*(640 - lastLedge.width);
				lastLedge.y = first ? startY : y + FP.random * 30;
				
				lastLedge.graphic = Image.createRect(lastLedge.width, lastLedge.height, FP.getColorRGB(FP.rand(64), FP.rand(55)+200, FP.rand(64)));
			}
			
			var ledges:Array = [];
			getType("ledge", ledges);
			
			for each (var e:Entity in ledges) {
				if (e.y + e.height < Math.min(p1.y, p2.y) - 1000) {
					recycle(e);
				}
			}
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

