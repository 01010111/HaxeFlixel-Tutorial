package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxPath;

/**
 * ...
 * @author x01010111
 */
class Enemy extends FlxSprite
{
	var hitBox:Hitbox;
	var scoreBonus:Int;
	var path:FlxPath;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
	}
	
	function makeHitbox():Void
	{
		hitBox = new Hitbox(this, x, y, width, height);
	}
	
	override public function update():Void 
	{
		super.update();
		hitBox.setPosition(x, y);
		if (y > Reg.level.heightInTiles * Reg.tileWidth) super.kill();
		if (!alive) angle += velocity.x * 0.25;
	}
	
	override public function kill():Void 
	{
		scale.set(1.5, 1.5);
		FlxTween.tween(scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );
		if (path != null) path.active = false;
		Reg.score += scoreBonus;
		acceleration.y = 1200;
		velocity.y = -200;
		allowCollisions = FlxObject.NONE;
		alive = false;
	}
	
}