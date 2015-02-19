package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class WinState extends FlxSubState
{
	var c:Bool = false;
	
	public function new() 
	{
		super(0x00000000);
		
		var s:Int = 16;
		new FlxTimer().start(s * 0.05 + 0.21).onComplete = function(t:FlxTimer):Void { c = true; }
		for (i in 0...s) {
			var b:FlxSprite = new FlxSprite(0, i * FlxG.height / s);
			b.makeGraphic(FlxG.width, Math.floor(FlxG.height / s + 1), 0xff000000);
			b.scale.set(1.1, 0);
			b.scrollFactor.set();
			add(b);
			new FlxTimer().start(i * 0.05 + 0.01).onComplete = function(t:FlxTimer):Void { FlxTween.tween(b.scale, { y:1.1 }, 0.2); }
		}
		
		var gameOverText:FlxText;
		if (Reg.stage < 4) {
			gameOverText = new FlxText(0, 0, 0, "GOOD WORK - KEEP GOING!");
			Reg.stage++;
		} else {
			gameOverText = new FlxText(0, 0, 0, "YOU WON!!!");
			Reg.stage = 0;
		}
		gameOverText.scrollFactor.set();
		FlxSpriteUtil.screenCenter(gameOverText);
		add(gameOverText);
	}
	
	override public function update(e:Float):Void 
	{
		if (c && FlxG.gamepads.lastActive.anyButton() || c && FlxG.keys.justPressed.ANY) close();
		super.update(e);
	}
	
	override public function close():Void 
	{
		FlxG.switchState(new PlayState());
	}
	
}