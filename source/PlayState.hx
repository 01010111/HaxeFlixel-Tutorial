package;

import flixel.FlxObject;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import openfl.Assets;

class PlayState extends FlxState
{
	var player:Player;
	var exit:FlxSprite;
	var coins:FlxGroup;
	var collectedCoins:Int = 0;
	public var level:FlxTilemap;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF6DC2CA;
		Reg.state = this;
		
		addLevel();
		addPlayer(2, 22);
		addExit(118, 19);
		addCoins();
		addUIText();
		setCamera();
		
		super.create();
	}
	
	function addLevel():Void
	{
		level = new FlxTilemap();
		level.loadMap(Assets.getText("assets/data/Map1_Level.csv"), "assets/images/tiles.png", 16, 16);
		for (i in 16...31) level.setTileProperties(i, FlxObject.UP);
		for (i in 32...63) level.setTileProperties(i, FlxObject.NONE);
		add(level);
	}
	
	function addPlayer(X:Int, Y:Int):Void
	{
		player = new Player(X, Y);
		add(player);
	}
	
	function addExit(X:Int, Y:Int):Void
	{
		exit = new FlxSprite(X * 16, Y * 16 - 16);
		#if debug
		exit.makeGraphic(16, 32, 0x80FF0000);
		#else
		exit.makeGraphic(16, 32, 0x00000000);
		#end
		add(exit);
	}
	
	function addCoins():Void
	{
		coins = new FlxGroup();
		add(coins);
		
		addCoin(15, 13);
		addCoin(45, 20);
		addCoin(46, 20);
		addCoin(47, 20);
		addCoin(80, 14);
		addCoin(81, 14);
		addCoin(82, 14);
		addCoin(72, 2);
		addCoin(74, 2);
		addCoin(76, 2);
	}
	
	function addCoin(X:Int, Y:Int):Void
	{
		var coin:Coin = new Coin(X, Y);
		coins.add(coin);
	}
	
	var coinsText:FlxText;
	
	function addUIText():Void
	{
		coinsText = new FlxText(0, 0, FlxG.width);
		coinsText.scrollFactor.set();
		coinsText.setFormat(null, 8, 0xdeeed6, "center", FlxText.BORDER_SHADOW, 0x4e4a4e);
		add(coinsText);
	}
	
	function setCamera():Void
	{
		FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
		FlxG.camera.setBounds(0, 0, level.width - 16, level.height - 16, true);
	}
	
	override public function update():Void
	{
		setUIText();
		
		FlxG.collide(level, player);
		FlxG.overlap(coins, player, getCoin);
		FlxG.overlap(exit, player, winGame);
		
		super.update();
	}
	
	function setUIText():Void
	{
		coinsText.text = "COINSx" + collectedCoins;
	}
	
	function getCoin(c:Coin, p:Player):Void
	{
		if (c.alive) {
			c.kill();
			collectedCoins++;
		}
	}
	
	function winGame(e:FlxSprite, p:Player):Void
	{
		if (p.isTouching(FlxObject.FLOOR) && !p.hasWon) {
			p.velocity.x = 0;
			p.acceleration.x = 0;
			p.animation.play("check");
			p.hasWon = true;
			new FlxTimer(1, leaveStage);
		}
	}
	
	public function leaveStage(?t:FlxTimer):Void
	{
		openSubState(new WinState());
	}
	
	public function gameOver(?t:FlxTimer):Void
	{
		openSubState(new GameOver());
	}
	
}