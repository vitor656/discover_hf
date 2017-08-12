package objects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author ...
 */
class BonusBlock extends FlxSprite 
{
	
	public var content:String;
	
	private var _empty:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		solid = true;
		immovable = true;
		
		loadGraphic(AssetPaths.items__png, true, 16, 16);
		animation.add("idle", [7]);
		animation.add("empty", [8]);
		animation.play("idle");
		
	}
	
	public function hit(player:Player):Void
	{
		FlxObject.separate(this, player);
		
		if (!_empty && isTouching(FlxObject.DOWN))
		{
			FlxTween.tween(this, {y: y - 4}, 0.05, {onComplete: createItem})
				.wait(0.05)
				.then(FlxTween.tween(this, {y: y}, 0.05, {onComplete: empty}));
		}
	}
	
	private function empty(_):Void
	{
		_empty = true;
		animation.play("empty");
	}
	
	private function createItem(_)
	{
		switch (content) 
		{
			case "powerup":
				var _pwrUp:PowerUp = new PowerUp(Std.int(x), Std.int(y));
				Reg.PS.items.add(_pwrUp);
			default:
				var _coin:Coin = new Coin(Std.int(x), Std.int(y - 16));
				_coin.setFromBlock();
				Reg.PS.items.add(_coin);
		}
	}
}