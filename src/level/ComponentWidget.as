package level
{
	import core.IFrameUpdateObject;
	import core.StageUtil;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ComponentWidget implements IFrameUpdateObject
	{
		private var compWidth_:int;
		private var compHeight_:int;
		private var titleText_:TextField;
		private var textFormat_:TextFormat;

		public function ComponentWidget(compWidth:int, compHeight:int)
		{
			compWidth_ = compWidth;
			compHeight_ = compHeight;
			drawWidgets();
		}
		
		private function drawWidgets():void {
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Verdana";
			textFormat.size = 36;
			titleText_ = new TextField();
			titleText_.defaultTextFormat = textFormat;
			titleText_.autoSize = TextFieldAutoSize.LEFT;
			titleText_.text = "???";
			titleText_.y = compHeight_ * 2 / 10;
		}
		
		public function showTitleText(text:String):void {
			titleText_.text = text;
			titleText_.x = compWidth_ / 2 - titleText_.width / 2;
			StageUtil.getSingleton().addToStage(titleText_);
		}

		// inteface impl
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number): Boolean {
			return true;
		}
		
	}
}