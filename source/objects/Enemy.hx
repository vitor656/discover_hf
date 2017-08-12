package objects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Enemy extends FlxSprite 
{

	private static inline var GRAVITY:Int = 600;
	private static inline var WALK_SPEED:Int = 80;
	private static inline var FALLING_SPEED:Int = 300;
	private static inline var SCORE_AMOUNT:Int = 100;
	
	private var _direction:Int = -1;
	private var _appeared:Bool = false;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		
		setSize(12, 12);
		offset.set(2, 4);
		
		acceleration.y = GRAVITY;
		maxVelocity.y = FALLING_SPEED;
		
		flipX = true;
		_direction = -1;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!inWorldBounds())
			exists = false;
			
		if (isOnScreen())
			_appeared = true;
			
		if (_appeared && alive)
		{
			move();
			
			if (justTouched(FlxObject.WALL))
				flipDirection();
		}
		
		if(!Reg.pause)
			super.update(elapsed);
	}
	
	override public function kill():Void 
	{
		alive = false;
		Reg.score += SCORE_AMOUNT;
		
		FlxG.sound.play("defeat");

		velocity.x = 0;
		acceleration.x = 0;
		animation.play("dead");
		
		new FlxTimer().start(1, function(_){
			exists = false;
			visible = false;
		}, 1);
	}
	
	private function flipDirection():Void
	{
		flipX = !flipX;
		_direction = -_direction;
	}
	
	private function move():Void
	{
		
	}
	
	public function interact(player:Player):Void
	{
		if (!alive)
			return;
			
		FlxObject.separateY(this, player);
		
		if (player.velocity.y > 0 && isTouching(FlxObject.UP))
		{
			kill();
			player.jump();
		}
		else
			player.damage();
	}
}