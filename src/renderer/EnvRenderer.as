package renderer
{
	import core.GameConfig;
	import core.IStageObject;
	import core.StageUtil;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class EnvRenderer implements IStageObject
	{
		private var background_:Sprite;
		private var table_:Sprite;
		
		public function EnvRenderer()
		{
			background_ = new Sprite();
			StageUtil.getSingleton().addToStage(background_);
			drawEmptyBackground(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
			table_ = new Sprite();
			StageUtil.getSingleton().addToStage(table_);
			drawTable(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
		}
		
		public function onStageResized(fakeEvent:Boolean=false):void
		{
			drawEmptyBackground(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
			drawTable(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
		}
		
		// at minimum, need to draw something so that onStageResized() is called back
		private function drawEmptyBackground(width:int, height:int):void {
			
			var colors:Array = [0x555555, 0x555555, 0xDDDDDD];
			var alphas:Array = [1, 1, 1];
			var ratios:Array = [0, 
				255 * (100 - GameConfig.getSingleton().get(GameConfig.TABLE_HEIGHT_PERCENT)) / 100, 
				255];
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI/2);
			background_.graphics.clear();
			background_.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mat);
			background_.graphics.drawRect(0, 0, width, height);
			background_.graphics.endFill();
			background_.cacheAsBitmap = true;
			trace("I  add background sprite, width: " + background_.width + ", height: " + background_.height);
		}
		
		private function drawTable(width:int, height:int):void {
			table_.graphics.clear();
			table_.graphics.lineStyle(5 /* thickness */, 0x335599 /* color */);
			table_.graphics.beginFill(0x335599 /* color */);
			table_.graphics.drawRoundRect(
				0, 0, 
				width * 60 / 100,
				height * 5 / 100, 
				2, 2);
			table_.graphics.endFill();
			table_.x = width * 2 / 10;
			table_.y = height * (100 - GameConfig.getSingleton().get(GameConfig.TABLE_HEIGHT_PERCENT)) / 100;
			table_.cacheAsBitmap = true;
		}
		
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number):Boolean
		{
			return true;
		}
	}
}