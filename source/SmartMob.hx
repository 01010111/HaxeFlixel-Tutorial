package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxPath;
import flixel.math.FlxPoint;

/**
 * This enemy is similar to our other mob, but it does two things:
	 * It will not fall off platforms, but will walk back and forth on the platform it is spawned on
	 * It will charge the player if the player is on the same horizontal plane
 */
class SmartMob extends FlxSprite
{

	var maxSpeed:Int = 50;
	var maxFallSpeed:Int = 800;
	var gravity:Int = 1600;
	var path:FlxPath;
	var speed:Float;
	
	public function new(X:Float, Y:Float) 
	{
		super(X * 16, Y * 16 + 16);
		loadGraphic("assets/images/enemy2.png", true, 26, 24);
		width = 20;
		offset.set(3, 0);
		y = y - height;
		animation.add("walk", [0, 1, 2, 1, 0, 4, 5, 4, 0, 1, 2, 1, 0, 4, 5, 4, 3], 12);
		animation.add("run", [6, 7, 8, 7, 6, 10, 11, 10, 6, 7, 8, 7, 6, 10, 11, 10, 9], 20);
		
		makePath();
	}
	
	override public function update(e:Float):Void 
	{
		checkPlayerPosition();
		super.update(e);
		if (!alive) angle += velocity.x * 0.25;
		if (y > Reg.state.level.height) super.kill();
	}
	
	override public function kill():Void 
	{
		//STORE CURRENT X VELOCITY
		var vx = velocity.x;
		//CANCEL OUR PATH (THIS SETS X VELOCITY TO 0
		path.cancel();
		//SET X VELOCITY TO STORED VALUE
		velocity.x = vx;
		//SET GRAVITY
		acceleration.y = 1600;
		
		scale.set(1.5, 1.5);
		FlxTween.tween(scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );
		velocity.y = -200;
		allowCollisions = FlxObject.NONE;
		alive = false;
	}
	
	/**
	 * CHECKS FOR CLOSEST WALLS OR PITS TO THE LEFT AND THE RIGHT AND CREATES A PATH BETWEEN THEM FOR THE ENEMY TO FOLLOW
	 */
	function makePath():Void
	{
		//CREATE AN ARRAY FOR TWO NODES
		var nodes:Array<FlxPoint> = new Array();
		
		//CREATE HELPER POINT
		var p:FlxPoint = FlxPoint.get(Math.floor(x / 16) * 16 + 16 / 2, Math.floor(y / 16) * 16 + 16 * 1.5);
		
		//CHECKING TO THE LEFT
		for (i in 0...Reg.state.level.widthInTiles) {
			//IF A POINT OVERLAPS A WALL OR IF A POINT DOES NOT OVERLAP THE FLOOR
			if (Reg.state.level.overlapsPoint(FlxPoint.get(p.x - i * 16, p.y)) || !Reg.state.level.overlapsPoint(FlxPoint.get(p.x - i * 16, p.y + 16))) {
				//ADD THE POINT TO THE NODES ARRAY
				nodes.push(FlxPoint.get(p.x - i * 16 + 16, p.y - 4));
				//AND BREAK OUT OF THE FOR LOOP
				break;
			}
		}
		
		//CHECKING TO THE RIGHT
		for (i in 0...Reg.state.level.widthInTiles) {	
			//IF A POINT OVERLAPS A WALL OR IF A POINT DOES NOT OVERLAP THE FLOOR
			if (Reg.state.level.overlapsPoint(FlxPoint.get(p.x + i * 16, p.y)) || !Reg.state.level.overlapsPoint(FlxPoint.get(p.x + i * 16, p.y + 16))) {
				//ADD THE POINT TO THE NODES ARRAY
				nodes.push(FlxPoint.get(p.x + i * 16 - 16, p.y - 4));
				//AND BREAK OUT OF THE FOR LOOP
				break;
			}
		}
		//CREATE A NEW PATH MADE FROM THE TWO NODES
		path = new FlxPath().start(this, nodes, maxSpeed, FlxPath.YOYO);
	}
	
	/**
	 * CHECKS PLAYER POSITION - IF PLAYER IS ADJACENT ON THE Y AXIS ENEMY WILL GO FASTER
	 */
	function checkPlayerPosition():Void
	{
		//IF THE PLAYER'S Y VALUE IS WITHIN 1 1/2 TILES OF THE ENEMY 
		if (Math.abs(y - Reg.state.player.y) < 16 * 1.5) {
			//GO TWICE AS FAST
			path.speed = maxSpeed * 2;
			//AND PLAY RUN ANIMATION
			animation.play("run");
		} else {
			//GO NORMAL SPEED
			path.speed = maxSpeed;
			//AND PLAY WALK ANIMATION
			animation.play("walk");
		}
	}
	
}