package renderer
{
	import core.StageUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class LevelMenuRenderer
	{
		public const NUM_ITEMS:int = 4;
		
		private var background_:Sprite;
		private var levelNameTexts_:Dictionary;
		private var buttonSprites_:Dictionary;
		private var menuSelectedCallback_:Function;
		
		public function LevelMenuRenderer(menuSelectedCallback:Function)
		{
			menuSelectedCallback_ = menuSelectedCallback;
			drawLevelMenu(StageUtil.getSingleton().stageWidth_, StageUtil.getSingleton().stageHeight_);
		}
		
		private function drawLevelMenu(width:int, height:int):void {
			background_ = new Sprite();
			background_.graphics.clear();
			background_.graphics.beginFill(0x557766);
			background_.graphics.drawRect(0, 0, width, height);
			background_.graphics.endFill();
			background_.cacheAsBitmap = true;

			var menuMarginLeft:int = width * 2 / 10; 
			var buttonWidth:int =       (width - 2 * menuMarginLeft) / NUM_ITEMS * 6 / 10; 
			var buttonPaddingLeft:int = (width - 2 * menuMarginLeft) / NUM_ITEMS * 2 / 10;	// (10 - 6) / 2
			var menuMarginTop:int = height * 3 / 10;
			var buttonHeight:int = buttonWidth;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Verdana";
			textFormat.size = 16;
			textFormat.color = 0xFFFFFF;

			levelNameTexts_ = new Dictionary();
			buttonSprites_ = new Dictionary();
			var i:int;
			for (i = 0; i < NUM_ITEMS; i++) {
				var levelNameText:TextField = new TextField();
				levelNameTexts_[i] = levelNameText;
				levelNameText.defaultTextFormat = textFormat;
				levelNameText.autoSize = TextFieldAutoSize.LEFT;
				levelNameText.text = "<" + (i + 1) + ">";
				levelNameText.x = buttonWidth / 2 - levelNameText.width / 2;
				levelNameText.y = buttonHeight / 2 - levelNameText.height / 2;
				
				var buttonSprite:Sprite = new Sprite();
				buttonSprites_[i] = buttonSprite;
				buttonSprite.graphics.clear();
				buttonSprite.graphics.beginFill(0x111111, 0.5);
				buttonSprite.graphics.lineStyle(2, 0x111111);
				buttonSprite.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
				buttonSprite.graphics.endFill();
				buttonSprite.cacheAsBitmap = true;
				buttonSprite.addChild(levelNameText);
				buttonSprite.x = menuMarginLeft + (buttonWidth + 2 * buttonPaddingLeft) * i + buttonPaddingLeft;
				buttonSprite.y = menuMarginTop;
				if (StageUtil.getSingleton().userInput_.touchPointSupported) {
					buttonSprite.addEventListener(TouchEvent.TOUCH_BEGIN, function(event:TouchEvent):void {
						hide(i);
					});
				} else {
					buttonSprite.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
						hide(i);
					});
				}

			}
		}
		
		public function show():void {
			StageUtil.getSingleton().addToStage(background_);
			var i:int;
			for (i = 0; i < NUM_ITEMS; i++) {
				StageUtil.getSingleton().addToStage(buttonSprites_[i]);
			}
		}
		
		private function hide(itemSelected:int):void {
			StageUtil.getSingleton().removeFromStage(background_);
			var i:int;
			for (i = 0; i < NUM_ITEMS; i++) {
				StageUtil.getSingleton().removeFromStage(buttonSprites_[i]);
			}
			if (itemSelected >= 0) {
				menuSelectedCallback_(itemSelected);
			}
		}
	}
}