package renderer
{
	import core.GameConfig;
	import core.IFrameUpdateObject;
	import core.StageUtil;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class BackgroundRenderer implements IFrameUpdateObject
	{
		public static const TYPE_MAIN_MENU:String = "main_menu";
		public static const TYPE_LEVEL_MENU:String = "level_menu";
		public static const TYPE_TABLE:String = "table";
		
		private var background_:Sprite;
		
		public function BackgroundRenderer() {
			background_ = new Sprite();
			StageUtil.getSingleton().addFrameUpdateObject(this);
		}

		public function show(type:String, width:int, height:int):void {
			if (type == TYPE_MAIN_MENU) {
				background_.graphics.clear();
				background_.graphics.beginFill(0x556677);
				background_.graphics.drawRect(0, 0, width, height);
				background_.graphics.endFill();
				background_.cacheAsBitmap = true;
			} else if (type == TYPE_LEVEL_MENU) {
				background_.graphics.clear();
				background_.graphics.beginFill(0x557766);
				background_.graphics.drawRect(0, 0, width, height);
				background_.graphics.endFill();
				background_.cacheAsBitmap = true;
			} else if (type == TYPE_TABLE) {
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
			}
			StageUtil.getSingleton().addToStage(background_);
		}
		
	    public function hide():void {
			StageUtil.getSingleton().removeFromStage(background_);
		}
		
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number):Boolean {
			return true;
		}
		
		public function getDictKey():String
		{
			return StageUtil.FRAMEUPDATE_KEY_1_RENDER + "background_renderer";
		}
	}
}