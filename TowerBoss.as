package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TowerBoss extends MiniBoss {
		static var maxHealth = 100;
		
		public function TowerBoss() {
			health = maxHealth;
			speed = 1;
			ySpeed = 2;
			rewardPoints = 900;
		}
		override function takeDamage(d){
			health -= d;
			Game.enemyHealthMeter.bar.scaleX = health/maxHealth;
			if(health <= 0) {
				kill();
			}
		}
		override function shoot(e:Event){
			var a = new MiniBossMissile();
			a.x = this.x - 50;
			a.y = this.y -50;
			a.yDirection = -1;
			stage.addChild(a);
			
			var b = new MiniBossMissile();
			b.x = this.x - 50;
			b.y = this.y;
			stage.addChild(b);
			
			var c = new MiniBossMissile();
			c.x = this.x - 50;
			c.y = this.y + 50;
			c.yDirection = 1;
			stage.addChild(c);
		}
	}
	
}
