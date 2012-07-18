package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.globalization.NumberFormatter;
		
	public class Wingman extends MovieClip {
		static var list:Array = new Array();
		static var maxWingmen:Number = 2;
		static var maxWingmenLimit:Number = 6;
		var shootTimer:Timer;
		var health:Number;
		var position:Number;
		var yOffset:Number;
		var nextY:Number;
		var nextX:Number;
		
		function Wingman() {
			this.position = firstOpen();
			yOffset = Math.floor((1+ position) / 2) * 15 + 7;
			if (position % 2) { yOffset *= -1; }
			list.push(this);
			addEventListener("enterFrame", enterFrame);
			shootTimer = new Timer(600);
			shootTimer.addEventListener("timer", shoot);
			shootTimer.start();
			health = 1;
		}
		function firstOpen() {  // finds an opening in wingman formation
			var isTaken:Array = [];
			var f:Number;
			for (var i in list){
				isTaken.push(list[i].position);
			}
			isTaken.sort();
			f = 1;
			for (var j in isTaken) {
				if (f == isTaken[j]) {
					f+=1;
				}
			}
			return f;
		}
		function enterFrame(e:Event){ 
			if (nextX) { this.x = nextX; } // make wingmen lag a bit
			if (nextY) { this.y = nextY; }
			nextX = Game.ship.x;
			nextY = Game.ship.y + yOffset;
			
			for (var i in EnemyShip.list){
				if(this.hitTestObject(EnemyShip.list[i])){
					takeDamage(3);
					EnemyShip.list[i].takeDamage(3);
					Game.updateScore(-25);
				}
			}
			
		}
		function takeDamage(d){
			health -= d;
			if(health <= 0) {
				kill();
			}
		}
		function kill(){
			shootTimer.stop();
			shootTimer.removeEventListener("timer",shoot);
			var s = new ExplosionSound();
			s.play();
			var explosion = new Explosion();
			stage.addChild(explosion);
			explosion.x = this.x;
			explosion.y = this.y;
			removeEventListener("enterFrame", enterFrame);
			stage.removeChild(this);
			for(var i in list){
				if(list[i] == this){
					var j = list.indexOf(list[i]);
					delete list[i];
					list.splice(j,1);
				}
			}
		}
		function shoot(e:Event){
			var b = new Bullet();
			stage.addChild(b);
			b.x = this.x+50;
			b.y = this.y+3;
		}
		function alert(floaty) {
			var alert = new FloatyAlert();
			alert.x = Game.ship.x;
			alert.y = Game.ship.y - 25;
			alert.floatyText.text = floaty;
			stage.addChild(alert);
		}
	}
	
}
