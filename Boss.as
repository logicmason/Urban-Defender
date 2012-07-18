package  {
	import flash.display.MovieClip
	import flash.events.Event;
	import flash.utils.Timer;
	
	public class Boss extends MiniBoss {
		
		static var maxHealth = 150;
		var shootTimerB:Timer;
			
		function Boss(){
			//shootTimer = new Timer(1500); //in Miniboss Missile
			//shootTimer.addEventListener("timer", shoot);
			//shootTimer.start();
			rewardPoints = 2500;
			health = maxHealth;
			shootTimerB = new Timer(250); //Normal Bullets
			shootTimerB.addEventListener("timer", shootb);
			shootTimerB.start();
		}
		override function takeDamage(d){
			health -= d;
			Game.enemyHealthMeter.bar.scaleX = health/maxHealth;
			if(health <= 0) {
				kill();
			}
		}
		override function destroy() {
			super.destroy();
			shootTimerB.stop();
			shootTimerB.removeEventListener("timer", shootb);
		}
		override function kill(){
			Game.enemyHealthMeter.visible = false
			var list = EnemyShip.list
			shootTimer.stop();
			shootTimer.removeEventListener("timer",shoot);
			
			shootTimerB.stop();
			shootTimerB.removeEventListener("timer",shootb);
			reward(2500);
			var explosion = new Explosion();
			stage.addChild(explosion);
			explosion.x = this.x;
			explosion.y = this.y;
			removeEventListener("enterFrame", enterFrame);
			
			for(var i in list){
				if(list[i] == this){
					delete list[i];
				}
			}
			stage.removeChild(this);
			//Game.miniBossTimer.start();
			Game.kills += 1;
			Game.gameOverMenu.ending.text = "Victory!";
			Game.gameComplete = 1;
			Game.gameOver();
		}
		function shootb(e:Event){
			var b = new EnemyBullet();
			b.x = this.x - 50;
			b.y = this.y;
			stage.addChild(b);
		}
	}
	
}
