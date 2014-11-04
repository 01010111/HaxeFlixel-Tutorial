package ;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPath;

/**
 * ...
 * @author x01010111
 */
class SmartEnemy extends Enemy
{
	var maxSpeed:Int = 50;
	var maxFallSpeed:Int = 800;
	var gravity:Int = 1600;
	
	var speed:Float;
	
	public function new(X:Float, Y:Float) 
	{
		super(X * Reg.tileWidth, Y * Reg.tileWidth + Reg.tileWidth);
		loadGraphic("assets/images/smartEnemy.png", true, 26, 24);
		width = 20;
		offset.set(3, 0);
		y = y - height;
		animation.add("walk", [0, 1, 2, 1, 0, 4, 5, 4, 0, 1, 2, 1, 0, 4, 5, 4, 3], 12);
		animation.add("run", [6, 7, 8, 7, 6, 10, 11, 10, 6, 7, 8, 7, 6, 10, 11, 10, 9], 20);
		scoreBonus = 250;
		
		acceleration.y = gravity;
		maxVelocity.y = maxFallSpeed;
		
		makeHitbox();
	}
	
	override public function update(elapsed:Float):Void 
	{														//NEXT TWO LINES ARE IN CASE YOU PLACE THE ENEMY IN THE AIR ABOVE THE DESIRED POSITION
		if (path == null) {									//IF THERE IS NO PATH SET
			if (justTouched(FlxObject.FLOOR)) makePath();	//WHEN THE ENEMY TOUCHES GROUND, MAKE A PATH
		} else checkPlayerPos();							//ELSE CHECK PLAYER POSITION
		super.update(elapsed);
	}
	
	/**
	 * CHECKS FOR CLOSEST WALLS OR PITS TO THE LEFT AND THE RIGHT AND CREATES A PATH BETWEEN THEM FOR THE ENEMY TO FOLLOW
	 */
	function makePath():Void
	{
		acceleration.y = 0;																				//SET GRAVITY TO ZERO
		var nodes:Array<FlxPoint> = new Array();														//CREATE AN ARRAY FOR TWO NODES
		
		var t:Int = Reg.tileWidth;																		//SAVES SPACE :)
		var p:FlxPoint = FlxPoint.get(Math.floor(x / t) * t + t / 2, Math.floor(y / t) * t + t * 1.5);	//CREATE HELPER POINT
		
		for (i in 0...Reg.level.widthInTiles) {															//CHECKING TO THE LEFT
			if (Reg.level.overlapsPoint(FlxPoint.get(p.x - i * Reg.tileWidth, p.y)) 					//IF A POINT OVERLAPS A WALL
			|| !Reg.level.overlapsPoint(FlxPoint.get(p.x - i * Reg.tileWidth, p.y + Reg.tileWidth))) {	//OR IF A POINT DOES NOT OVERLAP THE FLOOR
				nodes.push(FlxPoint.get(p.x - i * Reg.tileWidth + Reg.tileWidth, p.y - 4));				//ADD THE POINT TO THE NODES ARRAY
				break;																					//AND BREAK OUT OF THE FOR LOOP
			}
		}
		
		for (i in 0...Reg.level.widthInTiles) {															//CHECKING TO THE RIGHT
			if (Reg.level.overlapsPoint(FlxPoint.get(p.x + i * Reg.tileWidth, p.y)) 					//IF A POINT OVERLAPS A WALL
			|| !Reg.level.overlapsPoint(FlxPoint.get(p.x + i * Reg.tileWidth, p.y + Reg.tileWidth))) {	//OR IF A POINT DOES NOT OVERLAP THE FLOOR
				nodes.push(FlxPoint.get(p.x + i * Reg.tileWidth - Reg.tileWidth, p.y - 4));				//ADD THE POINT TO THE NODES ARRAY
				break;																					//AND BREAK OUT OF THE FOR LOOP
			}
		}
		
		path = new FlxPath(this, nodes, maxSpeed, FlxPath.YOYO); 										//CREATE A NEW PATH MADE FROM THE TWO NODES
	}
	
	/**
	 * CHECKS PLAYER POSITION - IF PLAYER IS ADJACENT ON THE Y AXIS ENEMY WILL GO FASTER
	 */
	function checkPlayerPos():Void
	{
		if (Math.abs(y - Reg.playerPos.y) < Reg.tileWidth * 1.5) {	//IF THE PLAYER'S Y VALUE IS WITHIN 1 1/2 TILES OF THE ENEMY 
			path.speed = maxSpeed * 2; 								//GO TWICE AS FAST
			animation.play("run");									//AND PLAY RUN ANIMATION
		} else {													//ELSE
			path.speed = maxSpeed;									//GO NORMAL SPEED
			animation.play("walk");									//AND PLAY WALK ANIMATION
		}
	}
	
}