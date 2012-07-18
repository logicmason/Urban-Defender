package  {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Background extends MovieClip{
		function Background(){
			addEventListener("enterFrame", enterFrame);
		}
		function enterFrame(e:Event){
			this.x -= 1;
			if(this.x < -2110){
				this.x = 0;
			}
		}
	}
}
