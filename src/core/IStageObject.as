package core
{
	public interface IStageObject
	{
		function onStageResized(fakeEvent:Boolean=false): void;
		
		// return false to abort update 
		function onFrameUpdate(frameNumber:int, frameStartTimeMsec:int, frameElapsedTime:Number): Boolean;
	}
}