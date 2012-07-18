package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Explosion extends MovieClip{
		
		function Explosion() {
			addEventListener("enterFrame", enterFrame);
		}
		function enterFrame(e:Event){
			if(this.currentFrame == this.totalFrames){
				removeEventListener("enterFrame", enterFrame);
				stage.removeChild(this);
			}
		}

	}
	
}
