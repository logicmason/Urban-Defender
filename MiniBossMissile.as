package{
	import flash.display.MovieClip;
	import flash.events.Event;
	public class MiniBossMissile extends MovieClip{
		var speed:Number;
		var yDirection:Number;
		
		function MiniBossMissile(){
			speed = -20;
			var s = new MissileSound();
			s.play();
			graphics.lineStyle(6,0x000000);
			graphics.moveTo(-4,0);
			graphics.lineTo(4,0);
			graphics.lineStyle(2,0xff0000);
			graphics.moveTo(-3,0);
			graphics.lineTo(3,0);
			addEventListener("enterFrame", enterFrame);
		}
		function enterFrame(e:Event){
			this.x += speed;
			if(yDirection){
				this.y += yDirection*4;
			}
			if(this.x < 0){
				removeEventListener("enterFrame", enterFrame);
				stage.removeChild(this);
				return;
			}
			if(this.hitTestObject(Game.ship)){
				removeEventListener("enterFrame", enterFrame);
				stage.removeChild(this);
				if(Game.ship.shield.visible == false){
					Game.ship.takeDamage(10);
				}
			}
			for(var i in Wingman.list) {
				if(this.hitTestObject(Wingman.list[i])){
				   Wingman.list[i].kill();
				}
			}
		}
	}
}
