package hl.types;
import hl.types.ArrayBase;

class ArrayDynIterator {
	var a : ArrayBase;
	var len : Int;
	var pos : Int;
	public function new(a) {
		this.a = a;
		this.len = a.length;
		this.pos = 0;
	}
	public function hasNext() {
		return pos < len;
	}
	public function next() {
		return a.getDyn(pos++);
	}
}

@:keep
class ArrayDyn extends ArrayAccess {

	// TODO : for Dynamic access, we need to support __getField(hash("length")) !
	public var length(get,never) : Int;
	var array : ArrayBase;
	var allowReinterpret : Bool;

	public function new() {
		array = new ArrayObj<Dynamic>();
		allowReinterpret = true;
	}

	inline function get_length() return array.length;

	override function getDyn(i) {
		return array.getDyn(i);
	}

	override function setDyn(pos:Int, value:Dynamic) {
		array.setDyn(pos, value);
	}

	public function concat( a : ArrayDyn ) : ArrayDyn {
		var a1 = array;
		var a2 = a.array;
		var alen = a1.length;
		var anew = new NativeArray<Dynamic>(alen + a2.length);
		for( i in 0...alen )
			anew[i] = a1.getDyn(i);
		for( i in 0...a2.length )
			anew[i+alen] = a2.getDyn(i);
		return alloc(ArrayObj.alloc(anew),true);
	}

	public function join( sep : String ) : String {
		return array.join(sep);
	}

	public function pop() : Null<Dynamic> {
		return array.popDyn();
	}

	public function push(x : Dynamic) : Int {
		return array.pushDyn(x);
	}

	public function reverse() : Void {
		array.reverse();
	}

	public function shift() : Null<Dynamic> {
		return array.shiftDyn();
	}

	public function slice( pos : Int, ?end : Int ) : ArrayDyn {
		throw "TODO";
		return null;
	}

	public function sort( f : Dynamic -> Dynamic -> Int ) : Void {
		array.sortDyn(f);
	}

	public function splice( pos : Int, len : Int ) : ArrayDyn {
		return alloc(array.spliceDyn(pos,len),true);
	}

	public function toString() : String {
		return array.toString();
	}

	public function unshift( x : Dynamic ) : Void {
		array.unshiftDyn(x);
	}

	public function insert( pos : Int, x : Dynamic ) : Void {
		array.insertDyn(pos,x);
	}

	public function remove( x : Dynamic ) : Bool {
		return array.removeDyn(x);
	}

	public function indexOf( x : Dynamic, ?fromIndex:Int ) : Int {
		var i : Int = fromIndex;
		var length = length;
		var array = array;
		while( i < length ) {
			if( array.getDyn(i) == x )
				return i;
			i++;
		}
		return -1;
	}

	public function lastIndexOf( x : Dynamic, ?fromIndex:Int ) : Int {
		throw "TODO";
		return -1;
	}

	public function copy() : ArrayDyn {
		var a = new NativeArray<Dynamic>(length);
		for( i in 0...length )
			a[i] = array.getDyn(i);
		return alloc(ArrayObj.alloc(a),true);
	}

	public function iterator() : Iterator<Dynamic> {
		return new ArrayDynIterator(array);
	}

	public function map( f : Dynamic -> Dynamic ) : ArrayDyn {
		var a = new NativeArray<Dynamic>(length);
		for( i in 0...length )
			a[i] = f(array.getDyn(i));
		return alloc(ArrayObj.alloc(a),true);
	}

	public function filter( f : Dynamic -> Bool ) : ArrayDyn {
		var a = new ArrayObj<Dynamic>();
		for( i in 0...length ) {
			var v = array.getDyn(i);
			if( f(v) ) a.push(v);
		}
		return alloc(a,true);
	}

	function __cast( t : Type ) : Dynamic {
		if( t.check(array) )
			return array;
		if( !allowReinterpret )
			return null;
		if( t == Type.get(new ArrayI32()) ) {
			var a : BytesAccess<Int> = null;
			a = new Bytes(array.length << a.sizeBits);
			for( i in 0...array.length )
				a[i] = array.getDyn(i);
			var arr = ArrayBase.allocI32(a, array.length);
			array = arr;
			allowReinterpret = false;
			return arr;
		}
		if( t == Type.get(new ArrayF64()) ) {
			var a : BytesAccess<Float> = null;
			a = new Bytes(array.length << a.sizeBits);
			for( i in 0...array.length )
				a[i] = array.getDyn(i);
			var arr = ArrayBase.allocF64(a, array.length);
			array = arr;
			allowReinterpret = false;
			return arr;
		}
		return null;
	}

	public static function alloc( a : ArrayBase, allowReinterpret = false ) : ArrayDyn {
		var arr : ArrayDyn = untyped $new(ArrayDyn);
		arr.array = a;
		arr.allowReinterpret = allowReinterpret;
		return arr;
	}

}
