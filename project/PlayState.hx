package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import openfl.Assets;

class PlayState extends FlxState
{
	var player:Player;
	var levelObjects:FlxGroup;
	var level:Int;
	var exit:Exit;
	var coins:FlxGroup;
	
	public function new(LEVEL:Int = 1):Void
	{
		super();
		level = LEVEL;
	}
	
	override public function create():Void
	{
		init();
		addLevel();
		addObjects();
		addText();
		setCamera();
		
		super.create();
	}
	
	function init():Void
	{
		Reg.timer = 60;
		Reg.coins = 0;
		FlxG.mouse.visible = false;
		FlxG.camera.bgColor = 0xff6dc2ca;
		Reg.hasWon = false;
	}
	
	function addLevel():Void
	{
		Reg.level = new FlxTilemap();
		Reg.level.loadMap("assets/data/Map" + level + "_Level.csv", "assets/images/tiles.png", Reg.tileWidth, Reg.tileWidth);
		for (i in 16...31) Reg.level.setTileProperties(i, FlxObject.UP);
		for (i in 32...63) Reg.level.setTileProperties(i, FlxObject.NONE);
		add(Reg.level);
	}
	
	function addObjects():Void
	{
		Reg.enemies = new FlxTypedGroup();
		levelObjects = new FlxGroup();
		add(levelObjects);
		coins = new FlxGroup();
		add(coins);
		
		var objectData:String = Assets.getText("assets/data/Map" + level + "_Objects.csv");
		var rows:Array<String> = objectData.split("\n");
		for (y in 0...rows.length) {
			var objectsString:Array<String> = rows[y].split(",");
			var objects:Array<Int> = new Array();
			for (i in 0...objectsString.length) objects.push(Std.parseInt(objectsString[i]));
			for (x in 0...objects.length) {
				switch(objects[x]) {
					case 1: addPlayer(x, y);
					case 2: makeDumbEnemy(x, y);
					case 3: makeSmartEnemy(x, y);
					case 4: makeCoin(x, y);
					case 15: makeExit(x, y);
				}
			}
		}
		
		levelObjects.add(player);
	}
	
	function addPlayer(X:Int, Y:Int):Void
	{
		player = new Player(X, Y);
	}
	
	function makeSmartEnemy(X:Int, Y:Int):Void
	{
		var e:SmartEnemy = new SmartEnemy(X, Y);
		levelObjects.add(e);
	}
	
	function makeDumbEnemy(X:Int, Y:Int):Void
	{
		var e:DumbEnemy = new DumbEnemy(X, Y);
		levelObjects.add(e);
	}
	
	function makeCoin(X:Int, Y:Int):Void
	{
		var c:Coin = new Coin(X, Y);
		coins.add(c);
	}
	
	function makeExit(X:Int, Y:Int):Void
	{
		exit = new Exit(X, Y);
		add(exit);
	}
	
	var timerText:FlxText;
	var livesText:FlxText;
	var coinsText:FlxText;
	var scoreText:FlxText;
	
	function addText():Void
	{
		timerText = new FlxText(0, 0, FlxG.width);
		timerText.scrollFactor.set();
		timerText.setFormat(null, 8, 0xdeeed6, "left", FlxText.BORDER_SHADOW, 0x4e4a4e);
		add(timerText);
		
		livesText = new FlxText(0, 0, FlxG.width);
		livesText.scrollFactor.set();
		livesText.setFormat(null, 8, 0xdeeed6, "left", FlxText.BORDER_SHADOW, 0x4e4a4e);
		add(livesText);
		
		coinsText = new FlxText(0, 0, FlxG.width);
		coinsText.scrollFactor.set();
		coinsText.setFormat(null, 8, 0xdeeed6, "center", FlxText.BORDER_SHADOW, 0x4e4a4e);
		add(coinsText);
		
		scoreText = new FlxText(0, 0, FlxG.width);
		scoreText.scrollFactor.set();
		scoreText.setFormat(null, 8, 0xdeeed6, "right", FlxText.BORDER_SHADOW, 0x4e4a4e);
		add(scoreText);
	}
	
	function setCamera():Void
	{
		FlxG.camera.setBounds(0, 0, Reg.level.widthInTiles * Reg.tileWidth, Reg.level.heightInTiles * Reg.tileWidth);
		FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
	}
	
	var timerHelper:Int = 60;
	
	override public function update():Void
	{
		if (timerHelper <= 0) {
			Reg.timer--;
			timerHelper = 60;
		} else timerHelper--;
		
		setText();
		
		FlxG.collide(levelObjects, Reg.level);
		FlxG.collide(player, Reg.enemies, killEnemy);
		FlxG.overlap(player, Reg.enemies, killPlayer);
		FlxG.overlap(player, coins, getCoins);
		FlxG.overlap(player, exit, exitLevel);
		
		if (FlxG.keys.justPressed.R) FlxG.switchState(new PlayState());
		
		super.update();
	}
	
	function setText():Void
	{
		timerText.text = "TIMER:" + Reg.timer;
		livesText.text = "\nLIVESx" + Reg.lives;
		coinsText.text = "COINSx" + Reg.coins;
		scoreText.text = "SCORE:\n" + Reg.score;
	}
	
	function killEnemy(p:Player, e:Hitbox):Void
	{
		e.parent.kill();
		e.kill();
		p._running? p.velocity.y = -500: p.velocity.y = -300;
	}
	
	function killPlayer(p:Player, e:Hitbox):Void
	{
		p.kill();
	}
	
	function getCoins(p:Player, c:FlxSprite):Void
	{
		if (c.alive) {
			Reg.score += 10;
			Reg.coins++;
			c.kill();
		}
	}
	
	function exitLevel(p:Player, e:Exit):Void
	{
		timerHelper = 600;
		if (!Reg.hasWon) {
			levelTransition();
			new FlxTimer(2, goToNextLevel);
		}
		Reg.hasWon = true;
		p.velocity.x = 0;
		if (Math.abs((p.x + p.width * 0.5) - (e.x + e.width * 0.5)) > 1) {
			if (p.x + p.width * 0.5 < e.x + e.width * 0.5) p.velocity.x = 50;
			else if (p.x + p.width * 0.5 > e.x + e.width * 0.5) p.velocity.x = -50;
		} else {
			p.velocity.x = 0;
			p.acceleration.x = 0;
		}
	}
	
	var shutterPos:Int = 0;
	
	function levelTransition():Void
	{
		for (i in 0...16) {
			new FlxTimer(i * 0.1, shutter);
		}
	}
	
	function shutter(t:FlxTimer):Void
	{
		var shade:FlxSprite = new FlxSprite(0, FlxG.height / 16 * shutterPos);
		shade.makeGraphic(FlxG.width, Math.floor(FlxG.height / 16), 0xFF000000);
		shade.scale.set(1,0);
		shade.scrollFactor.set();
		FlxTween.tween(shade.scale, { x:8, y:1.2 }, 0.4);
		add(shade);
		shutterPos++;
	}
	
	function goToNextLevel(t:FlxTimer):Void
	{
		FlxG.switchState(new PlayState());
	}
	
}