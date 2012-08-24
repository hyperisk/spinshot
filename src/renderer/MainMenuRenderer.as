package renderer
{
	import core.GameConfig;
	import core.ImageLoader;
	import core.StageUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	public class MainMenuRenderer
	{
		private var background_:Sprite;
		private var titleText_:TextField;
		private var textFormat_:TextFormat;
		private var startBitmap_:Bitmap;
		private var startButton_:Sprite;
		private var helpBitmap_:Bitmap;
		private var helpButton_:Sprite;
		private var menuSelectedCallback_:Function;
		
		public static const MENU_ITEM_START_GAME:String = "menu_start_game";
		public static const MENU_ITEM_HELP:String = "menu_help";
		
		public function MainMenuRenderer(menuSelectedCallback:Function) {
			menuSelectedCallback_ = menuSelectedCallback;
			drawMainMenu(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
		}
		
		// at minimum, need to draw something so that onStageResized() is called back
		public function drawMainMenu(width:int, height:int):void {
			background_ = new Sprite();
			background_.graphics.clear();
			background_.graphics.beginFill(0x556677);
			background_.graphics.drawRect(0, 0, width, height);
			background_.graphics.endFill();
			background_.cacheAsBitmap = true;
			
			titleText_ = new TextField();

			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Verdana";
			textFormat.size = 24;
			
			titleText_.defaultTextFormat = textFormat;
			titleText_.autoSize = TextFieldAutoSize.LEFT;
			titleText_.text = "Ping Pong: Spin Shot !!!";
			titleText_.x = width / 2 - titleText_.width / 2;
			titleText_.y = height * 3 / 10;
			
			startBitmap_ = ImageLoader.getSingleton().getBitmap("mainmenu_button_start_72.png");
			startButton_ = new Sprite();
			startButton_.addChild(startBitmap_);
			startButton_.x = width * 4 / 10 - startBitmap_.width / 2;
			startButton_.y = height * 6 / 10;
			
			helpBitmap_ = ImageLoader.getSingleton().getBitmap("mainmenu_button_help_72.png");
			helpButton_ = new Sprite();
			helpButton_.addChild(helpBitmap_);
			helpButton_.x = width * 6 / 10 - helpBitmap_.width / 2;
			helpButton_.y = height * 6 / 10;
			
			if (StageUtil.getSingleton().userInput_.touchPointSupported) {
				startButton_.addEventListener(TouchEvent.TOUCH_BEGIN, function(event:TouchEvent):void {
					hide(MENU_ITEM_START_GAME);
				});
				helpButton_.addEventListener(TouchEvent.TOUCH_BEGIN, function(event:TouchEvent):void {
					hide(MENU_ITEM_HELP);
				});
			} else {
				startButton_.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
					hide(MENU_ITEM_START_GAME);
				});
				helpButton_.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
					hide(MENU_ITEM_HELP);
				});
			}
			
			if (GameConfig.MAIN_MENU_AUTO_SELECT) {
				setTimeout(function():void {
					hide(MENU_ITEM_START_GAME);
				}, 300);
			}
		}
		
		public function show():void {
			StageUtil.getSingleton().addToStage(background_);
			StageUtil.getSingleton().addToStage(titleText_);
			StageUtil.getSingleton().addToStage(startButton_);
			StageUtil.getSingleton().addToStage(helpButton_);
		}
		
		private function hide(itemSelected:String):void {
			StageUtil.getSingleton().removeFromStage(background_);
			StageUtil.getSingleton().removeFromStage(titleText_);
			StageUtil.getSingleton().removeFromStage(startButton_);
			StageUtil.getSingleton().removeFromStage(helpButton_);
			
			if (itemSelected) {
				menuSelectedCallback_(itemSelected);
			}
		}
	}
}