package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class Start extends FlxSubState
{
	
	public function new() 
	{
		super(0x00000000);
		
		var s:Int = 16;
		new FlxTimer().start(s * 0.05 + 0.21).onComplete = function(t:FlxTimer):Void { close(); }
		for (i in 0...s) {
			var b:FlxSprite = new FlxSprite(0, i * FlxG.height / s);
			b.makeGraphic(FlxG.width, Math.floor(FlxG.height / s + 1), 0xff000000);
			b.scale.set(1.1, 1.1);
			b.scrollFactor.set();
			add(b);
			new FlxTimer().start(i * 0.05 + 0.01).onComplete = function(t:FlxTimer):Void { FlxTween.tween(b.scale, { y:0 }, 0.2); }
		}
		
	}
	
}