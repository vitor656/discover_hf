package states;

import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flash.system.System;

/**
 * ...
 * @author ...
 */
class IntroSubState extends FlxSubState 
{

	private var _text:FlxText;
	private var _iconLives:FlxSprite;
	private var _textLives:FlxText;
	private var _gameOver:Bool = false;
	private var _waitToDisappear:Float = 3.0;

	private var _gameFinished:Bool = false;
	
	public function new(?BGColor:FlxColor = FlxColor.TRANSPARENT){
		super(BGColor);
	}
	
	override public function create():Void 
	{
		super.create();
		
		FlxG.cameras.fade(FlxColor.BLACK, .2, true);

		if (Reg.lives < 0)
			_gameOver = true;
		
		if(Reg.currentLevel >= Reg.levels.length)
			_gameFinished = true;

		_text = new FlxText(0, FlxG.height / 2 + 8, FlxG.width,  "Get Ready!");
		_textLives = new FlxText(FlxG.width * 0.5, FlxG.height / 2 - 8, FlxG.width, "x " + Reg.lives);
		
		_iconLives = new FlxSprite(FlxG.width * 0.5 - 12, FlxG.height / 2 - 8);
		_iconLives.loadGraphic(AssetPaths.hud__png, true, 8, 8);
		_iconLives.animation.add("life", [1], 0);
		_iconLives.animation.play("life");
		
		add(_text);
		
		if (_gameOver)
		{
			_text.text = "Game Over";
			_text.setPosition(0, FlxG.height / 2);
		}
		else
		{
			if (_gameFinished)
			{
				_text.text = "Thanks for Playing!";
				_text.setPosition(0, FlxG.height/2);
				_waitToDisappear = 5.0;
			}
			else
			{
				add(_iconLives);
				add(_textLives);
			}
		}
		
		forEachOfType(FlxObject, function(member)
		{
			member.scrollFactor.set(0, 0);
		});
		
		forEachOfType(FlxText, function(member)
		{
			member.setFormat(AssetPaths.pixel_font__ttf, 8, FlxColor.WHITE,
				FlxTextBorderStyle.OUTLINE, 0xff005784);
		});
		
		_text.alignment = FlxTextAlign.CENTER;
		
		new FlxTimer().start(_waitToDisappear, function(_)
		{
			if (_gameOver || _gameFinished)
			{
				Reg.saveScore();
				Reg.lives = 2;
				FlxG.switchState(new MenuState());
			}
			else
			{
				FlxG.sound.playMusic("pixelland");
				FlxG.camera.fade(FlxColor.BLACK, .2, false, function(){
					
					FlxG.camera.fade(FlxColor.BLACK, .2, true);
					close();
				});
				
				
			}
			
		} , 1);
	}
	
}