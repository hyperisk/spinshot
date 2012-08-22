package renderer
{
	import core.ImageLoader;
	import core.StageUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class MainMenuRenderer
	{
		private var background_:Sprite;
		private var titleText_:TextField;
		private var textFormat_:TextFormat;
		private var startBitmap_:Bitmap;
		private var helpBitmap_:Bitmap;
		
		public function MainMenuRenderer()
		{
			background_ = new Sprite();
			StageUtil.getSingleton().addToStage(background_);
			titleText_ = new TextField();
			StageUtil.getSingleton().addToStage(titleText_);
			startBitmap_ = ImageLoader.getSingleton().getBitmap("mainmenu_button_start_72.png");
			StageUtil.getSingleton().addToStage(startBitmap_);
			helpBitmap_ = ImageLoader.getSingleton().getBitmap("mainmenu_button_help_72.png");
			StageUtil.getSingleton().addToStage(helpBitmap_);
			drawMainMenu(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
		}
		
		// at minimum, need to draw something so that onStageResized() is called back
		private function drawMainMenu(width:int, height:int):void {
			background_.graphics.clear();
			background_.graphics.beginFill(0x556677);
			background_.graphics.drawRect(0, 0, width, height);
			background_.graphics.endFill();
			background_.cacheAsBitmap = true;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Verdana";
			textFormat.size = 24;
			
			titleText_.defaultTextFormat = textFormat;
			titleText_.autoSize = TextFieldAutoSize.LEFT;
			titleText_.text = "Ping Pong: Spin Shot !!!";
			titleText_.x = width / 2 - titleText_.width / 2;
			titleText_.y = height * 3 / 10;
			
			startBitmap_.x = width * 4 / 10 - startBitmap_.width / 2;
			startBitmap_.y = height * 6 / 10;
			
			helpBitmap_.x = width * 6 / 10 - startBitmap_.width / 2;
			helpBitmap_.y = height * 6 / 10;
		}
	}
}