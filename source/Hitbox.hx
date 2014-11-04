package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author x01010111
 */
class Hitbox extends FlxSprite
{
	public var parent:FlxSprite;
	
	public function new(PARENT:FlxSprite, X:Float, Y:Float, W:Float, H:Float) 
	{
		super(X, Y);
		
		makeGraphic(Math.floor(W), Math.floor(H), 0x00000000);
		allowCollisions = FlxObject.UP;
		parent = PARENT;
		
		Reg.enemies.add(this);
		FlxG.state.add(this);
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
}