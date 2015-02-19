package;

import flixel.addons.display.FlxBackdrop;
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
	public var player:Player;
	var exit:FlxSprite;
	var coins:FlxGroup;
	var enemies:FlxGroup;
	var collectedCoins:Int = 0;
	public var level:FlxTilemap;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF6DC2CA;
		FlxG.mouse.visible = false;
		FlxG.fullscreen = true;
		Reg.state = this;
		
		addLevel();
		addObjects();
		//addUIText();
		setCamera();
		
		super.create();
		
		openSubState(new Start());
	}
	
	function addLevel():Void
	{
		if (Reg.stage == 1) {
			var cld1:FlxBackdrop = new FlxBackdrop("assets/images/cloud1.png", 1, 1, true, false);
			cld1.y = -80;
			add(cld1);
			var mnt1:FlxBackdrop = new FlxBackdrop("assets/images/bg_mountain1.png", 1, 1, true, false);
			mnt1.y = 240;
			add(mnt1);
		}
		
		else if (Reg.stage == 2) {
			FlxG.camera.bgColor = 0xffbbe096;
			var cld1:FlxBackdrop = new FlxBackdrop("assets/images/cloud1.png", 1, 1, true, false);
			cld1.y = -80;
			add(cld1);
			var mnt1:FlxBackdrop = new FlxBackdrop("assets/images/bg_mountain3.png", 1, 1, true, false);
			mnt1.y = 240;
			add(mnt1);
		}
		
		else if (Reg.stage == 3) {
			var cld2:FlxBackdrop = new FlxBackdrop("assets/images/cloud1.png", 0.25, 0.25, true, false);
			//cld2.velocity.x = -10;
			cld2.y = -120;
			add(cld2);
			var mnt2:FlxBackdrop = new FlxBackdrop("assets/images/bg_mountain1.png", 0.5, 0.5, true, false);
			mnt2.y = 160;
			add(mnt2);
		}
		
		else if (Reg.stage == 4) {
			var cld4:FlxBackdrop = new FlxBackdrop("assets/images/cloud2.png", 0.06, 0.06, true, false);
			cld4.y = -80;
			cld4.velocity.x = -2;
			cld4.alpha = 0.5;
			add(cld4);
			var cld3:FlxBackdrop = new FlxBackdrop("assets/images/cloud2.png", 0.12, 0.12, true, false);
			cld3.y = -100;
			cld3.velocity.x = -4;
			add(cld3);
			var mnt3:FlxBackdrop = new FlxBackdrop("assets/images/bg_mountain3.png", 0.25, 0.25, true, false);
			mnt3.x = -64;
			mnt3.y = 100;
			add(mnt3);
			var cld2:FlxBackdrop = new FlxBackdrop("assets/images/cloud1.png", 0.25, 0.25, true, false);
			cld2.y = -120;
			cld2.velocity.x = -8;
			add(cld2);
			var mnt2:FlxBackdrop = new FlxBackdrop("assets/images/bg_mountain1.png", 0.5, 0.5, true, false);
			mnt2.y = 160;
			add(mnt2);
		}
		
		level = new FlxTilemap();
		Reg.stage == 0? level.loadMapFromCSV("assets/data/Map1_Level.csv", "assets/images/tiles.png", 16, 16): level.loadMapFromCSV("assets/data/Map1_Levelb.csv", "assets/images/tiles.png", 16, 16);
		for (i in 16...32) level.setTileProperties(i, FlxObject.UP);
		for (i in 32...64) level.setTileProperties(i, FlxObject.NONE);
		add(level);
	}
	
	function addObjects():Void
	{
		coins = new FlxGroup();
		add(coins);
		
		enemies = new FlxGroup();
		add(enemies);
		
		var objectData:String = Assets.getText("assets/data/Map1_Objects.csv");
		var rows:Array<String> = objectData.split("\n");
		for (y in 0...rows.length) {
			var objectsString:Array<String> = rows[y].split(",");
			var objects:Array<Int> = new Array();
			for (i in 0...objectsString.length) objects.push(Std.parseInt(objectsString[i]));
			for (x in 0...objects.length) {
				switch(objects[x]) {
					case 1: addPlayer(x, y);
					case 2: addMob(x, y);
					case 3: addSmartMob(x, y);
					case 4: addCoin(x, y);
					case 15: addExit(x, y);
				}
			}
		}
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
	
	function addCoin(X:Int, Y:Int):Void
	{
		var coin:Coin = new Coin(X, Y);
		coins.add(coin);
	}
	
	function addMob(X:Int, Y:Int):Void
	{
		var mob:Mob = new Mob(X, Y);
		enemies.add(mob);
	}
	
	function addSmartMob(X:Int, Y:Int):Void
	{
		var mob:SmartMob = new SmartMob(X, Y);
		enemies.add(mob);
	}
	
	var coinsText:FlxText;
	
	function addUIText():Void
	{
		coinsText = new FlxText(0, 0, FlxG.width);
		coinsText.scrollFactor.set();
		coinsText.setFormat(null, 8, 0xdeeed6, "center", FlxTextBorderStyle.SHADOW, 0x4e4a4e);
		add(coinsText);
	}
	
	function setCamera():Void
	{
		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, level.width - 16, level.height - 16, true);
	}
	
	override public function update(e:Float):Void
	{
		//setUIText();
		
		FlxG.collide(level, player);
		FlxG.collide(level, enemies);
		FlxG.overlap(coins, player, getCoin);
		FlxG.overlap(enemies, player, enemyPlayerOverlap);
		FlxG.overlap(exit, player, winGame);
		
		super.update(e);
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
	
	function enemyPlayerOverlap(e:FlxSprite, p:Player):Void
	{
		if (p.velocity.y > 0) {
			e.kill();
			p.hitEnemy = true;
		} else {
			p.kill();
		}
	}
	
	function winGame(e:FlxSprite, p:Player):Void
	{
		if (p.isTouching(FlxObject.FLOOR) && !p.hasWon) {
			p.velocity.x = 0;
			p.acceleration.x = 0;
			p.animation.play("check");
			p.hasWon = true;
			new FlxTimer().start(0.1, leaveStage);
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