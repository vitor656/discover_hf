package objects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Coin extends FlxSprite 
{

	private static var SCORE_AMOUNT:Int = 20;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.items__png, true, 16, 16);
		
		animation.add("idle", [0, 1, 2, 3, 4], 16);
		animation.play("idle");
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if(!Reg.pause)
			super.update(elapsed);
	}
	
	public function collect():Void
	{
		FlxG.sound.play("coin");
		Reg.score += SCORE_AMOUNT;
		Reg.coins++;
		if (Reg.coins >= 100)
		{
			Reg.lives++;
			Reg.coins = 0;
		}
		
		kill();
	}
	
	public function setFromBlock()
	{
		solid = false;
		acceleration.y = 420;
		velocity.y = -90;
		new FlxTimer().start(0.3, function(_){
			collect();
		}, 1);
	}
	
}