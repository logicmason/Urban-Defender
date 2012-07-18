package{
	import flash.display.MovieClip;
	import flash.events.Event;
	public class PointDisplay extends MovieClip{
		function PointDisplay(){
			addEventListener("enterFrame", enterFrame);
		}
		function enterFrame(e:Event){
			this.alpha -= 0.02;
			if(this.alpha < 0){
				removeEventListener("enterFrame", enterFrame);
				stage.removeChild(this);
			}
		}
	}
}	