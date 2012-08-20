package core
{
	import flash.utils.Dictionary;

	public class GameConfig
	{
		static private var instance_ : GameConfig = null;
		static private var configDict_:Dictionary;
		
		// un-configurable values (compile time fixed)
		static public const DEBUGGING_ENABLED:Boolean = true;
		
		// user configurable values (to do)
		static public var TABLE_HEIGHT_PERCENT:String = "table_height_percent";	// in screen
		
		
		static public function getSingleton() : GameConfig {
			if ( instance_ == null ) instance_ = new GameConfig( new Lock() );
			return instance_;
		}
		
		public function GameConfig( lock : Lock ) {
			if ( lock == null ) throw new Error("Singleton not allowed bla bla bla");
			
			configDict_ = new Dictionary();
			configDict_[TABLE_HEIGHT_PERCENT] = 40;
		}
		
		public function get(key:String):int {
			return configDict_[key];
		}
	}
}

internal class Lock{}