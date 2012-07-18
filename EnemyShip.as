package  {
	import flash.display.MovieClip
	import flash.events.Event;
	import flash.utils.Timer;
	
	public class EnemyShip extends MovieClip {
		
		var speed:Number;
		static var list:Array = new Array();
		var shootTimer:Timer;
		var health:Number;
		var yDirection:Number;
		
		function EnemyShip() {
			list.push(this);
			this.x = 700;
			this.y = Math.random()*200+50;
			speed = Math.random()*5+5;
			var yrand = Math.random()*3;
			if (yrand > 2) {
				yDirection = (yrand - .5) * 3;
			}
			addEventListener("enterFrame", enterFrame);
			var interval:Number = Math.random()*500+1000;
			shootTimer = new Timer(interval);
			shootTimer.addEventListener("timer", shoot);
			shootTimer.start();
			health = 1;
		}
		function takeDamage(d){
			health -= d;
			if(health <= 0) {
				kill();
			}
		}
		function enterFrame(e:Event){
			this.x -= speed;
			if(this.x < -100){
				destroy();
				return;
			}
			if(yDirection)
			{
				this.y += yDirection;
				if(yDirection > 0 && this.y > 275)
				{
					yDirection *= -1;
				}
				else if(yDirection < 0 && this.y < 25)
				{
					yDirection *= -1;
				}
			}
			if(this.hitTestObject(Game.ship)){
				takeDamage(3);
				if(Game.ship.shield.visible == false){
					Game.ship.takeDamage(20);
				}
			}
		}
		function kill() {  //destroy and give rewards
			
			if(yDirection) {
				reward(15);
			} else {
				reward(5);
			}
			var s = new ExplosionSound();
			s.play();
			var explosion = new Explosion();
			stage.addChild(explosion);
			explosion.x = this.x;
			explosion.y = this.y;
			destroy();
			Game.kills += 1;
		}
		function destroy() {
			shootTimer.stop();
			shootTimer.removeEventListener("timer",shoot);
			removeEventListener("enterFrame", enterFrame);
			for(var i in list){
				if(list[i] == this){
					delete list[i];
				}
			}
			stage.removeChild(this);
		}
		function reward(points:int) {
			var pd = new PointDisplay();
				pd.displayText.text = points.toString();
				pd.x = this.x;
				pd.y = this.y;
				stage.addChild(pd);
				Game.updateScore(points);
		}
		function shoot(e:Event){
			var b = new EnemyBullet();
			b.x = this.x - 50;
			b.y = this.y;
			stage.addChild(b);
		}
	}
	
}
