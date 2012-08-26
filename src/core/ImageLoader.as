package core
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class ImageLoader
	{
		private static var instance_ : ImageLoader = null;
		private static const imageNames_:Array = [
			"mainmenu_button_start_72.png",
			"mainmenu_button_help_72.png",
			"level_button_replay_72.png",
			"level_button_quit_72.png"
		];
		private static const IMAGE_DIR:String = "assets";
		private var appDirFile_:File = File.applicationDirectory;
		private var loaders_:Dictionary;
		private var bitmaps_:Dictionary;
		private var loadingImageIndex_:int;
		private var loadCompleteEventListener_:Function;

		static public function getSingleton() : ImageLoader {
			if ( instance_ == null ) instance_ = new ImageLoader( new Lock() );
			return instance_;
		}
		
		public function ImageLoader( lock : Lock ) {
			if ( lock == null ) throw new Error("Singleton not allowed bla bla bla");
			loaders_ = new Dictionary();
			bitmaps_ = new Dictionary();
		}
		
		public function loadAllImages(loadCompleteEventListener:Function):void {
			loadCompleteEventListener_ = loadCompleteEventListener;
			for (var i:int = 0; i < imageNames_.length; i++) {
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNextImage);
				loaders_[imageNames_[i]] = loader;
			}
			loadingImageIndex_ = 0;
			loadNextImage(null);
		}
		
		private function loadNextImage(event:Event):void {
		    if (loadingImageIndex_ > 0) {
				var loadedImageName:String = imageNames_[loadingImageIndex_ - 1];
				bitmaps_[loadedImageName] = event.target.content as Bitmap;
		    }
			var loadingImageName:String = imageNames_[loadingImageIndex_];
			var imgFile_:File = appDirFile_.resolvePath(IMAGE_DIR + File.separator + loadingImageName);
			var req:URLRequest = new URLRequest(imgFile_.url);
			trace("loading file " + imgFile_.url);
			if (loadingImageIndex_ < imageNames_.length) {
				loadingImageIndex_++;
				loaders_[loadingImageName].load(req);
			} else {
				loadCompleteEventListener_();
			}
		}
		
		public function getBitmap(name:String):Bitmap {
			if (!bitmaps_.hasOwnProperty(name)) {
				throw new Error("invalid bitmap name " + name);
			}
			return bitmaps_[name];
		}
	}
}

internal class Lock{}