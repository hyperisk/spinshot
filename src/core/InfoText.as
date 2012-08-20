package core
{
	import core.IStageObject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class InfoText extends Sprite implements IStageObject
	{
		private const NUM_FRAMES_TO_UPDATE:int = 10;
		private const AUTO_EXPIRE_MSEC:int = 5 * 1000;
		private var enabled_:Boolean;
		private var texts_:Dictionary;
		private var lastFrameNumberUpdated_:int;
		
		public function InfoText()
		{
			super();
			enabled_ = GameConfig.DEBUGGING_ENABLED;
			texts_ = new Dictionary();
			lastFrameNumberUpdated_ = 0;
			showAll();
		}
		
		public function setText(key:String, text:String, highlight:Boolean=false):void {
			if (!enabled_) {
				return;
			}
			if (texts_.hasOwnProperty(key)) {
				var existingText:TextStruct = texts_[key];
				if (!existingText.hasText(key, text)) {
					existingText.setText(key, text);
					existingText.highlight(highlight);
				}
				existingText.lastUpdateTimeMsec_ = getTimer();
			} else {
				var textStruct:TextStruct = new TextStruct(this, getTimer());
				textStruct.setText(key, text);
				textStruct.highlight(highlight);
				texts_[key] = textStruct;
				rearrangeAll();
			}
		}
		
		public function showAll():void {
			if (!enabled_) {
				return;
			}
			if (!parent) {
				StageUtil.getSingleton().addToStage(this);
			}
		}
		
		public function hideAll():void {
			if (!enabled_) {
				return;
			}
			if (parent) {
				StageUtil.getSingleton().removeFromStage(this);
			}
		}
		
		public function onPrepareToRender(event:Event):void {
			if (!enabled_) {
				return;
			}
			if (parent) {
				StageUtil.getSingleton().moveToFront(this);
			}
		}
		
		public function toggleAll():void {
			if (!enabled_) {
				return;
			}
			if (parent) {
				hideAll();
			} else {
				showAll();
			}
		}
		
		// interface impl
		public function onStageResized(fakeEvent:Boolean=false): void {
		}
		
		// interface impl
		public function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number): Boolean {
			if (!enabled_) {
				return true;
			}
			
			if (frameNumber < lastFrameNumberUpdated_ + NUM_FRAMES_TO_UPDATE) {
				return true;
			}
			var key:String;
			var textStruct:TextStruct;
			var dirty_:Boolean = false;
			for (key in texts_) {
				textStruct = texts_[key];
				if (frameStartTimeMsec > textStruct.lastUpdateTimeMsec_ + AUTO_EXPIRE_MSEC) {
					textStruct.remove(this);
					delete texts_[key];
					dirty_ = true;
				} else if (frameStartTimeMsec > textStruct.lastUpdateTimeMsec_ + AUTO_EXPIRE_MSEC / 3) {
					textStruct.dim(true);
				}
			}
			if (dirty_) {
				rearrangeAll();
				dirty_ = false;
			}
			
			lastFrameNumberUpdated_ = frameNumber;
			return true;
		}
		
		private function rearrangeAll():void {
			var key:String;
			var textStruct:TextStruct;
			var i:int = 0;
			for (key in texts_) {
				textStruct = texts_[key];
				textStruct.setPosY(i);
				i++;
			}
		}
	}
}

import flash.display.DisplayObjectContainer;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class TextStruct {
	public var lastUpdateTimeMsec_:int;
	private var textField_:TextField;
	private static var textFormat_:TextFormat = new TextFormat();
	
	public function TextStruct(parent:DisplayObjectContainer, lastUpdateTimeMsec:int) {
		lastUpdateTimeMsec_ = lastUpdateTimeMsec;
		
		textFormat_.font = "Verdana";
		textFormat_.size = 11;
		textFormat_.color = 0x000000;
		
		textField_ = new TextField();
		textField_.autoSize = TextFieldAutoSize.LEFT;
		textField_.defaultTextFormat = textFormat_;
		textField_.x = 0;
		textField_.background = true;
		textField_.selectable = false;
		dim(false);
		highlight(false);
		parent.addChild(textField_);
	}
	
	private function makeText(key:String, text:String):String {
		return key + "~ " + text;
	}
	
	public function setText(key:String, text:String):void {
		textField_.text = makeText(key, text);
		dim(false);
	}
	
	public function hasText(key:String, text:String):Boolean {
		return textField_.text == makeText(key, text);
	}
	
	public function setPosY(index:int):void {
		textField_.y = index * 14;
	}
	
	public function dim(set:Boolean):void {
		if (set) {
			textField_.alpha = 0.5;
		} else {
			textField_.alpha = 0.8;
		}
	}
	
	public function highlight(set:Boolean):void {
		if (set) {
			textField_.backgroundColor = 0xff8888;
		} else {
			textField_.backgroundColor = 0xeeeeee;
		}
	}
	
	public function remove(parent:DisplayObjectContainer):void {
		parent.removeChild(textField_);
	}
}
