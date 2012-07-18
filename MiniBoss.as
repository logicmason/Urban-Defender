package  {
	import flash.display.MovieClip
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

	
	public class MiniBoss extends EnemyShip {
		
		static var maxHealth = 20;
		var ySpeed:Number;
		var rewardPoints:Number;
			
		function MiniBoss(){
			this.x = 700;
			this.y = Math.random()*100 +100;
			speed = 2;
			ySpeed = 2;
			rewardPoints = 250;
			Game.enemyHealthMeter.visible = true;
			Game.enemyHealthMeter.bar.scaleX = 1;
			health = maxHealth;
		}
		override function takeDamage(d){
			health -= d;
			Game.enemyHealthMeter.bar.scaleX = health/maxHealth;
			if(health <= 0) {
				kill();
			}
		}
		override function enterFrame(e:Event){
			this.y += ySpeed;
			if(ySpeed > 0 && this.y > 250){
				ySpeed *= -1;
			}
			else if(ySpeed < 0 && this.y < 50){
				ySpeed *= -1;
			}
				
			this.x -= speed;
			if(this.x < 400){
				speed = 0;
			}
			
			if(this.hitTestObject(Game.ship)){
				takeDamage(3);
				if(Game.ship.shield.visible == false){
					Game.ship.takeDamage(20);
				}
			}
		}
		override function kill(){
			
			var list = EnemyShip.list;
			var existsAnother = false;
			shootTimer.stop();
			shootTimer.removeEventListener("timer",shoot);
			removeEventListener("enterFrame", enterFrame);
			reward(rewardPoints);
			
			var s = new BigExplosionSound;
			s.play();
			var explosion = new Explosion();
			stage.addChild(explosion);
			explosion.x = this.x;
			explosion.y = this.y;
			for(var i in list){
				if(list[i] == this){
					delete list[i];
				}
			}
			stage.removeChild(this);
			for(var j in list){
				if(list[j] is MiniBoss){ existsAnother = true; }
			}

			if(!existsAnother) {
				Game.enemyHealthMeter.visible = false;
				Game.miniBossTimer.start();
			}
			Game.kills += 1;
		}
	
		override function shoot(e:Event){
			var b = new MiniBossMissile();
			b.x = this.x - 50;
			b.y = this.y - 3;
			b.yDirection = -1.5;
			stage.addChild(b);
			
			var c = new MiniBossMissile();
			c.x = this.x - 50;
			c.y = this.y + 3;
			c.yDirection = 1.6;
			stage.addChild(c);
		}
	}
	
}