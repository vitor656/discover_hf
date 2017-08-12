package objects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import flixel.FlxG;
/**
 * ...
 * @author ...
 */
class PowerUp extends FlxSprite 
{

	private static inline var MOVE_SPEED:Int = 40;
	private static inline var GRAVITY:Int = 420;
	private static inline var SCORE_AMOUNT:Int = 20;
	
	public var direction:Int = -1;
	private var _moving:Bool = false;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.items__png, true, 16, 16);
		animation.add("idle", [5]);
		animation.play("idle");
		
		velocity.y = -16;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!Reg.pause)
		{
			if (!_moving && Math.floor(y) % 16 == 0)
			{
				velocity.y = 0;
				acceleration.y = GRAVITY;
				_moving = true;
			}
			
			if (_moving)
				velocity.x = direction * MOVE_SPEED;
				
			if (justTouched(FlxObject.WALL))
				direction = -direction;
		}
		
		super.update(elapsed);
	}
	
	public function collect(player:Player):Void
	{
		FlxG.sound.play("powerup");

		kill();
		
		if (player.health == 0)
			player.powerUp();
		else
			Reg.score += SCORE_AMOUNT;
	}
	
}