package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.gamepad.XboxButtonID;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

/**
 * ...
 * @author x01010111
 */
class Player extends FlxSprite
{
	var _maxWalkSpeed:Int = 140;
	var _maxRunSpeed:Int = 200;
	var _maxFallSpeed:Int = 800;
	var _jumpForce:Int = 420;
	var _gravity:Int = 1600;
	var _deadzone:Float = 0.3;
	var _maxAccel:Int = 1000;
	var _drag:Int = 1000;
	var _freezeTimer:Int = 0;
	var _oldScore:Int;
	
	var _xMove:Float;
	var _jump:Bool;
	public var _running:Bool;
	var _jumpForceFinal:Float;
	
	public function new(X:Float, Y:Float) 
	{
		_oldScore = Reg.score;
		
		super(X * Reg.tileWidth, Y * Reg.tileWidth + Reg.tileWidth);
		loadGraphic("assets/images/andi.png", true, 32, 32);
		width = 14;
		offset.x = 9;
		y = y - height;
		
		animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8]);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7], 16);
		animation.add("run" , [0, 1, 2, 3, 4, 5, 6, 7], 24);
		animation.add("jump", [15]);
		animation.add("skid", [14]);
		animation.add("check", [9, 10, 11], 16, false);
		animation.add("death", [12]);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		maxVelocity.y = _maxFallSpeed;
		acceleration.y = _gravity;
		drag.x = _drag;
	}
	
	override public function update(e:Float):Void 
	{
		if (_freezeTimer <= 0) {
			if (alive) {
				if (!Reg.hasWon) controls();
				animations();
				levelBounds();
			}
			super.update(e);
		} else _freezeTimer--;
		Reg.playerPos = FlxPoint.get(x, y);
	}
	
	function controls():Void
	{
		_xMove = 0;
		_jump = false;
		_running = false;
		
		if (Reg.joypad == null) Reg.joypad = FlxG.gamepads.lastActive;
		else {
			var joyX:Float = Reg.joypad.getXAxis(XboxButtonID.LEFT_ANALOG_STICK);
			if (Math.abs(joyX) > _deadzone) _xMove += joyX;
			if (Reg.joypad.justPressed(XboxButtonID.A)) _jump = true;
			if (Reg.joypad.justReleased(XboxButtonID.A) && velocity.y < 0) velocity.y = velocity.y * 0.5;
			if (Reg.joypad.pressed(XboxButtonID.X)) _running = true;
		}
		
		if (FlxG.keys.anyPressed(["LEFT", "A"])) _xMove += -1;
		if (FlxG.keys.anyPressed(["RIGHT", "D"])) _xMove += 1;
		
		if (FlxG.keys.anyJustPressed(["SPACE", "UP", "W"])) _jump = true;
		if (FlxG.keys.anyJustReleased(["SPACE", "UP", "W"]) && velocity.y < 0) velocity.y = velocity.y * 0.5;
		
		if (FlxG.keys.anyPressed(["SHIFT", "Z"])) _running = true;
		
		_running? maxVelocity.x = _maxRunSpeed: maxVelocity.x = _maxWalkSpeed;
		_xMove = Math.min(Math.max(_xMove, -1), 1);
		acceleration.x = _xMove * _maxAccel;
		if (_jump && isTouching(FlxObject.FLOOR)) {
			_jumpForceFinal = _jumpForce + Math.abs(velocity.x * 0.25);
			velocity.y = -_jumpForceFinal;
		}
	}
	
	function animations() {
		if (velocity.x > 0) facing = FlxObject.RIGHT;
		else if (velocity.x < 0) facing = FlxObject.LEFT;
		if (!isTouching(FlxObject.FLOOR)) animation.play("jump");
		else {
			if (velocity.x == 0) animation.play("idle");
			else if (velocity.x > 0 && _xMove < 0 || velocity.x < 0 && _xMove > 0) animation.play("skid");
			else if (_running) animation.play("run");
			else animation.play("walk");
		}
		if (Reg.hasWon && velocity.x == 0) {
			alive = false;
			animation.play("check");
		}
	}
	
	function levelBounds():Void
	{
		if (x < 0) velocity.x = _maxRunSpeed;
		else if (x > Reg.level.widthInTiles * Reg.tileWidth - width) velocity.x = -_maxRunSpeed;
		
		if (y > Reg.level.heightInTiles * Reg.tileWidth) kill();
	}
	
	override public function kill():Void 
	{
		if (alive) {
			if (y < Reg.level.heightInTiles * Reg.tileWidth) {
				velocity.set(velocity.x * -1, -_jumpForce);
				_freezeTimer = 15;
			} else 	velocity.set(0, -_jumpForce * 1.5);
			alive = false;
			FlxG.camera.follow(null);
			allowCollisions = FlxObject.NONE;
			drag.x = 0;
			acceleration.x = 0;
			animation.play("death");
			new FlxTimer(2, gameOver);
		}
	}
	
	function gameOver(T:FlxTimer):Void
	{
		super.kill();
		Reg.score = _oldScore;
		FlxG.switchState(new PlayState());
	}
	
}