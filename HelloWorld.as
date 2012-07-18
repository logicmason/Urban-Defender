package  {
	import flash.display.*;
	import flash.text.*;
	
	public class HelloWorld extends MovieClip{

		public function HelloWorld() {
			
			var myText:TextField = new TextField();
			myText.text = "Hello World";
			addChild(myText);
		}

	}
	
}
