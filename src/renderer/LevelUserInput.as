package renderer
{
	import core.StageUtil;
	
	import flash.display.Sprite;

	public class LevelUserInput
	{
		public static const INPUT_AREA_WIDTH_PERCENT:int = 20; 
		public static const INPUT_AREA_ASPECT_RATIO:Number = 0.8;
		public static const INPUT_AREA_LINE_PADDING_PERCENT:Number = 10;
		public static const INPUT_AREA_MARGIN_PERCENT:Number = 7;
		
		public static const POSITION_LEFT:String = "pos_left";
		public static const POSITION_RIGHT:String = "pos_right";
		
		private var position_:String;
		private var levelWidth_:int;
		private var levelHeight_:int;
		private var widget_:Sprite;
		
		public function LevelUserInput(position:String, levelWidth:int, levelHeight:int) {
			position_ = position;
			levelWidth_ = levelWidth;
			levelHeight_ = levelHeight;
			
			widget_ = new Sprite();
			widget_.graphics.clear();
			widget_.graphics.lineStyle(1, 0, 0);
			widget_.graphics.beginFill(0x777777, 0.2);
			var widgetWidth:int = levelWidth_ * INPUT_AREA_WIDTH_PERCENT / 100;
			var widgetHeight:int = widgetWidth * INPUT_AREA_ASPECT_RATIO;
			widget_.graphics.drawRoundRect(0, 0, widgetWidth, widgetHeight, 3, 3);
			widget_.graphics.endFill();
			widget_.graphics.lineStyle(1, 0xCCCCCC, 0.8);
			widget_.graphics.beginFill(0, 0);
			var lineAreaPadding:int = widgetWidth * INPUT_AREA_LINE_PADDING_PERCENT / 100;
			widget_.graphics.drawRoundRect(lineAreaPadding, lineAreaPadding, 
				widgetWidth - lineAreaPadding * 2,
				widgetHeight - lineAreaPadding * 2, 3, 3);
			widget_.graphics.endFill();
			widget_.cacheAsBitmap = true;
			
			var widgetMargin:int = widgetWidth * INPUT_AREA_MARGIN_PERCENT / 100;
			if (position == POSITION_LEFT) {
				widget_.x = widgetMargin;
			} else {
				widget_.x = levelWidth - widgetWidth - widgetMargin;
			}
			widget_.y = levelHeight - widget_.height - widgetMargin;
		}
		
		public function show():void {
			StageUtil.getSingleton().addToStage(widget_);
		}
		
		public function hide():void {
			StageUtil.getSingleton().removeFromStage(widget_);
		}
	}
}