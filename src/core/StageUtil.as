package core
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	// to add debugging message to stage:
	// StageUtil.getSingleton().infoText_.setText(title, message)
	
	public class StageUtil
	{
		static private var instance_ : StageUtil = null;
		
		public var stageWidth_:int;	// to check if stage resize event actually changed the size
		public var stageHeight_:int;
		private var stage_:Stage;
		
		public var userInput_:UserInputUtil;
		public var infoText_:InfoText;
		
		private var frameNumber_:int;
		private var lastFrameUpdateTimeMsec_:int;
		public var fpsAvg_:int;
		public var curFrameStartTimeMsec_:int;
		public var lastFpsUpdateTimeMsec_:int;
		private var numFramesSinceLastUpdate_:int;
		private var sumElapsedTimesMsec_:Number;
		
		private var frameUpdateObjects_:Dictionary;
		public static const FRAMEUPDATE_KEY_1_SIM:String = "1_sim_";
		public static const FRAMEUPDATE_KEY_1_RENDER:String = "2_render_";
		
		static public function getSingleton() : StageUtil {
			if ( instance_ == null ) instance_ = new StageUtil( new Lock() );
			return instance_;
		}
		
		public function StageUtil( lock : Lock ) {
			if ( lock == null ) throw new Error("Singleton not allowed bla bla bla");
			frameUpdateObjects_ = new Dictionary();
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
			//trace("I added to stage: " + obj); 
		}
		
		private function onObjectRemovedFromStage(event:Event):void {
			var obj:DisplayObject = event.target as DisplayObject;
			//trace("I removed from stage: " + obj); 
		}
		
		public function addFrameUpdateObject(o:IFrameUpdateObject):void {
			if (!o.getDictKey()) {
				throw new Error("frame update object invalid key"); 
			}
			if (frameUpdateObjects_.hasOwnProperty(o.getDictKey())) {
				throw new Error("frame update object already added: " + o.getDictKey()); 
			}
			frameUpdateObjects_[o.getDictKey()] = o;
		}
		
		public function removeFrameUpdateObject(o:IFrameUpdateObject):void {
			if (!frameUpdateObjects_.hasOwnProperty(o.getDictKey())) {
				throw new Error("frame update object not found: " + o.getDictKey()); 
			}
			delete frameUpdateObjects_[o.getDictKey()]
		}
		
		private function onFrameEnter(event:Event):void {
			frameNumber_++;
			curFrameStartTimeMsec_ = getTimer();
			var frameElapsedTimeMsec:int = curFrameStartTimeMsec_ - lastFrameUpdateTimeMsec_;
			var fpsUpdateElapsedMsec:int = curFrameStartTimeMsec_ - lastFpsUpdateTimeMsec_;
			updateFrameAllObjects(curFrameStartTimeMsec_, frameElapsedTimeMsec / 1000);
			
			if (curFrameStartTimeMsec_ - lastFpsUpdateTimeMsec_ > 1000) {
				lastFpsUpdateTimeMsec_ = curFrameStartTimeMsec_;
				fpsAvg_ = numFramesSinceLastUpdate_;
				infoText_.setText("frame updater", "fps avg: " + fpsAvg_ + ", total elapsed time accuracy: " + (sumElapsedTimesMsec_ / 10) + "%");
				numFramesSinceLastUpdate_ = 0;
				sumElapsedTimesMsec_ = 0;
			} else {
				numFramesSinceLastUpdate_++;
				sumElapsedTimesMsec_ += frameElapsedTimeMsec;
			}
			lastFrameUpdateTimeMsec_ = curFrameStartTimeMsec_;
			
			infoText_.onPrepareToRender(event);
		}
		
		private function updateFrameAllObjects(frameStartTimeMsec:int, frameElapsedTime:Number):Boolean {
			// iterate throw values in dictionary!
			// compared to foreach (var k:KeyType...)
			for each (var o:IFrameUpdateObject in frameUpdateObjects_) {
				if (!o.onFrameUpdate(frameNumber_, frameStartTimeMsec, frameElapsedTime)) {
					trace("I abort frame update by " + o);
					return false;
				}
			}
			return true;
		}
	}
}

internal class Lock{}