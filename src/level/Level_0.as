package level
{
	import core.LevelManager;
	
	import renderer.BackgroundRenderer;
	import renderer.TableRenderer;

	public class Level_0 implements ILevel
	{
		private var levelManager_:LevelManager;
		
		public function Level_0() {
		}
		
		public function init(levelManager:LevelManager):void {
			levelManager_ = levelManager;
		}
		
		public function startPlay():void {
			levelManager_.backgroundRenderer_.show(BackgroundRenderer.TYPE_TABLE, 
				levelManager_.levelWidth_, levelManager_.levelHeight_);
			levelManager_.tableRenderer_.show();
			levelManager_.levelWidgetRenderer.showTitleText("Level 1");
			levelManager_.levelWidgetRenderer.showReplayButton();
			levelManager_.levelWidgetRenderer.showQuitButton();
			levelManager_.levelUserInputRight_.show();
		}
		
		public function restart():void {
			levelManager_.levelWidgetRenderer.showTitleText("Try Again");
		}
		
		public function cleanUp():void {
			levelManager_.levelUserInputRight_.hide();
			levelManager_.levelWidgetRenderer.hideQuitButton();
			levelManager_.levelWidgetRenderer.hideReplayButton();
			levelManager_.levelWidgetRenderer.hideTitleText();
			levelManager_.tableRenderer_.hide();
			levelManager_.backgroundRenderer_.hide();
		}
	}
}