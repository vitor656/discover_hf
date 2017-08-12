package;
import states.PlayState;
import flixel.util.FlxSave;

/**
 * ...
 * @author ...
 */
class Reg 
{

	public static var levels:Array<String> = ["level1", "level2"];
	public static var currentLevel:Int = 0;
	
	public static var PS:PlayState;
	public static var score:Int = 0;
	public static var coins:Int = 0;
	public static var lives:Int = 3;
	public static var time:Float = 300;
	public static var level:Int = 0;
	public static var pause:Bool = false;
	
	private inline static var SAVE_DATA:String = "HAXEFLIXELGAME";
	public static var save:FlxSave;
	
	public static var checkPointReched:Bool = false;

	public static function saveScore():Void
	{
		save = new FlxSave();
		
		if (save.bind(SAVE_DATA))
		{
			if (save.data.score == null || save.data.score < Reg.score)
			{
				save.data.score = Reg.score;
			}
		}
		
		save.flush();
	}
	
	public static function loadScore():Int
	{
		save = new FlxSave();
		
		if (save.bind(SAVE_DATA))
		{
			if (save.data != null && save.data.score != null)
			{
				return save.data.score;
			}
		}
		
		return 0;
	}
}