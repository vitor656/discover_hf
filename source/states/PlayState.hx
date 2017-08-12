package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.math.FlxPoint;
import objects.Coin;
import objects.Player;
import objects.Enemy;
import objects.BonusBlock;
import objects.PowerUp;
import objects.Goal;
import utils.LevelLoader;
import flixel.ui.FlxVirtualPad;

class PlayState extends FlxState
{
	public var map:FlxTilemap;
	public var player(default, null):Player;
	public var items(default, null):FlxTypedGroup<FlxSprite>;
	public var enemies(default, null):FlxTypedGroup<Enemy>;
	public var blocks(default, null):FlxTypedGroup<FlxSprite>;
	private var _hud:HUD;
	private var _entities:FlxGroup;
	private var _terrain:FlxGroup;
	
	private var _gameCamera:FlxCamera;
	private var _hudCamera:FlxCamera;
	
	public var checkpoint:FlxPoint;

	#if mobile
		public var virtualPad:FlxVirtualPad;
	#end
	
	override public function create():Void
	{
		#if !mobile
		FlxG.mouse.visible = false;
		#end

		Reg.PS = this;
		Reg.pause = false;
		Reg.time = 300;
		
		_gameCamera = new FlxCamera();
		_hudCamera = new FlxCamera();
		FlxG.cameras.reset(_gameCamera);
		FlxG.cameras.add(_hudCamera);
		_hudCamera.bgColor = FlxColor.TRANSPARENT;
		FlxCamera.defaultCameras = [_gameCamera];
		
		player = new Player();
		items = new FlxTypedGroup<FlxSprite>();
		enemies = new FlxTypedGroup<Enemy>();
		blocks = new FlxTypedGroup<FlxSprite>();
		_hud = new HUD();
		_entities = new FlxGroup();
		_terrain = new FlxGroup();
		
		_hud.setCamera(_hudCamera);
		
		LevelLoader.loadLevel(this, Reg.levels[Reg.currentLevel]);
		
		_entities.add(items);
		_entities.add(blocks);
		_entities.add(enemies);
		
		_terrain.add(map);
		_terrain.add(blocks);
		
		add(player);
		add(_entities);
		add(_hud);
		
		#if mobile
			virtualPad = new FlxVirtualPad(LEFT_RIGHT, A_B);
			virtualPad.alpha = 0.75;
			add(virtualPad);
		#end

		
		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);
		
		openSubState(new IntroSubState(FlxColor.BLACK));
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		#if !mobile

		if (FlxG.keys.justReleased.F1)
			FlxG.fullscreen = !FlxG.fullscreen;
		
		if (FlxG.keys.justReleased.F3)
			FlxG.resetState();
		
		#end

		if (player.alive)
		{
			FlxG.overlap(_entities, player, collideEntities);
			FlxG.collide(_terrain, player);
		}
		
		FlxG.collide(_terrain, _entities);
		FlxG.collide(enemies, enemies);
		
		updateTime(elapsed);
		updateCheckpoint();
		
		super.update(elapsed);
	}
	
	function collideEntities(entity:FlxSprite, player:Player):Void
	{
		if (Std.is(entity, Coin))
			(cast entity).collect();
			
		if (Std.is(entity, Enemy))
			(cast entity).interact(player);
			
		if (Std.is(entity, BonusBlock))
			(cast entity).hit(player);
			
		if (Std.is(entity, PowerUp))
			(cast entity).collect(player);

		if(Std.is(entity, Goal))
			(cast entity).reach(player);
	}
	
	private function updateTime(elapsed:Float):Void
	{
		if (!Reg.pause)
		{
			if (Reg.time > 0)
				Reg.time -= elapsed;
			else
			{
				Reg.time = 0;
				player.kill();
			}
		}
	}

	private function updateCheckpoint():Void
	{
		if(checkpoint == null || Reg.checkPointReched)
			return;

		if(player.x >= checkpoint.x)
		{
			trace("Checkpoint Reached!");
			Reg.checkPointReched = true;
		}
	}

	public function nextLevel():Void
	{
		Reg.checkPointReched = false;
		checkpoint = null;
		Reg.currentLevel++;
		
		FlxG.cameras.fade(FlxColor.BLACK, .2, false, function(){
			if (Reg.currentLevel < Reg.levels.length)
				FlxG.resetState();
			else
				FlxG.switchState(new IntroSubState(FlxColor.BLACK));
		});

	
	}

}
