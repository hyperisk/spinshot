package core
{
	import level.ILevel;
	import level.Level_0;
	
	import renderer.BackgroundRenderer;
	import renderer.LevelMenuRenderer;
	import renderer.LevelUserInput;
	import renderer.LevelWidgetRenderer;
	import renderer.TableRenderer;

	public class LevelManager implements IFrameUpdateObject
	{
		public var backgroundRenderer_:BackgroundRenderer;
		public var tableRenderer_:TableRenderer;
		public var levelWidgetRenderer:LevelWidgetRenderer;
		public var totalNumLevelsCreated_:int; 
		public var levelUserInputLeft_:LevelUserInput;
		public var levelUserInputRight_:LevelUserInput;
		public var levelWidth_:int;
		public var levelHeight_:int;
		private var levelMenuRenderer_:LevelMenuRenderer;
		private var currentLevel_:ILevel;

		public function LevelManager(backgroundRenderer:BackgroundRenderer, levelWidth:int, levelHeight:int)
		{
			backgroundRenderer_ = backgroundRenderer;
			tableRenderer_ = new TableRenderer();
			levelWidth_ = levelWidth;
			levelHeight_ = levelHeight;
			totalNumLevelsCreated_ = 0;
			levelWidgetRenderer = new LevelWidgetRenderer(this, levelWidth, levelHeight);
			currentLevel_ = null;
			levelUserInputLeft_ = new LevelUserInput(LevelUserInput.POSITION_LEFT,
				StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
			levelUserInputRight_ = new LevelUserInput(LevelUserInput.POSITION_RIGHT,
				StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
			StageUtil.getSingleton().addFrameUpdateObject(this);
			levelMenuRenderer_ = new LevelMenuRenderer(backgroundRenderer_, function(levelIndex:int):void {
				startLevel(levelIndex);
			});
		}
		
		public function showLevelMenu():void {
			levelMenuRenderer_.show(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
		}
		
		public function startLevel(levelIndex:int):void {
			if (currentLevel_) {
				throw new Error("current level is not null in startLevel"); 
			}
			
			totalNumLevelsCreated_++;
			if (levelIndex == 0) {
				currentLevel_ = new Level_0();
			}
			currentLevel_.init(this);
			currentLevel_.startPlay();
		}
		
		public function quitCurrentLevel():void {
			if (!currentLevel_) {
				throw new Error("current level is null in quitLevel"); 
			}	
			
			currentLevel_.cleanUp();
			currentLevel_ = null;
		}
		
		public function onLevelWidgetPressed(widgetType:String):void {
			if (widgetType == LevelWidgetRenderer.BUTTON_REPLAY) {
				currentLevel_.restart();
			} else if (widgetType == LevelWidgetRenderer.BUTTON_QUIT) {
				quitCurrentLevel();
				showLevelMenu();
			}
		}
				
		// inteface impl
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number): Boolean {
			return true;
		}
		
		// interface impl
		public function getDictKey():String {
			return StageUtil.FRAMEUPDATE_KEY_1_SIM + "_level_manager";
		}	
	}
}