package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	public static var playerPos:FlxPoint;
	public static var joypad:FlxGamepad;
	public static var enemies:FlxTypedGroup<Hitbox>;
	public static var level:FlxTilemap;
	public static var tileWidth:Int = 16;
	public static var hasWon:Bool;
	public static var lives:Int = 3;
	public static var coins:Int = 0;
	public static var score:Int = 0;
	public static var timer:Int;
}