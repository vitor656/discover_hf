package objects;

/**
 * ...
 * @author ...
 */
class WalkEnemy extends Enemy 
{

	private static var WALK_SPEED:Int = 40;
	private static var SCORE_AMOUNT:Int = 100;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.enemyA__png, true, 16, 16);
		animation.add("walk", [0, 1, 2, 1], 12);
		animation.add("dead", [3], 12);
		animation.play("walk");
		
		setSize(12, 12);
		offset.set(2, 4);
	}
	
	override function move():Void 
	{
		velocity.x = _direction * WALK_SPEED;
	}
	
}