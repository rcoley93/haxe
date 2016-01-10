package hl.types;

extern class Api {

	@:hlNative("std","get_field") static function getField( obj : Dynamic, hash : Int ) : Dynamic;
	@:hlNative("std","call_method") static function callMethod( f : haxe.Constraints.Function, args : NativeArray<Dynamic> ) : Dynamic;
	@:hlNative("std","no_closure") static function noClosure( f : haxe.Constraints.Function ) : haxe.Constraints.Function;

}
	