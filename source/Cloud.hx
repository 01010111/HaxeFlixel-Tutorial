package ;
import flixel.FlxSprite;

/**
 * ...
 * @author x01010111
 */
class Cloud extends FlxSprite
{

	public function new(X:Float, Y:Float) 
	{
		super(X, Y, "assets/images/cloud.png");
		var s:Float = Math.random() + 0.1;
		scrollFactor.set(s * 0.5, 1);
	}
	
}