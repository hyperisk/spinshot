package core
{
	public interface IFrameUpdateObject
	{
		// return false to abort update 
		function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number):Boolean;
		
		// must be unique, start with prefix in StageUtil
		function getDictKey():String;
	}
}