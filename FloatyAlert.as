package{
	import flash.display.MovieClip;
	import flash.events.Event;
	public class FloatyAlert extends PointDisplay{
		override function enterFrame(e:Event){
			this.alpha -= 0.01;
			if(this.alpha < 0){
				removeEventListener("enterFrame", enterFrame);
				stage.removeChild(this);
			}
		}
	}
}	
