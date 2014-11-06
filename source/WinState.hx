package ;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;

class WinState extends FlxSubState
{

	public function new() 
	{
		super(0xFF000000);
		var gameOverText:FlxText = new FlxText(0, 0, 0, "YOU WON!");
		gameOverText.scrollFactor.set();
		FlxSpriteUtil.screenCenter(gameOverText);
		add(gameOverText);
	}
	
	override public function update():Void 
	{
		if (FlxG.gamepads.lastActive.anyButton() || FlxG.keys.justPressed.ANY) close();
		super.update();
	}
	
	override public function close():Void 
	{
		FlxG.switchState(new PlayState());
	}
	
}