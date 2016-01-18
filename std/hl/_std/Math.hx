
@:coreApi
class Math {

	@:hlNative("std","math_sqrt") public static function sqrt( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_abs") public static function abs( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_floor") public static function floor( v : Float ) : Int 			return 0;
	@:hlNative("std","math_round") public static function round( v : Float ) : Int 			return 0;
	@:hlNative("std","math_ceil") public static function ceil( v : Float ) : Int 			return 0;
	@:hlNative("std","math_finite") public static function isFinite( f : Float ) : Bool 	return true;
	@:hlNative("std","math_isnan") public static function isNaN( f : Float ) : Bool 		return false;

	@:hlNative("std","math_ffloor") public static function ffloor( v : Float ) : Float 		return 0.;
	@:hlNative("std","math_fround") public static function fround( v : Float ) : Float 		return 0.;
	@:hlNative("std","math_fceil") public static function fceil( v : Float ) : Float 		return 0.;

	@:hlNative("std","math_cos") public static function cos( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_sin") public static function sin( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_exp") public static function exp( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_log") public static function log( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_tan") public static function tan( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_atan") public static function atan( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_acos") public static function acos( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_asin") public static function asin( v : Float ) : Float 			return 0.;
	@:hlNative("std","math_pow") public static function pow( v : Float, exp : Float ) : Float 				return 0.;
	@:hlNative("std","math_atan2") public static function atan2( y : Float, x : Float ) : Float 			return 0.;

	public static function min( a : Float, b : Float ) : Float 			return a < b || isNaN(a) ? a : b;
	public static function max( a : Float, b : Float ) : Float 			return a < b || isNaN(b) ? b : a;

	public static var PI(default,null) : Float;
	public static var NaN(default,null) : Float;
	public static var POSITIVE_INFINITY(default,null) : Float;
	public static var NEGATIVE_INFINITY(default,null) : Float;

	public static function random():Float return 0.15; // I rolled a D20

	static function __init__() : Void {
		PI = 3.14159265359;
		NaN = 0. / 0.;
		POSITIVE_INFINITY = 1. / 0.;
		NEGATIVE_INFINITY = -1. / 0.;
	}

}