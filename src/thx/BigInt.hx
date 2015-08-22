package thx;

/**
Based on code realized by Mike Welsh: https://github.com/Herschel/hxmath/blob/master/src/hxmath/BigInt.hx
*/
// TODO
// ++ ?
// -- ?
// ~ bitwise negation
// &
// |
// ^
// <<
// >>
// >>>

abstract BigInt(BigIntImpl) from BigIntImpl to BigIntImpl {
  public static var zero(default, null) : BigInt = new BigIntImpl(0, 0, 0);

  @:from public static function fromFloat(value : Float) : BigInt
    return zero;

  @:from public static function fromInt(value : Int) : BigInt
    return zero;

  @:from public static function fromString(value : String) : BigInt
    return zero;

  inline public function isZero() : Bool
    return this.isZero();

  inline public function compare(that : BigInt)
    return this.compare(that);

  @:op(A>B) public function greater(that : BigInt) : Bool
    return this.compare(that) > 0;

  @:op(A>=B) public function greaterEqual(that : BigInt) : Bool
    return this.compare(that) >= 0;

  @:op(A<B) public function less(that : BigInt) : Bool
    return this.compare(that) < 0;

  @:op(A<=B) public function lessEqual(that : BigInt) : Bool
    return this.compare(that) <= 0;

  @:op(A=B) @:commutative
  public function equals(that : BigInt) : Bool
    return this.compare(that) == 0;

  @:op(A!=B) @:commutative
  public function notEquals(that : BigInt) : Bool
    return this.compare(that) != 0;

  @:op(A+B) @:commutative
  inline public function add(that : BigInt) : BigInt
    return this.add(that);

  @:op(A-B)
  inline public function subtract(that : BigInt) : BigInt
    return this.subtract(that);

  @:op(-A)
  inline public function negate() : BigInt
    return this.negate();

  @:op(A*B) @:commutative
  inline public function multiply(that : BigInt) : BigInt
    return this.multiply(that);

  @:op(A/B)
  inline public function divide(that : BigInt) : BigInt
    return this.divide(that);

  @:op(A%B)
  inline public function modulo(that : BigInt) : BigInt
    return this.modulo(that);

  @:to inline public function toFloat() : Float
    return this.toFloat();

  @:to inline public function toInt() : Int
    return this.toInt();

  @:to inline public function toString() : String
    return this.toStringWithBase(10);
}

class BigIntImpl {
  var signum : Int;
  var magnitude : Int;
  var length : Int;
  public function new(signum : Int, magnitude : Int, length : Int) {
    this.signum = signum;
    this.magnitude = magnitude;
    this.length = length;
  }

