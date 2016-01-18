package hl.types;

@:generic class NativeArrayIterator<T> {
	var arr : NativeArray<T>;
	var pos : Int;
	var length : Int;

	public inline function new(arr:NativeArray<T>) {
		this.arr = arr;
		pos = 0;
		length = arr.length;
	}

	public inline function hasNext() {
		return pos < length;
	}

	public inline function next() {
		return arr[pos++];
	}
}

@:coreType abstract NativeArray<T> {

	public var length(get,never):Int;

	@:extern public inline function new( length : Int ) {
		this = untyped $aalloc(length);
	}

	@:extern inline function get_length() : Int {
		return untyped $asize(this);
	}

	@:extern @:arrayAccess inline function get( pos : Int ) : T {
		return untyped ($aget(this,pos):T);
	}

	@:extern @:arrayAccess inline function set( pos : Int, value : T ) : T {
		untyped $aset(this,pos,value);
		return value;
	}

	@:extern public inline function sub( pos : Int, len : Int ) {
		var n = new NativeArray<T>(len);
		n.blit(0, this, pos, len);
		return n;
	}

	@:hlNative("std","atype") public function getType() : Type {
		return null;
	}

 	@:hlNative("std","ablit") public function blit( pos : Int, src : NativeArray<T>, srcPos : Int, srcLen : Int ) : Void {
	}

}