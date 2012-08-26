package renderer
{
	import core.IFrameUpdateObject;
	import core.ImageLoader;
	import core.LevelManager;
	import core.StageUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LevelWidgetRenderer implements IFrameUpdateObject
	{
		public static const BUTTON_REPLAY:String = "button_replay";
		public static const BUTTON_QUIT:String = "button_quit";
		
		private var levelManager_:LevelManager;
		private var width_:int;
		private var height_:int;
		
		private var titleText_:TextField;
		private var textFormat_:TextFormat;
		private var titleTextShownTimeMsec_:int;
		private const TITLE_TEXT_SHOW_TIME_SEC:int = 2;
		
		private var BUTTON_GAP_HEIGHT_PERCENT:int = 4;
		private var replayBitmap_:Bitmap;
		private var replayButton_:Sprite;
		private var quitBitmap_:Bitmap;
		private var quitButton_:Sprite;

		public function LevelWidgetRenderer(levelManager:LevelManager, width:int, height:int)
		{
			levelManager_ = levelManager;
			width_ = width;
			height_ = height;
			titleText_ = new TextField();
			textFormat_ = new TextFormat();
			replayButton_ = new Sprite();
			replayBitmap_ = ImageLoader.getSingleton().getBitmap("level_button_replay_72.png");
			replayButton_.addChild(replayBitmap_);
			quitBitmap_ = ImageLoader.getSingleton().getBitmap("level_button_quit_72.png");
			quitButton_ = new Sprite();
			quitButton_.addChild(quitBitmap_);
			StageUtil.getSingleton().addFrameUpdateObject(this);
			if (StageUtil.getSingleton().userInput_.touchPointSupported) {
				replayButton_.addEventListener(TouchEvent.TOUCH_BEGIN, function(event:TouchEvent):void {
					levelManager_.onLevelWidgetPressed(BUTTON_REPLAY);
				});
				quitButton_.addEventListener(TouchEvent.TOUCH_BEGIN, function(event:TouchEvent):void {
					levelManager_.onLevelWidgetPressed(BUTTON_QUIT);
				});
			} else {
				replayButton_.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
					levelManager_.onLevelWidgetPressed(BUTTON_REPLAY);
				});
				quitButton_.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
					levelManager_.onLevelWidgetPressed(BUTTON_QUIT);
				});
			}
		}
		
		public function showTitleText(text:String):void {
			textFormat_.font = "Verdana";
			textFormat_.size = 36;
			titleText_.defaultTextFormat = textFormat_;
			titleText_.autoSize = TextFieldAutoSize.LEFT;
			titleText_.text = text;
			titleText_.x = width_ / 2 - titleText_.width / 2;
			titleText_.y = height_ * 2 / 10;
			if (!titleText_.parent) {
				StageUtil.getSingleton().addToStage(titleText_);
			}
			titleTextShownTimeMsec_ = StageUtil.getSingleton().curFrameStartTimeMsec_;
		}
		
		public function hideTitleText():void {
			if (titleText_.parent) {
				StageUtil.getSingleton().removeFromStage(titleText_);
			}
		}
		
		public function showReplayButton():void {
			var gap:int = height_ * BUTTON_GAP_HEIGHT_PERCENT / 100;
			replayButton_.width = height_ * 8 / 100;
			replayButton_.height = height_ * 8 / 100;
			replayButton_.x = gap;
			replayButton_.y = gap;
			StageUtil.getSingleton().addToStage(replayButton_);
		}
		
		public function hideReplayButton():void {
			StageUtil.getSingleton().removeFromStage(replayButton_);
		}
		
		public function showQuitButton():void {
			var gap:int = height_ * BUTTON_GAP_HEIGHT_PERCENT / 100;
			quitButton_.width = height_ * 8 / 100;
			quitButton_.height = height_ * 8 / 100;
			quitButton_.x = width_ - (gap + quitButton_.width);
			quitButton_.y = gap;
			StageUtil.getSingleton().addToStage(quitButton_);
		}
		
		public function hideQuitButton():void {
			StageUtil.getSingleton().removeFromStage(quitButton_);
		}

		// inteface impl
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number): Boolean {
			if (titleText_.parent) {
				if ((frameStartTimeMsec - titleTextShownTimeMsec_) / 1000 > TITLE_TEXT_SHOW_TIME_SEC) {
					StageUtil.getSingleton().removeFromStage(titleText_);
				}
			}
			return true;
		}
		
		// interface impl
		public function getDictKey():String {
			return StageUtil.FRAMEUPDATE_KEY_1_RENDER + "level_widget_renderer";
		}		
	}
}