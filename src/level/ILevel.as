package level
{
	import core.LevelManager;

	public interface ILevel
	{
		function init(lm:LevelManager):void;
		function startPlay():void;
		function endPlay():void;
	}
}