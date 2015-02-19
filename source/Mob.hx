package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Mob extends FlxSprite
{
	var maxSpeed:Int = 40;
	var maxFallSpeed:Int = 800;
	var gravity:Int = 1600;
	
	public function new(X:Float, Y:Float) 
	{
		super(X * 16, Y * 16 - 8);
		loadGraphic("assets/images/enemy1.png", true, 26, 24);
		animation.add("walk", [0, 1, 2, 1, 0, 4, 5, 4, 0, 1, 2, 1, 0, 4, 5, 4, 3], 12);
		animation.play("walk");
		width = 16;
		offset.set(5, 0);
		
		velocity.x = -maxSpeed;
		
		acceleration.y = gravity;
		maxVelocity.y = maxFallSpeed;
	}
	
	override public function update(e:Float):Void 
	{
		if (justTouched(FlxObject.RIGHT)) velocity.x = -maxSpeed;
		else if (justTouched(FlxObject.LEFT)) velocity.x = maxSpeed;
		if (justTouched(FlxObject.FLOOR)) (Reg.state.player.x < x)? velocity.x = -maxSpeed: velocity.x = maxSpeed;
		if (isOnScreen() || !alive) super.update(e);
		
		if (!alive) angle += velocity.x * 0.25;
		if (y > Reg.state.level.height) super.kill();
	}
	
	override public function kill():Void 
	{
		scale.set(1.5, 1.5);
		FlxTween.tween(scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );
		velocity.y = -200;
		allowCollisions = FlxObject.NONE;
		alive = false;
	}
	
}