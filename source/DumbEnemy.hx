package ;
import flixel.FlxObject;

/**
 * ...
 * @author x01010111
 */
class DumbEnemy extends Enemy
{
	var maxSpeed:Int = 40;
	var maxFallSpeed:Int = 800;
	var gravity:Int = 1600;
	
	public function new(X:Float, Y:Float) 
	{
		super(X * Reg.tileWidth, Y * Reg.tileWidth + Reg.tileWidth);
		loadGraphic("assets/images/dumbEnemy.png", true, 26, 24);
		animation.add("walk", [0, 1, 2, 1, 0, 4, 5, 4, 0, 1, 2, 1, 0, 4, 5, 4, 3], 12);
		animation.play("walk");
		width = 16;
		offset.set(5, 0);
		y = y - height;
		scoreBonus = 150;
		
		velocity.x = -maxSpeed;
		
		acceleration.y = gravity;
		maxVelocity.y = maxFallSpeed;
		
		makeHitbox();
	}
	
	override public function update():Void 
	{
		if (justTouched(FlxObject.RIGHT)) velocity.x = -maxSpeed;
		else if (justTouched(FlxObject.LEFT)) velocity.x = maxSpeed;
		if (justTouched(FlxObject.FLOOR)) (Reg.playerPos.x < x)? velocity.x = -maxSpeed: velocity.x = maxSpeed;
		if (isOnScreen()) super.update();
	}
	
	
	
}