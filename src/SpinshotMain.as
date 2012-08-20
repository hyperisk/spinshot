package
{
	import core.StageUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import renderer.EnvRenderer;
	
	public class SpinshotMain extends Sprite
	{
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
			envRenderer_ = new EnvRenderer();
			runGame();
		}
		
		private function runGame():void {
		}
	}
}