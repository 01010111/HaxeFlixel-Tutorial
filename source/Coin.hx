package ;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import openfl.display.BlendMode;

/**
 * ...
 * @author x01010111
 */
class Coin extends FlxSprite
{
	var bobTween:FlxTween;
	
	public function new(X:Float, Y:Float) 
	{
		super(X * 16 + 2, Y * 16 - 3);
		loadGraphic("assets/images/coin.png", true, 12, 16);
		animation.add("play", [0, 1, 2, 3], 16);
		animation.play("play");
		bobTween = FlxTween.tween(this, { y:y + 6 }, Math.random() + 1, { type:FlxTween.PINGPONG } );
	}
	
	override public function kill():Void 
	{
		bobTween.active = false;
		alive = false;
		blend = BlendMode.ADD;
		FlxTween.tween(scale, { x:0, y:3 }, 0.1);
		velocity.y = -150;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (scale.x < 0.05) super.kill();
		super.update(elapsed);
	}
	
}