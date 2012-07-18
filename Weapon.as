package{
	import flash.display.MovieClip;
	import flash.events.Event;
	public class Weapon extends MovieClip{
		var speed:Number;
		var type:Number;
		function Weapon(){
			speed = 3;
			rotation = 30;
			type = Math.floor(Math.random()*3+1);
			this.x = 650;
			this.y = Math.random()*200+50;
			addEventListener("enterFrame", enterFrame);
		}
		function enterFrame(e:Event){

			this.rotation -= .5;
			this.x -= speed;
			
			if(this.hitTestObject(Game.ship)){		
				if(type){
					if(Wingman.list.length < Wingman.maxWingmen){
						var wingman = new Wingman();
						alert("Wingman!");
						stage.addChild(wingman);
					}
					else { alert("Too many Wingmen!"); }
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
			alert.y = Game.ship.y - 15;
			alert.floatyText.text = floaty;
			stage.addChild(alert);
		}
	}
}