package
{
	import core.ImageLoader;
	import core.LevelManager;
	import core.StageUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import renderer.EnvRenderer;
	import renderer.LevelMenuRenderer;
	import renderer.MainMenuRenderer;
	
	public class SpinshotMain extends Sprite
	{
		private var mainMenuRenderer_:MainMenuRenderer;
		private var levelMenuRenderer_:LevelMenuRenderer;
		private var levelManager_:LevelManager;
		
		public function SpinshotMain()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, stageResized);
		}
		
		private function stageResized(event:Event):void {
			trace("I SpinshotMain: stage resized");
			stage.removeEventListener(Event.RESIZE, stageResized);
			
			StageUtil.getSingleton().init(this.stage);
			ImageLoader.getSingleton().loadAllImages(onImagesLoaded);
		}
		
		private function onImagesLoaded():void {
			mainMenuRenderer_ = new MainMenuRenderer(onMainMenuSelected);	// do this after all images are loaded
			levelMenuRenderer_ = new LevelMenuRenderer(onLevelSelected);
			levelManager_ = new LevelManager(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
			mainMenuRenderer_.show();
		}
		
		private function onMainMenuSelected(menuItem:String):void {
			if (menuItem == MainMenuRenderer.MENU_ITEM_START_GAME) {
				levelMenuRenderer_.show();
			} else {
				throw new Error("WIP");
			}
		}
		
		private function onLevelSelected(levelIndex:int):void {
			levelManager_.startLevel(levelIndex);
		}
	}
}