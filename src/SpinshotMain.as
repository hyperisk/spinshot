package
{
	import core.ImageLoader;
	import core.StageUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import renderer.EnvRenderer;
	import renderer.MainMenuRenderer;
	
	public class SpinshotMain extends Sprite
	{
		private var mainMenuRenderer_:MainMenuRenderer;
		private var envRenderer_:EnvRenderer;
		
		public function SpinshotMain()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, stageResized);
			// don't do anything until stage has non-zero size
		}
		
		private function stageResized(event:Event):void {
			trace("I stage resized, in main");
			stage.removeEventListener(Event.RESIZE, stageResized);
			StageUtil.getSingleton().init(this.stage);
			ImageLoader.getSingleton().loadAllImages(onImagesLoaded);
		}
		
		private function onImagesLoaded():void {
			mainMenuRenderer_ = new MainMenuRenderer();
			//envRenderer_ = new EnvRenderer();
			runGame();
		}
		
		private function runGame():void {
		}
	}
}