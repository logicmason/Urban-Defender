package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MoreWingmen extends MovieClip {
		var speed:Number;
		
		public function MoreWingmen() {
			speed = 6;
			rotation = 15;
			this.x = 650;
			this.y = Math.random()*200+50;
			addEventListener("enterFrame", enterFrame);
		}
		function enterFrame(e:Event){

			this.rotation -= .3;
			this.x -= speed;
			
			if(this.hitTestObject(Game.ship)){		
				if (Wingman.maxWingmen < Wingman.maxWingmenLimit){
					Wingman.maxWingmen += 1;
				}
				alert("Max Wingmen: " + Wingman.maxWingmen.toString());
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
