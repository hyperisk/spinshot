package core
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class UserInputUtil extends EventDispatcher
	{
		public var touchPointSupported:Boolean;
		private var stage_:Stage;
		private var infoText_:InfoText;
		protected var isMultitouch:Boolean;
		public var keyDownCharCode_:int;
		public var keyDownShift_:Boolean;
		
		public function UserInputUtil(stage:Stage, infoText:InfoText, target:IEventDispatcher=null)
		{
			super(target);
			stage_ = stage;
			infoText_ = infoText;
			keyDownCharCode_ = -1;
			
			try {
				trace("I multitouch capabilities on this device:");
				trace("    screen type:", Capabilities.touchscreenType);
				trace("    touch-level access?", Multitouch.supportsTouchEvents);
				trace("    gesture-level access?", Multitouch.supportsGestureEvents);
				trace("    number of touch points:", Multitouch.maxTouchPoints);
				if (Multitouch.supportsGestureEvents) {
					trace("    supported gestures {");
					for each (var gestureName:String in Multitouch.supportedGestures) {
						trace("     -", gestureName);
					}
					trace("}");
				}
				//remember whether multitouch mode is on
				isMultitouch = Multitouch.maxTouchPoints > 1;
				if (Multitouch.supportsTouchEvents) {
					touchPointSupported = true;
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
					trace("I touch initialized to MultitouchInputMode.TOUCH_POINT, maxTouchPoints: " + Multitouch.maxTouchPoints);
				} else {
					touchPointSupported = false;
					trace("W touch input is NOT supported");
				}
				//anything using the Multitouch class
			} catch (error:ReferenceError) {
				//you must not have FP10.1+
				trace("E " + error.toString());
				touchPointSupported = false;
			}
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			if (event.charCode == 126) {	// tilde (F15?)
				infoText_.toggleAll();
			} else { 
				keyDownCharCode_ = event.charCode;
			}
		    keyDownShift_ = event.shiftKey; 
//			trace("I key down " + event.charCode + ", shift: " + event.shiftKey);
		}
		
		private function onKeyUp(event:KeyboardEvent):void {
			keyDownCharCode_ = -1;
		    keyDownShift_ = event.shiftKey; 
//			trace("I key up 	" + event.charCode + ", shift: " + event.shiftKey);
		}
	}
	
}