package core
{
	import level.ComponentWidget;
	import level.ILevel;
	import level.Level_0;

	public class LevelManager implements IFrameUpdateObject
	{
		public var componentWidget_:ComponentWidget;
		public var levelWidth_:int;
		public var levelHeight_:int;
		private var currentLevel_:ILevel;

		public function LevelManager(levelWidth:int, levelHeight:int)
		{
			levelWidth_ = levelWidth;
			levelHeight_ = levelHeight;
			componentWidget_ = new ComponentWidget(levelWidth, levelHeight);
			currentLevel_ = null;
		}
		
		public function startLevel(levelIndex:int):void {
			if (currentLevel_) {
				throw new Error("current level is not null in startLevel"); 
			}
			
			if (levelIndex == 0) {
				currentLevel_ = new Level_0();
			}
			currentLevel_.init(this);
			currentLevel_.startPlay();
		}
		
		// inteface impl
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number): Boolean {
			return true;
		}
	}
}