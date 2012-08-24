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
		private var tableShadow_:Sprite;
		
		public function EnvRenderer()
		{
			background_ = new Sprite();
			tableShadow_ = new Sprite();
			table_ = new Sprite();
		}
		
		public function show():void {
			StageUtil.getSingleton().addToStage(background_);
			drawEmptyBackground(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
			
			StageUtil.getSingleton().addToStage(tableShadow_);
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
			var tableTopWidth:int = width * 50 / 100;
			var tableTopThickness:int = height * 3 / 100;
			var tableTopPosY:int = height * (100 - GameConfig.getSingleton().get(GameConfig.TABLE_HEIGHT_PERCENT)) / 100;
			var tableLegOffsetX:int = tableTopWidth * 2 / 10;
			var tableLegHeight:int = tableTopWidth * 76 / 274;
			var netHeight:int = tableTopWidth * 15 / 274;

			var shadowWidth:int = tableTopWidth * 18 / 10;
			var shadowHeight:int = tableTopWidth * 2 / 10;
			var colors:Array = [0x555555, 0x777777, 0xAAAAAA];
			var alphas:Array = [1, 1, 0];
			var ratios:Array = [0, 180, 255];
			var mat:Matrix = new Matrix();
			mat.createGradientBox(shadowWidth, shadowHeight, Math.PI/2);
			tableShadow_.graphics.clear();
			tableShadow_.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mat);
			tableShadow_.graphics.drawEllipse(0, 0, shadowWidth, shadowHeight);
			tableShadow_.graphics.endFill();
			tableShadow_.x = width / 2 - shadowWidth / 2;
			tableShadow_.y = height - tableTopPosY * 2 / 10;
			tableShadow_.cacheAsBitmap = true;

			table_.graphics.clear();
			table_.graphics.lineStyle(2 /* thickness */, 0x3A5A9F /* color */);
			table_.graphics.beginFill(0x335599 /* color */);
			table_.graphics.drawRoundRect(0, netHeight, tableTopWidth, tableTopThickness, 2, 2);
			table_.graphics.endFill();
			
			table_.graphics.lineStyle(1 /* thickness */, 0x2A4A7F /* color */);
			table_.graphics.beginFill(0x224477 /* color */);
			table_.graphics.drawRect(tableLegOffsetX, tableTopThickness + netHeight, 
				tableTopThickness, tableLegHeight);
			table_.graphics.drawRect(tableTopWidth - tableLegOffsetX - tableTopThickness, tableTopThickness + netHeight, 
				tableTopThickness, tableLegHeight);
			table_.graphics.endFill();
			
			table_.graphics.lineStyle(1 /* thickness */, 0xFFFFFF /* color */);
			table_.graphics.beginFill(0xCCCCCC /* color */);
			table_.graphics.drawRect(tableTopWidth / 2 - 2, 0, 3, netHeight);

			table_.x = width / 2 - tableTopWidth / 2;
			table_.y = tableTopPosY - netHeight;
			table_.cacheAsBitmap = true;
		}
		
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number):Boolean
		{
			return true;
		}
	}
}