  public function add(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function subtract(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function divide(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function multiply(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function modulo(that : BigIntImpl) : BigIntImpl {
    return this;
  }

  public function negate() : BigIntImpl {
    return this;
  }

  public function isZero() : Bool {
    return false;
  }

  // TODO
  public function compare(that : BigIntImpl) : Int
    return 0;

  // TODO
  public function toFloat() : Float
    return 0;

  // TODO
  public function toInt() : Int
    return 0;

  public function toStringWithBase(base : Int) : String
    return "-7";
}

/*
abstract BigInt(Array<Int>) {
  static inline var CHUNK_SIZE = 15;
  static inline var CHUNK_MASK = (1 << CHUNK_SIZE) - 1;
  static inline var CHUNK_MAX_FLOAT = (1 << (CHUNK_SIZE-1)) * 2.0;
  static inline var MUL_BITS = Std.int(CHUNK_SIZE / 2);
  static inline var MUL_MASK = (1 << MUL_BITS) - 1;

  public static var zero(default, null) = new BigInt([0]);
  public static var one(default, null) = fromInt(1);
  public static var ten(default, null) = fromInt(10);

  static var decs = [zero, one, fromInt(2), fromInt(3), fromInt(4), fromInt(5), fromInt(6), fromInt(7), fromInt(8), fromInt(9)];

  var sign(get, never) : Int;
  var chunks(get, never) : Int;

  public var isNegative(get, never) : Bool;
  public var isZero(get, never) : Bool;

  @:from public static function fromInt(v : Int) {
    var arr;
    if(v < 0) {
      arr = [-1];
      v = -v;
    } else if(v > 0) {
      arr = [1];
    } else {
      arr = [0];
    }
    while(v != 0) {
      arr.push(v & CHUNK_MASK);
      v >>>= CHUNK_SIZE;
    }
    return new BigInt(arr);
  }

  @:from public static function fromFloat(v : Float) {
    var arr;
    v = v < 0 ? Math.fceil(v) : Math.ffloor(v);
    if(v < 0) {
      arr = [-1];
      v = -v;
    } else if(v > 0) {
      arr = [1];
    } else {
      arr = [0];
    }
    while(v != 0) {
      arr.push(Std.int(v % CHUNK_MAX_FLOAT));
      v = Math.ffloor(v / CHUNK_MAX_FLOAT);
    }
    return new BigInt(arr);
  }

  // TODO needs add/subtract/multiply
  @:from public static function fromString(s : String) {
    var isNegative = false,
        current = zero;

    if(s.charAt(0) == "-") {
      isNegative = true;
      s = s.substring(1, s.length);
    }

    var mul = one,
        len = s.length,
        digit;
    for(i in 0...len) {
      digit = s.charCodeAt(len - 1 - i) - '0'.code;
      if(digit < 0 || digit > 9)
        throw new Error("String should only contain digits (and an optional - sign)");
      current = current + (mul * decs[digit]);
      mul *= ten;
      //trace(digit, current, mul);
    }

    if(isNegative)
      return current.negate();
    return current;
  }

  // TODO
  public function fromStringWithBase(s : String, base : Int) : BigInt {
    return zero;
  }

  function new(arr : Array<Int>)
    this = arr;

  public function abs() : BigInt
    return isNegative ? negate() : self();

  // TODO
  public function compare(that : BigInt) : Int {
    if(sign > that.sign) return 1;
    if(sign < that.sign) return -1;
    if(sign == 0) return 0;
    return sign * compareAbs(that);
  }

  // TODO depends on compare
  @:op(A>B) public function greater(that : BigInt) : Bool
    return compare(that) > 0;

  // TODO depends on compare
  @:op(A>=B) public function greaterEqual(that : BigInt) : Bool
    return compare(that) >= 0;

  // TODO depends on compare
  @:op(A<B) public function less(that : BigInt) : Bool
    return compare(that) < 0;

  // TODO depends on compare
  @:op(A<=B) public function lessEqual(that : BigInt) : Bool
    return compare(that) <= 0;

  @:op(-A) public function negate() : BigInt {
    var arr = this.copy();
    arr[0] = -arr[0];
    return new BigInt(arr);
  }

  // TODO
  @:op(A/B) public function divide(that : BigInt) : BigInt
    return intDivision(that).quotient;

  // TODO
  @:op(A%B) public function modulo(that : BigInt) : BigInt
    return intDivision(that).modulus;

  @:op(A*B) @:commutative
  public function multiply(that : BigInt) : BigInt {
    var out = [];
    for(i in 0...chunks + that.chunks)
      out[i] = 0;
    var other = that.toArray(),
        otherChunks = that.chunks,
        a, b, product, carry;

    for(i in 0...chunks) {
      a = this[1+i];
      for(j in 0...otherChunks) {
        b = other[1 + j];
        product = a * b + out[i + j];
        carry = product >>> CHUNK_SIZE;
        out[i + j] = product & CHUNK_MASK;
        out[i + j + 1] += carry;
      }
    }
    return new BigInt(trim([sign * that.sign].concat(out)));
  }

  // TODO
  @:op(A+B) @:commutative
  public function add(that : BigInt) : BigInt {
    if(sign == 0) return that;
    if(that.sign == 0) return self();
    var lhs, rhs;
    if(compareAbs(that) < 0) {
      lhs = that;
      rhs = self();
    } else {
      lhs = self();
      rhs = that;
    }
    if(lhs.sign == rhs.sign)
      return addBig(lhs.toArray(), rhs.toArray());
    else
      return subBig(lhs.toArray(), rhs.toArray());
  }

  public function compareAbs(that : BigInt) {
    if(chunks > that.chunks) return 1;
    if(chunks < that.chunks) return -1;

    var other = that.toArray(),
        i = chunks;
    while(i > 0) {
      if(this[i] > other[i]) return 1;
      if(this[i] < other[i]) return -1;
      i--;
    }
    return 0;
  }

  @:op(A-B) public function subtract(that : BigInt) : BigInt
    return add(-that);

  @:op(A==B) @:commutative
  public function equals(that : BigInt) : Bool {
    if(sign != that.sign || chunks != that.chunks) return false;
    var other = that.toArray();
    for(i in 1...chunks + 1)
      if(this[i] != other[i]) return false;
    return true;
  }

  @:op(A!=B) @:commutative
  public function notEquals(that : BigInt) : Bool
    return !equals(that);

  inline public function toArray() : Array<Int>
    return this;

  @:to public function toFloat() : Float {
    return reduceRightChunks(function(acc : Float, curr : Int) : Float {
      return acc * CHUNK_MAX_FLOAT + curr;
    }, 0.0) * sign;
  }

  // TODO explode on overflow?
  @:to public function toInt() : Int {
    return reduceRightChunks(function(acc : Int, curr : Int) : Int {
      acc <<= CHUNK_SIZE;
      acc |= curr;
      return acc;
    }, 0) * sign;
  }

  // TODO
  public function intDivision(that : BigInt) : { quotient : BigInt, modulus : BigInt } {
    if(that.isZero)
      throw new Error('division by zero');
    if(isZero)
      return {
        quotient : zero,
        modulus : zero
      };
    var comp = compareAbs(that);
    if(comp < 0)
      return {
        quotient : zero,
        modulus : self()
      };
    else if(comp == 0)
      return {
        quotient : one,
        modulus : zero
      };
    if(chunks <= 2) { // TODO check chunk size is reasonable
      var a = toInt(),
          b = that.toInt();
      return {
        quotient : fromInt(Std.int(a / b)),
        modulus : fromInt(a % b)
      };
    }

    var out = [],
        al = chunks + 1,
        bl = that.chunks + 1,
        part : BigInt = new BigInt([1]),
        partArr = part.toArray(),
        other = that.toArray(),
        xlen, highx, highy, guess, check;

    // var base = Std.int(Math.pow(10, CHUNK_SIZE));
    // //trace(base);
    // while(al > 1) {
    //   partArr.insert(1, this[--al]);
    //   if(part.compareAbs(that) < 0) {
    //     out.push(0);
    //     continue;
    //   }
    //   xlen = partArr.length;
    //   highx = partArr[xlen - 1] * base + partArr[xlen - 2];
    //   highy = other[bl - 1] * base + other[bl - 2];
    //   if(xlen > bl) {
    //     highx = (highx + 1) * base;
    //   }
    //   guess = Math.ceil(highx / highy);
    //   trace(guess);
    //
    //   do {
    //     check = that * guess; // inefficient
    //     if(check.compareAbs(part) <= 0)
    //       break;
    //     guess--;
    //     if(guess % 1000000 == 0)
    //       trace(guess);
    //   } while(guess > 0);
    //
    //   out.push(guess);
    //   part = part - check;
    //   partArr = part.toArray();
    // }
    // out.reverse();
    // return {
    //   quotient : new BigInt(trim([sign * that.sign].concat(out))),
    //   modulus : new BigInt(trim([sign].concat(partArr)))
    // };
  }

  // TODO needs intDivision and less
  @:to public function toString() : String {
    //return '['+toArray().join(", ")+']';
    if(sign == 0) return "0";
    var str = "",
        i = isNegative ? -self() : self();

    if(i < ten) {
      str ='${i.toInt()}';
    } else {
      while(!i.isZero) {
        var r = i.intDivision(ten);
        str = r.modulus.toString() + str;
        i = r.quotient;
      }
    }

    return (isNegative ? "-" : "") + str;
  }

  // TODO
  public function toStringWithBase(base : Int) : String {
    return "";
  }

  // TODO this can probably be optimized with a Macro inlining the body
  inline function reduceRightChunks<T>(f : T -> Int -> T, acc : T) : T {
    var i = chunks - 1;
    while(i >= 0)
      acc = f(acc, this[(i--)+1]);
    return acc;
  }

  inline function get_sign()
    return this[0];

  inline function get_chunks() : Int
    return this.length - 1;

  inline function get_isNegative() : Bool
    return sign < 0;

  inline function get_isZero() : Bool
    return sign == 0;

  inline function self() : BigInt
    return new BigInt(this);

  static function trim(arr : Array<Int>) : Array<Int> {
    while(arr[arr.length - 1] == 0 && arr.length > 1)
      arr.pop();
    if(arr.length <= 1)
      arr[0] = 0;
    return arr;
  }

  static function addBig(big : Array<Int>, small : Array<Int>) : BigInt {
    var out = [big[0]],
        carry = 0,
        sum;
    for(i in 1...small.length) {
      sum = big[i] + small[i] + carry;
      carry = sum >>> CHUNK_SIZE;
      sum &= CHUNK_MASK;
      out.push(sum);
    }
    for(i in small.length...big.length) {
      sum = big[i] + carry;
      carry = sum >>> CHUNK_SIZE;
      sum &= CHUNK_MASK;
      out.push(sum);
    }
    if(carry != 0)
      out.push(carry);

    return new BigInt(out);
  }

  static function subBig(big : Array<Int>, small : Array<Int>) : BigInt {
    var out = [big[0]], // set sign
        borrow = 0,
        diff;
    for(i in 1...small.length) {
      diff = big[i] - small[i] - borrow;
      borrow = diff >>> CHUNK_SIZE;
      diff &= CHUNK_MASK;
      out.push(diff);
    }

    for(i in small.length...big.length) {
      diff = big[i] - borrow;
      borrow = diff >>> CHUNK_SIZE;
      diff &= CHUNK_MASK;
      out.push(diff);
    }

    if(borrow != 0)
      out.push(borrow);

    return new BigInt(trim(out));
  }
}
*/