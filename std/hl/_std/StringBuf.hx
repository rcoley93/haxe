/*
 * Copyright (C)2005-2016 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
@:coreApi class StringBuf {

	var b : hl.types.Bytes;
	var size : Int;
	var pos : Int;
	var slen : Int;
	public var length(get,never) : Int;

	public function new() : Void {
		pos = slen = 0;
		size = 12; // ensure 6 bytes expand for addChar()
		b = new hl.types.Bytes(size);
	}

	inline function get_length() : Int {
		return slen;
	}

	inline function __expand( need : Int ) : Void {
		var nsize = (size * 3) >> 1;
		if( need > nsize ) nsize = need;
		var b2 = new hl.types.Bytes(nsize);
		b2.blit(0, b, 0, pos);
		b = b2;
		size = nsize;
	}

	function __addBytes( bytes : hl.types.Bytes, spos : Int, ssize : Int, slen : Int ) : Void {
		if( pos + ssize > size ) __expand(pos + ssize);
		b.blit(pos, bytes, spos, ssize);
		pos += ssize;
		this.slen += slen;
	}

	inline function __add( bytes : hl.types.Bytes, spos : Int, ssize : Int ) : Void {
		__addBytes(bytes, spos, ssize, bytes.utf8Length(spos, ssize));
	}

	public function add<T>( x : T ) : Void {
		var ssize = 0;
		var sbytes = hl.types.Bytes.ofValue(x, new hl.types.Ref(ssize));
		__add(sbytes, 0, ssize);
	}

	public function addSub( s : String, pos : Int, ?len : Int ) : Void @:privateAccess {
		if( pos < 0 ) pos = 0;
		if( pos > s.length ) pos = s.length;
		var slen : Int;
		if( len == null ) slen = s.length - pos else {
			slen = len;
			if( pos + slen > s.length ) slen = s.length - pos;
			if( slen <= 0 ) return;
		}
		var bpos = pos == 0 ? 0 : s.bytes.utf8Pos(0,pos);
		var blen = (pos + len == s.length ? s.size - bpos : s.bytes.utf8Pos(bpos, len));
		__addBytes(s.bytes, bpos, blen, len - pos);
	}

	public function addChar( c : Int ) : Void {
		if( c < 0 )
			throw "Invalid char code";
		if( pos + 6 > size ) __expand(0);
		if( c < 0x80 )
			b[pos++] = c;
		else if( c < 0x800 ) {
			b[pos++] = 0xC0 | (c >> 6);
			b[pos++] = 0x80 | (c & 63);
		} else if( c < 0x10000 ) {
			b[pos++] = 0xE0 | (c >> 12);
			b[pos++] = 0x80 | ((c >> 6) & 63);
			b[pos++] = 0x80 | (c & 63);
		} else if( c < 0x200000 ) {
			b[pos++] = 0xF0 | (c >> 18);
			b[pos++] = 0x80 | ((c >> 12) & 63);
			b[pos++] = 0x80 | ((c >> 6) & 63);
			b[pos++] = 0x80 | (c & 63);
		} else if( c < 0x4000000 ) {
			b[pos++] = 0xF8 | (c >> 24);
			b[pos++] = 0x80 | ((c >> 18) & 63);
			b[pos++] = 0x80 | ((c >> 12) & 63);
			b[pos++] = 0x80 | ((c >> 6) & 63);
			b[pos++] = 0x80 | (c & 63);
		} else {
			b[pos++] = 0xFC | (c >> 30);
			b[pos++] = 0x80 | ((c >> 24) & 63);
			b[pos++] = 0x80 | ((c >> 18) & 63);
			b[pos++] = 0x80 | ((c >> 12) & 63);
			b[pos++] = 0x80 | ((c >> 6) & 63);
			b[pos++] = 0x80 | (c & 63);
		}
		slen++;
	}

	public function toString() : String {
		if( pos == size ) __expand(0);
		b[pos] = 0;
		return @:privateAccess String.__alloc__(b, pos, slen);
	}

}
