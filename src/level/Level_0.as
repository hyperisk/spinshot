package level
{
	import core.LevelManager;
	
	import renderer.EnvRenderer;

	public class Level_0 implements ILevel
	{
		private var levelManager_:LevelManager; 
		private var envRenderer_:EnvRenderer;
		
		public function Level_0()
		{
			envRenderer_ = new EnvRenderer();
		}
		
		public function init(levelManager:LevelManager):void {
			levelManager_ = levelManager; 
		}
		
		public function startPlay():void
		{
			envRenderer_.show();
			levelManager_.componentWidget_.showTitleText("Start Level 1");
		}
		
		public function endPlay():void
		{
		}
	}
}