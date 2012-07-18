package{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PowerUp extends MovieClip{
		var speed:Number;
		var type:Number;
		function PowerUp(){
			speed = 2;
			type = Math.floor(Math.random()*3+1);
			this.x = 650;
			this.y = Math.random()*200+50;
			addEventListener("enterFrame", enterFrame);
		}
		function enterFrame(e:Event){

			this.rotation -= 2;
			this.x -= speed;
			
			if(this.hitTestObject(Game.ship)){		
				if(type == 1){
					Game.ship.takeDamage(Game.ship.health - Game.ship.maxHealth);
					alert("Health!");
				}
				if(type == 2){
					for(var i in EnemyShip.list){
						EnemyShip.list[i].takeDamage(1);
					}
					alert("Armageddon!");
				}
				if(type == 3){
					if (Game.ship.shield.visible == true) { 
						Game.ship.shield.alpha = 1;
						Game.shieldChannel.stop();
					}
					Game.ship.shield.visible=true;
					Game.shieldChannel = Game.shieldSound2.play();
					alert("Shields!");
				}
				removeEventListener("enterFrame", enterFrame);
				stage.removeChild(this);
			}
			if(this.x < -30 || Game.ship.visible == false){
				removeEventListener("enterFrame", enterFrame);
				stage.removeChild(this);
			}
			
		}
		function alert(floaty) {
			var alert = new FloatyAlert();
			alert.x = Game.ship.x;
			alert.y = Game.ship.y - 40;
			alert.floatyText.text = floaty;
			stage.addChild(alert);
		}
	}
}