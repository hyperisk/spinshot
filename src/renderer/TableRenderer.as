package renderer
{
	import core.GameConfig;
	import core.IFrameUpdateObject;
	import core.StageUtil;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class TableRenderer implements IFrameUpdateObject
	{
		private var table_:Sprite;
		private var tableShadow_:Sprite;
		
		public function TableRenderer()
		{
			tableShadow_ = new Sprite();
			table_ = new Sprite();
			StageUtil.getSingleton().addFrameUpdateObject(this);
		}
		
		public function show():void {
			StageUtil.getSingleton().addToStage(tableShadow_);
			StageUtil.getSingleton().addToStage(table_);
			drawTable(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
		}
		
		private function drawTable(width:int, height:int):void {
			var tableTopWidth:int = width * 50 / 100;
			var tableTopThickness:int = height * 3 / 100;
			var tableTopPosY:int = height * (100 - GameConfig.getSingleton().get(GameConfig.TABLE_HEIGHT_PERCENT)) / 100;
			var tableLegOffsetX:int = tableTopWidth * 2 / 10;
			var tableLegHeight:int = tableTopWidth * 76 / 274;
			var netHeight:int = tableTopWidth * 15 / 274;

			var shadowWidth:int = width * 2;
			var shadowHeight:int = height - tableTopPosY - tableLegHeight;
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
			tableShadow_.y = height - shadowHeight ;
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
		
		public function hide():void {
			StageUtil.getSingleton().removeFromStage(tableShadow_);
			StageUtil.getSingleton().removeFromStage(table_);
		}
		
		// interface impl
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number):Boolean
		{
			return true;
		}
		
		// interface impl
		public function getDictKey():String {
			return StageUtil.FRAMEUPDATE_KEY_1_RENDER + "TableRenderer";
		}		
	}
}