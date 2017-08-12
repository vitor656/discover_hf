package objects;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import utils.ControlsHandler;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite 
{

	public static inline var ACCELERATION:Int = 320;
	public static inline var DRAG:Int = 320;
	public static inline var GRAVITY:Int = 600;
	public static inline var JUMP_FORCE:Int = -280;
	public static inline var WALK_SPEED:Int = 80;
	public static inline var RUN_SPEED:Int = 140;
	public static inline var FALLING_SPEED:Int = 300;
	
	public var direction:Int = 1;
	
	private var _stopAnimations:Bool = false;
	public var flickering:Bool = false;
	
	public function new() 
	{
		super();
		
		health = 0;
		reloadGraphics();
		
		drag.x = DRAG;
		acceleration.y = GRAVITY;
		maxVelocity.set(WALK_SPEED, FALLING_SPEED);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!Reg.pause)
		{
			move();		
		}
		
		if(!_stopAnimations)
			animate();
		
		super.update(elapsed);
	}
	
	private function reloadGraphics():Void
	{
		loadGraphic(AssetPaths.player_both__png, true, 16, 32);
		switch (health) 
		{
			case 0:
				setSize(8, 12);
				offset.set(4, 20);
				
				animation.add("idle", [0]);
				animation.add("walk", [1, 2, 3, 2], 12);
				animation.add("skid", [4]);
				animation.add("jump", [5]);
				animation.add("fall", [5]);
			case 1:
				setSize(8, 24);
				offset.set(4, 8);
				
				animation.add("idle", [7]);
				animation.add("walk", [8, 9, 10, 9], 12);
				animation.add("skid", [11]);
				animation.add("jump", [12]);
				animation.add("fall", [12]);
		}
		
		animation.add("dead", [6]);
		animation.add("transform", [5, 12], 24);
	}
	
	public function powerUp()
	{
		if (health >= 1)
			return;
			
		var _prevVelocity:FlxPoint = new FlxPoint().copyFrom(velocity);
		var _prevAccel:FlxPoint = new FlxPoint().copyFrom(acceleration);
		
		Reg.pause = true;
		_stopAnimations = true;
		animation.play("transform");
		velocity.set(0,0);
		acceleration.set(0, 0);
		
		new FlxTimer().start(1.0, function(_)
		{
			health++;
			reloadGraphics();
			y -= 16;
			
			Reg.pause = false;
			_stopAnimations = false;
			velocity = _prevVelocity;
			acceleration = _prevAccel;
		});
	}
	
	public function damage()
	{
		if (FlxSpriteUtil.isFlickering(this) || Reg.pause)
			return;
			
		if (health > 0)
		{
			var _prevVelocity:FlxPoint = new FlxPoint().copyFrom(velocity);
			var _prevAccel:FlxPoint = new FlxPoint().copyFrom(acceleration);
			
			Reg.pause = true;
			_stopAnimations = true;
			animation.play("transform");
			velocity.set(0,0);
			acceleration.set(0, 0);
			
			new FlxTimer().start(1.0, function(_)
			{
				health--;
				reloadGraphics();
				y += 16;
				FlxSpriteUtil.flicker(this, 2.0, 0.04, true);
				Reg.pause = false;
				_stopAnimations = false;
				velocity = _prevVelocity;
				acceleration = _prevAccel;
			});
		}
		else 
			kill();
	}
	
	override public function kill():Void 
	{
		if (alive)
		{

			FlxG.sound.play("death");
			FlxG.sound.music.stop();

			FlxG.camera.shake(0.01, 0.2);

			alive = false;
			velocity.set(0, 0);
			acceleration.set(0, 0);
			Reg.lives -= 1;
			Reg.pause = true;
			
			new FlxTimer().start(2, function(_){
				FlxG.sound.play("dying");
				acceleration.y = GRAVITY;
				velocity.y = JUMP_FORCE;
			}, 1);
			
			new FlxTimer().start(6, function(_){

				FlxG.cameras.fade(FlxColor.BLACK, .2, false, function(){
					FlxG.resetState();
					Reg.pause = false;
				});

				
			});
		}
	}
	
	private function move():Void
	{
		acceleration.x  = 0;
		

		if (ControlsHandler.keyPressedLeft())
		{
			flipX = true;
			direction = -1;
			acceleration.x -= ACCELERATION;
		}
		else if (ControlsHandler.keyPressedRight())		
		{
			flipX = false;
			direction = 1;
			acceleration.x += ACCELERATION;
		}
		
		if (velocity.y == 0)
		{
			if (ControlsHandler.keyJustPressedJump() && isTouching(FlxObject.FLOOR))
			{
				jump();
				FlxG.sound.play("jump");
			}
			
			if (ControlsHandler.keyPressedRun())
				maxVelocity.x = RUN_SPEED;
			else
				maxVelocity.x = WALK_SPEED;
		}
		
		if (velocity.y < 0 && ControlsHandler.keyReleasedJump())
		{
			velocity.y = velocity.y * 0.5;
		}
		
		if (y > Reg.PS.map.height - height)
			kill();
		
		if (x < 0)
			x = 0;
	}
	
	public function jump():Void
	{
		if(ControlsHandler.keyPressedJump())
			velocity.y = JUMP_FORCE;
		else 
			velocity.y = JUMP_FORCE / 2;
	}
	
	private function animate():Void
	{
		if (!alive)
		{
			animation.play("dead");
		}
		else if (velocity.y <= 0 && !isTouching(FlxObject.FLOOR))
		{
			animation.play("jump");
		}
		else if (velocity.y > 0)
		{
			animation.play("fall");
		} 
		else if (velocity.x == 0)
		{
			animation.play("idle");
		}
		else
		{
			if (FlxMath.signOf(velocity.x) != FlxMath.signOf(direction))
			{
				animation.play("skid");
			}
			else
			{
				animation.play("walk");
			}
		}
	}
	
}