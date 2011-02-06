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
		
		public var lastLedge:Ledge;
		
		public var starting:Boolean = true;
		public var startText:Text;
		
		public static const startY:Number = 150;
		public var startScore:Number = 0;
		
		public var gameOver:Boolean = false;
		
		public var score:int = 0;
		public var scoreTime:int = 0;
		public var time:int = 0;
		
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
				startScore = p1.y + 1;
				
				if (Input.pressed(p1.key)) {
					p1.vy = 0;
					p1.y += 1;
				}
				if (Input.pressed(p2.key)) {
					p2.vy = 0;
					p2.y += 1;
				}
				
				if (Input.pressed(p1.key) || Input.pressed(p2.key)) {
					starting = false;
					startText.text = "";
				} else {
					return;
				}
			}
			
			time++;
			
			if (Input.pressed(Key.R)) {
				FP.world = new Level;
				return;
			}
			
			if (!gameOver && (! p1.alive || ! p2.alive)) {
				var message:String;
				
				var timeInSeconds:Number = scoreTime / 60;
				var actualScore:Number = (score - startScore) / 100;
				var speed:Number = actualScore / timeInSeconds;
				
				if ((p1.grabbing && ! p2.alive) || (p2.grabbing && ! p1.alive)) {
					message = "Oh no!\n\nYour partner died";
				}
				
				if (! p1.alive && ! p2.alive) {
					message = "Oh no!\n\nYou both died";
				}
				
				if (message) {
					message += "\nafter bungeeing " + actualScore + " meters";
					
					if (speed) {
						message += "\nAverage speed: " + speed.toFixed(2) + " m/s";
					}
					
					if (p1.alive || p2.alive) {
						message += "\n\nYou are a bad friend.";
					}
					
					gameOver = true;
					
					var highscore:Number = Main.so.data.highscore;
					var highspeed:Number = Main.so.data.highspeed;
					
					if (! highscore) highscore = 0;
					if (! highspeed) highspeed = 0;
					
					if (actualScore > highscore) {
						Main.so.data.highscore = actualScore;
						Main.so.flush();
						
						message += "\n\nNew record!";
						
						if (highscore) message += "\nPrevious best: " + highscore + " meters";
					} else if (highscore) {
						message += "\n\nHigh score: " + highscore + " meters";
					}
					
					if (speed > highspeed) {
						Main.so.data.highspeed = speed;
						Main.so.flush();
						
						if (highspeed) message += "\n\nNew record!\nPrevious fastest speed: " + highspeed.toFixed(2) + " m/s";
					} else if (highspeed) {
						message += "\n\nHigh speed: " + highspeed.toFixed(2) + " m/s";
					}
					
					message += "\n\nPress R to reset";
					
					var resetText:Text = new Text(message, 320, 240, {align:"center", scrollY:0});
					resetText.centerOO();
					addGraphic(resetText, -150);
				}
			}
			
			if (! gameOver) {
				if (p1.grabbing) {
					score = Math.max(score, p1.y);
					scoreTime = time;
				}
				if (p2.grabbing) {
					score = Math.max(score, p2.y);
					scoreTime = time;
				}
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
				lastLedge = create(Ledge, false) as Ledge;
				lastLedge.type = "ledge";
				lastLedge.layer = 50;
				
				lastLedge.width = FP.random * 30 + 30 + int(first)*300;
				lastLedge.height = FP.random * 30 + 30;
				
				lastLedge.y = first ? startY : y + FP.random * Math.min(camera.y * 0.01 + 30, 320);
				lastLedge.x = first ? 320 - lastLedge.width*0.5 : FP.random*(640 - lastLedge.width);
				
				if (! gameOver && p1.alive != p2.alive && FP.random < 0.5) {
					// hacks to help the players die closer together
					
					var moveAway:Boolean = FP.random < 0.5;
					
					var p:Player;
					
					if (moveAway) p = p1.alive ? p2 : p1;
					else p = p1.alive ? p1 : p2;
					
					var dy:Number = (lastLedge.y - p.y);
					var t:Number = dy / p.vy;
					var dx:Number = p.vy * t * (0.5 * FP.random);
					
					if (moveAway) {
						while (lastLedge.x - lastLedge.width < p.x + dx && lastLedge.x + lastLedge.width*2 > p.x + dx) {
							lastLedge.x = FP.random*(640 - lastLedge.width);
						}
					} else {
						lastLedge.x = p.x + dx - lastLedge.width*FP.random;
						
						if (lastLedge.x + lastLedge.width > 640 || lastLedge.x < 0) {
							lastLedge.x = FP.random*(640 - lastLedge.width);
						}
					}
				}
				
				lastLedge.graphic = Image.createRect(lastLedge.width, lastLedge.height, FP.getColorRGB(FP.rand(64), FP.rand(55)+200, FP.rand(64)));
				
				add(lastLedge);
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

