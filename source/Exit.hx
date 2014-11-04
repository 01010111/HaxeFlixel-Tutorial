package ;
import flixel.FlxSprite;

/**
 * ...
 * @author x01010111
 */
class Exit extends FlxSprite
{
	
	public function new(X:Float, Y:Float) 
	{
		super(X * 16 - 16, Y * 16 - 16);
		makeGraphic(48, 32, 0x00FF0000);
	}
	
}