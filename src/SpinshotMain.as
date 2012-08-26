package
{
	import core.ImageLoader;
	import core.LevelManager;
	import core.StageUtil;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	
	import renderer.BackgroundRenderer;
	import renderer.LevelMenuRenderer;
	import renderer.MainMenuRenderer;
	import renderer.TableRenderer;
	
	public class SpinshotMain extends Sprite
	{
		private var backgroundRenderer_:BackgroundRenderer;
		private var mainMenuRenderer_:MainMenuRenderer;
		private var levelManager_:LevelManager;
		
		public function SpinshotMain()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, stageResizedInitial);
		}
		
		private function stageResizedInitial(event:Event):void {
			trace("I SpinshotMain: stage resized (initial)");
			stage.removeEventListener(Event.RESIZE, stageResizedInitial);
			stage.addEventListener(Event.RESIZE, stageResizedLater);
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, stageOrientationChanged);
			
			StageUtil.getSingleton().init(this.stage);
			ImageLoader.getSingleton().loadAllImages(onImagesLoaded);
		}
		
		private function stageResizedLater(event:Event):void {
			var stage:Stage = event.target as Stage;
			if ((stage.stageWidth != StageUtil.getSingleton().stageWidth_) ||
				(stage.stageHeight != StageUtil.getSingleton().stageHeight_)) {
				throw new Error("unhandled event stage resized (after game start), new width: " + stage.stageWidth
					+ ", new height: " + stage.stageHeight);
			}
		}
		
		private function stageOrientationChanged(event:Event):void {
			throw new Error("unhandled event stage ori changed (after game start)");
		}
		
		private function onImagesLoaded():void {
			backgroundRenderer_ = new BackgroundRenderer();
			mainMenuRenderer_ = new MainMenuRenderer(backgroundRenderer_, onMainMenuSelected);	// do this after all images are loaded
			levelManager_ = new LevelManager(backgroundRenderer_,
				StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
			
			showMainMenu();
		}
		
		private function showMainMenu():void {
			mainMenuRenderer_.show(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
		}
		
		private function onMainMenuSelected(menuItem:String):void {
			if (menuItem == MainMenuRenderer.MENU_ITEM_START_GAME) {
				levelManager_.showLevelMenu();
			} else {
				throw new Error("WIP");
			}
		}
	}
}