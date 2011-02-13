package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Player extends Entity
	{
		public var vx: Number = 0;
		public var vy: Number = 0;
		
		public var key:int;
		
		public var image:Image;
		public var text:Text;
		
		public var grabbing:Ledge;
		public var touchingLedge:Boolean = false;
		
		public var alive:Boolean = true;
		
		public var c:uint;
		
		public static const maxDamage:Number = 10;
		public static const maxEndurance:Number = 10;
		
		public static const damageRecovery:Number = 0.2;
		public static const enduranceRecovery:Number = 0.25;
		
		public static const enduranceDrain:Number = 0.1;
		
		public var damage:Number = 0;
		public var endurance:Number = maxEndurance;
		
		public function Player (_key:int, _x:Number)
		{
			key = _key;
			
			x = _x;
			y = Level.startY - 20;
			
			c = (_x < 320) ? 0xFFFF00 : 0xFF00FF;
			
			image = Image.createRect(40, 40, c);
			image.centerOO();
			
			text = new Text(Key.name(key));
			text.centerOO();
			
			graphic = new Graphiclist(image, text);
			
			vy = -FP.random * 5 - 10;
			
			setHitbox(40, 40, 20, 20);
			
			layer = -10;
		}
		
		public override function update (): void
		{
			if (grabbing) {
				image.color = c;//FP.colorLerp(0x0, c, endurance / maxEndurance);
			} else {
				image.color = FP.colorLerp(c, 0xFF0000, damage / maxDamage);
			}
			
			var wasTouchingLedge:Boolean = touchingLedge;
			touchingLedge = collide("ledge", x, y) != null;
			text.color = 0xFFFFFF;
			
			if (alive) {
				damage -= damageRecovery;
				damage = Math.max(0, damage);
				
				//endurance += enduranceRecovery;
				//endurance = Math.min(maxEndurance, endurance);
			}
			
			if (touchingLedge && ! wasTouchingLedge) {
				if (alive && vy > 0) {
					damage += Math.sqrt(vy);
					
					if (damage > maxDamage) {
						alive = false;
					} else {
						vy *= 1.0 - 0.1 * damage / maxDamage;
					}
				}
				
				if (! alive) {
					if (Level(world).p1.alive || Level(world).p2.alive) {
						vy *= 0.5;
					} else {
						vy *= 0.25;
					}
				}
				
				vy *= 0.75;
				
				if (alive && Input.check(key)) {
					vy *= 0.5;
				}
			}
			
			if (touchingLedge) {
				vy *= 0.95;
				
				if (alive) text.color = grabbing ? 0xFFFFFF : 0x0;
				
				/*if (Input.check(key)) {
					vx *= 0.95;
					vy *= 0.9;
				}*/
			}
			
			if (alive) {
				if (Input.pressed(key) && collide("ledge", x, y)) {
					grabbing = collide("ledge", x, y) as Ledge;
				}
			
				if (grabbing) {
					if (Input.check(key)) {
						vx = 0;
						vy = 0;
						damage = 0;
						
						//endurance -= enduranceDrain + enduranceRecovery;
						
						grabbing.weaken();
						
						if (grabbing.strength > 0) {
							return;
						}
						
						// else fall-through, grabbing = false
					}
				}
			}
			
			grabbing = null;
			
			x += vx;
			y += vy;
			
			vy += 0.7;
			
			if (vx < -4 || vx > 4) vx *= 0.99;
			//vy *= 0.99;
			
			if (! alive) {
				vx *= 0.995;
				vy *= 0.995;
			}
			
			vx += FP.random * 0.2 - 0.1;
			
			if (! Level(world).p1.grabbing || ! Level(world).p2.grabbing) {
				var time:Number = Level(world).time / 60.0;
				
				//vx += Math.sin(time)*0.2*FP.random;
			}
			
			if (x < 50) {
				vx += FP.random * 0.001 * (50 - x);
			}
			
			if (x > 640 - 50) {
				vx -= FP.random * 0.001 * (x - (640 - 50));
			}
			
			/*if (alive && ! Level(world).p1.grabbing && ! Level(world).p2.grabbing) {
				var t:Number = (killSpeed - vy); // 0 = kill speed, > 0 = less than kill speed
				
				if (t < 15) {
					t = t / 15.0;
					image.color = FP.colorLerp(0xFF0000, c, t * t);
				}
			}*/
		}
	}
}

