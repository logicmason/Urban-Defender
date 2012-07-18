package  {
	import flash.display.MovieClip
	import flash.events.Event;
	
	public class Bullet extends MovieClip{
		var speed:Number;
		function Bullet() {
			speed = 20;
			var s = new MissileSound();
			s.play();
			graphics.lineStyle(7,0x000000); //draw bullet
			graphics.moveTo(-2,0);
			graphics.lineTo(2,0);
			graphics.lineStyle(3,0xffffff);
			graphics.moveTo(-2,0);
			graphics.lineTo(2,0);
			addEventListener("enterFrame", enterFrame);
		}
		function enterFrame(e:Event){
			this.x += speed;
			if(this.x > 600){
				removeEventListener("enterFrame", enterFrame);
				stage.removeChild(this);
				Game.misses += 1;
				return;
			}
			for(var i in EnemyShip.list){
				if(this.hitTestObject(EnemyShip.list[i])){
					removeEventListener("enterFrame", enterFrame);
					stage.removeChild(this);
					EnemyShip.list[i].takeDamage(1);
					break;
				}
			}
		}

	}
	
}
