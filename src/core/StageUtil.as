package core
{
	import core.IFrameUpdateObject;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.utils.getTimer;
	
	// to add debugging message to stage:
	// StageUtil.getSingleton().infoText_.setText(title, message)
	
	public class StageUtil
	{
		static private var instance_ : StageUtil = null;
		
		public var stageWidth_:int;
		public var stageHeight_:int;
		private var stage_:Stage;
		
		public var userInput_:UserInputUtil;
		public var infoText_:InfoText;
		
		private var frameNumber_:int;
		private var lastFrameUpdateTimeMsec_:int;
		public var fpsAvg_:int;
		private var lastFpsUpdateTimeMsec_:int;
		private var numFramesSinceLastUpdate_:int;
		private var sumElapsedTimesMsec_:Number;
		
		private var frameUpdateObjectDict_:Array;
		
		static public function getSingleton() : StageUtil {
			if ( instance_ == null ) instance_ = new StageUtil( new Lock() );
			return instance_;
		}
		
		public function StageUtil( lock : Lock ) {
			if ( lock == null ) throw new Error("Singleton not allowed bla bla bla");
			frameUpdateObjectDict_ = new Array();
		}		
		
		public function init(stage:Stage):void
		{
			stage_ = stage;
			if (stage.stageWidth == 0) {
				throw new Error("stage width is 0");
			}
			stageWidth_ = stage.stageWidth;
			stageHeight_ = stage.stageHeight;
			trace("I initializing StageUtil, width: " + stageWidth_ + ", height: " + stageHeight_);
			
			infoText_ = new InfoText();
			userInput_ = new UserInputUtil(stage_, infoText_);
			
			frameNumber_ = 0;
			numFramesSinceLastUpdate_ = 0;
			lastFrameUpdateTimeMsec_ = getTimer();
			lastFpsUpdateTimeMsec_ = lastFrameUpdateTimeMsec_;
			fpsAvg_ = 0;
			sumElapsedTimesMsec_ = 0;
			
			stage_.align = StageAlign.TOP_LEFT;
			stage_.scaleMode = StageScaleMode.NO_SCALE;
			stage_.addEventListener(Event.RESIZE, stageResized);
			stage_.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onStageOrientationChanged);
			stage_.addEventListener(Event.ENTER_FRAME, onFrameEnter);
			
			stage_.addEventListener(Event.ADDED, onObjectAddedToStage);
			stage_.addEventListener(Event.REMOVED, onObjectRemovedFromStage);
		}
		
		public function addToStage(o:DisplayObject):void {
			stage_.addChild(o);
		}
		
		public function removeFromStage(o:DisplayObject):void {
			stage_.removeChild(o);
		}
		
		public function moveToFront(o:DisplayObject):void {
			if (o.parent == stage_) {
				if (stage_.getChildAt(stage_.numChildren - 1) != o) {
					stage_.removeChild(o);
					stage_.addChild(o);
				}
			}			
		}
		
		private function onObjectAddedToStage(event:Event):void {
			var obj:DisplayObject = event.target as DisplayObject;
			var stageObj:IStageObject = obj as IStageObject;
			if (stageObj) {
				trace("I stageObject added: " + stageObj); 
			}
		}
		
		private function onObjectRemovedFromStage(event:Event):void {
			var obj:DisplayObject = event.target as DisplayObject;
			var stageObj:IStageObject = obj as IStageObject;
			if (stageObj) {
				trace("I stageObject removed: " + stageObj);
			}
		}
		
		public function addFrameUpdateObject(o:IFrameUpdateObject, beforeDisplay:Boolean):void {
			frameUpdateObjectDict_.push(o);
		}
		
		private function onFrameEnter(event:Event):void {
			frameNumber_++;
			var curTime:int = getTimer();
			var frameElapsedTimeMsec:int = curTime - lastFrameUpdateTimeMsec_;
			var fpsUpdateElapsedMsec:int = curTime - lastFpsUpdateTimeMsec_;
			updateFrameAllObjects(curTime, frameElapsedTimeMsec / 1000);
			
			if (curTime - lastFpsUpdateTimeMsec_ > 1000) {
				lastFpsUpdateTimeMsec_ = curTime;
				fpsAvg_ = numFramesSinceLastUpdate_;
				infoText_.setText("frame updater", "fps avg: " + fpsAvg_ + ", total elapsed time accuracy: " + (sumElapsedTimesMsec_ / 10) + "%");
				numFramesSinceLastUpdate_ = 0;
				sumElapsedTimesMsec_ = 0;
			} else {
				numFramesSinceLastUpdate_++;
				sumElapsedTimesMsec_ += frameElapsedTimeMsec;
			}
			lastFrameUpdateTimeMsec_ = curTime;
			
			infoText_.onPrepareToRender(event);
		}
		
		private function updateFrameAllObjects(frameStartTimeMsec:int, frameElapsedTime:Number):Boolean {
			for (var i:int = 0; i < frameUpdateObjectDict_.length; i++) {
				var o:IFrameUpdateObject = frameUpdateObjectDict_[i];
				if (!o.onFrameUpdate(frameNumber_, frameStartTimeMsec, frameElapsedTime)) {
					return false;
				}
			}
			return handleStagePropertyChanged("frame update", false, function(stageObj:IStageObject):Boolean {
				return stageObj.onFrameUpdate(frameNumber_, frameStartTimeMsec, frameElapsedTime);
			});
		}
		
		private function stageResized(event:Event):void {
			if (!isNaN(stageWidth_) &&
				(stageWidth_ == stage_.stageWidth) &&
				(stageHeight_ == stage_.stageHeight)) {
				trace("I stage resized but same - ignore");
				return;
			}
			trace("I <<<<< stage event RESIZE: " + stage_.stageWidth + " x " + stage_.stageHeight + " <<<<< begin");
			infoText_.setText("stageUtil", "stageResized to " +  stage_.stageWidth + ", " + stage_.stageHeight);
			stageWidth_ = stage_.stageWidth;
			stageHeight_ = stage_.stageHeight;
			handleStagePropertyChanged("width and height", true, function(stageObj:IStageObject):Boolean {
				stageObj.onStageResized();
				return true;
			});
			trace("I >>>>> stage event RESIZE");
		}
		
		private function handleStagePropertyChanged(type:String, addTrace:Boolean, func:Function):Boolean {
			for (var i:int = 0; i < stage_.numChildren; i++) {
				var childObj:DisplayObject = stage_.getChildAt(i);
				var stageObj:IStageObject = childObj as IStageObject;
				if (stageObj) {
					if (addTrace) {
						trace("I   callback stageObj " + stageObj);
					}
					if (!func(stageObj)) {
						trace("W   --> abort in handleStagePropertyChanged " + type + ", requested by " + stageObj);
						return false;
					}
				}
			}
			return true;
		}
		
		private function onStageOrientationChanged(event:Event):void {
			trace("I stage orientation changed, stage ori: " + stage_.orientation + 
				" device ori: " + stage_.deviceOrientation);
		}
	}
}

internal class Lock{}