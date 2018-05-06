unit Tests;

interface

uses
  System.Math,
  System.SysUtils,
  DUnitX.TestFramework,
  Neslib.Half;

type
  TestHalf = class
  private
    FUSFormatSettings: TFormatSettings;
    FNLFormatSettings: TFormatSettings;
  public
    [SetupFixture] procedure SetupFixture;
    [Test] procedure TestRoundTripAllValues;
    [Test] procedure TestRoundTripAllIntegers;
    [Test] procedure TestTrunc;
    [Test] procedure TestRound;
    [Test] procedure TestImplicitConversionFromSingle;
    [Test] procedure TestImplicitConversionFromDouble;
    [Test] procedure TestImplicitConversionFromOrdinal;
    [Test] procedure TestImplicitConversionToSingle;
    [Test] procedure TestImplicitConversionToDouble;
    [Test] procedure TestExplicitConversionToOrdinal;
    [Test] procedure TestConstants;
    [Test] procedure TestComparison;
    [Test] procedure TestNegative;
    [Test] procedure TestPositive;
    [Test] procedure TestArithmetic;
    [Test] procedure TestIntegerArithmetic;
    [Test] procedure TestElements;
    [Test] procedure TestGetSmallestFloatType;
  end;

implementation

{ TestHalf }

procedure TestHalf.SetupFixture;
begin
  { Disable floating-point exceptions for testing Infinity and NaN values. }
  {$WARN SYMBOL_PLATFORM OFF}
  SetExceptionMask(exAllArithmeticExceptions);
  {$IFNDEF NEXTGEN}
  SetSSEExceptionMask(exAllArithmeticExceptions);
  {$ENDIF}
  {$WARN SYMBOL_PLATFORM ON}

  { Allow for consistent conversion }
  FUSFormatSettings := TFormatSettings.Create('en-US');
  FUSFormatSettings.DecimalSeparator := '.';
  FUSFormatSettings.ThousandSeparator := ',';

  FNLFormatSettings := TFormatSettings.Create('nl-NL');
  FNLFormatSettings.DecimalSeparator := ',';
  FNLFormatSettings.ThousandSeparator := '.';
end;

procedure TestHalf.TestArithmetic;
var
  A, B, C: Half;
begin
  A := -2.5;
  B := 5.75;

  C := A + B;
  Assert.AreEqual<Single>(3.25, C);

  C := B + A;
  Assert.AreEqual<Single>(3.25, C);

  C := A - B;
  Assert.AreEqual<Single>(-8.25, C);

  C := B - A;
  Assert.AreEqual<Single>(8.25, C);

  C := A * B;
  Assert.AreEqual<Single>(-14.375, C);

  C := B * A;
  Assert.AreEqual<Single>(-14.375, C);

  C := A / B;
  Assert.AreEqual<Single>(-0.4345703125, C);

  C := B / A;
  Assert.AreEqual<Single>(-2.298828125, C);

  B := 0;
  C := A / B;
  Assert.IsTrue(C.IsNegativeInfinity);
end;

procedure TestHalf.TestComparison;
var
  A, B: Half;
begin
  A := 12.5;
  B := 12.5;
  Assert.IsTrue(A = B);
  Assert.IsFalse(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsFalse(A < B);
  Assert.IsTrue(A >= B);
  Assert.IsTrue(A <= B);

  A := 0.125;
  B := 12.5;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsTrue(A < B);
  Assert.IsFalse(A >= B);
  Assert.IsTrue(A <= B);

  A := -2.5;
  B := 0.125;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsTrue(A < B);
  Assert.IsFalse(A >= B);
  Assert.IsTrue(A <= B);

  A := 2.5;
  B := -0.125;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsTrue(A > B);
  Assert.IsFalse(A < B);
  Assert.IsTrue(A >= B);
  Assert.IsFalse(A <= B);

  // NaN compares with nothing
  A := Half.NaN;
  B := 2.5;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsFalse(A < B);
  Assert.IsFalse(A >= B);
  Assert.IsFalse(A <= B);

  A := 2.5;
  B := Half.NaN;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsFalse(A < B);
  Assert.IsFalse(A >= B);
  Assert.IsFalse(A <= B);

  A := Half.NaN;
  B := Half.NaN;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsFalse(A < B);
  Assert.IsFalse(A >= B);
  Assert.IsFalse(A <= B);

  A := Half.NegativeInfinity;
  B := Half.NaN;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsFalse(A < B);
  Assert.IsFalse(A >= B);
  Assert.IsFalse(A <= B);

  // Infinity
  A := Half.PositiveInfinity;
  B := Half.PositiveInfinity;
  Assert.IsTrue(A = B);
  Assert.IsFalse(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsFalse(A < B);
  Assert.IsTrue(A >= B);
  Assert.IsTrue(A <= B);

  // Infinity
  A := Half.PositiveInfinity;
  B := 5.5;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsTrue(A > B);
  Assert.IsFalse(A < B);
  Assert.IsTrue(A >= B);
  Assert.IsFalse(A <= B);

  A := Half.NegativeInfinity;
  B := 5.5;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsTrue(A < B);
  Assert.IsFalse(A >= B);
  Assert.IsTrue(A <= B);

  A := Half.NegativeInfinity;
  B := Half.PositiveInfinity;
  Assert.IsFalse(A = B);
  Assert.IsTrue(A <> B);
  Assert.IsFalse(A > B);
  Assert.IsTrue(A < B);
  Assert.IsFalse(A >= B);
  Assert.IsTrue(A <= B);
end;

procedure TestHalf.TestConstants;
var
  S: Single;
begin
  S := Half.Epsilon;
  Assert.AreEqual<Single>(0.0009765625, S);

  S := Half.MaxValue;
  Assert.AreEqual<Single>(65504.0, S);

  S := Half.MinValue;
  Assert.AreEqual<Single>(0.00006103515625, S);

  S := Half.PositiveInfinity;
  Assert.IsTrue(S.IsPositiveInfinity);

  S := Half.NegativeInfinity;
  Assert.IsTrue(S.IsNegativeInfinity);

  S := Half.NaN;
  Assert.IsTrue(S.IsNan);
end;

procedure TestHalf.TestElements;
var
  H: Half;
begin
  H := 0;
  Assert.IsFalse(H.Sign);
  Assert.AreEqual(0, H.Exp);
  Assert.AreEqual(0, H.Frac);
  Assert.AreEqual(0, H.Exponent);
  Assert.AreEqual<Extended>(0, H.Fraction);
  Assert.AreEqual(0, H.Mantissa);
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsZero, H.SpecialType);
  Assert.AreEqual<Byte>(0, H.Bytes[0]);
  Assert.AreEqual<Byte>(0, H.Bytes[1]);
  Assert.AreEqual<Word>(0, H.Words[0]);
  Assert.IsFalse(H.IsNan);
  Assert.IsFalse(H.IsInfinity);
  Assert.IsFalse(H.IsNegativeInfinity);
  Assert.IsFalse(H.IsPositiveInfinity);
  Assert.IsFalse(Half.IsNan(H));
  Assert.IsFalse(Half.IsInfinity(H));
  Assert.IsFalse(Half.IsNegativeInfinity(H));
  Assert.IsFalse(Half.IsPositiveInfinity(H));

  H := -H;
  Assert.IsTrue(H.Sign);
  Assert.AreEqual(0, H.Exp);
  Assert.AreEqual(0, H.Frac);
  Assert.AreEqual(0, H.Exponent);
  Assert.AreEqual<Extended>(0, H.Fraction);
  Assert.AreEqual(0, H.Mantissa);
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsNZero, H.SpecialType);
  Assert.AreEqual<Byte>(0, H.Bytes[0]);
  Assert.AreEqual<Byte>($80, H.Bytes[1]);
  Assert.AreEqual<Word>($8000, H.Words[0]);

  H := 1;
  Assert.IsFalse(H.Sign);
  Assert.AreEqual($0F, H.Exp);
  Assert.AreEqual(0, H.Frac);
  Assert.AreEqual(0, H.Exponent);
  Assert.AreEqual<Extended>(1, H.Fraction);
  Assert.AreEqual($0400, H.Mantissa);
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsPositive, H.SpecialType);
  Assert.AreEqual<Byte>(0, H.Bytes[0]);
  Assert.AreEqual<Byte>($3C, H.Bytes[1]);
  Assert.AreEqual<Word>($3C00, H.Words[0]);

  H.Exp := $10;
  Assert.AreEqual<Single>(2, H);

  H.Sign := True;
  Assert.AreEqual<Single>(-2, H);
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsNegative, H.SpecialType);

  H.Frac := $0155;
  Assert.AreEqual<Single>(-2.666015625, H);

  H.Exp := 0;
  H.Frac := $03FF;
  Assert.AreEqual(0, H.Exp);
  Assert.AreEqual(-14, H.Exponent);
  Assert.AreEqual<Extended>($03FF / $0400, H.Fraction);
  Assert.AreEqual($03FF, H.Mantissa);
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsNDenormal, H.SpecialType);
  Assert.AreEqual<Single>(-6.09755516e-5, H);

  H := -H;
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsDenormal, H.SpecialType);
  Assert.AreEqual<Single>(6.09755516e-5, H);

  H := Half.PositiveInfinity;
  Assert.IsFalse(H.Sign);
  Assert.AreEqual($1F, H.Exp);
  Assert.AreEqual(0, H.Frac);
  Assert.AreEqual(0, H.Exponent);
  Assert.AreEqual<Extended>(Extended.PositiveInfinity, H.Fraction);
  Assert.AreEqual(0, H.Mantissa);
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsInf, H.SpecialType);
  Assert.IsFalse(H.IsNan);
  Assert.IsTrue(H.IsInfinity);
  Assert.IsFalse(H.IsNegativeInfinity);
  Assert.IsTrue(H.IsPositiveInfinity);
  Assert.IsFalse(Half.IsNan(H));
  Assert.IsTrue(Half.IsInfinity(H));
  Assert.IsFalse(Half.IsNegativeInfinity(H));
  Assert.IsTrue(Half.IsPositiveInfinity(H));

  H := Half.NegativeInfinity;
  Assert.IsTrue(H.Sign);
  Assert.AreEqual($1F, H.Exp);
  Assert.AreEqual(0, H.Frac);
  Assert.AreEqual(0, H.Exponent);
  Assert.AreEqual<Extended>(Extended.PositiveInfinity, H.Fraction);
  Assert.AreEqual(0, H.Mantissa);
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsNInf, H.SpecialType);
  Assert.IsFalse(H.IsNan);
  Assert.IsTrue(H.IsInfinity);
  Assert.IsTrue(H.IsNegativeInfinity);
  Assert.IsFalse(H.IsPositiveInfinity);
  Assert.IsFalse(Half.IsNan(H));
  Assert.IsTrue(Half.IsInfinity(H));
  Assert.IsTrue(Half.IsNegativeInfinity(H));
  Assert.IsFalse(Half.IsPositiveInfinity(H));

  H := Half.NaN;
  Assert.IsFalse(H.Sign);
  Assert.AreEqual($1F, H.Exp);
  Assert.AreEqual($03FF, H.Frac);
  Assert.AreEqual(-14, H.Exponent);
  Assert.IsTrue(H.Fraction.IsNan);
  Assert.AreEqual($03FF, H.Mantissa);
  Assert.AreEqual<TFloatSpecial>(TFloatSpecial.fsNaN, H.SpecialType);
  Assert.IsTrue(H.IsNan);
  Assert.IsFalse(H.IsInfinity);
  Assert.IsFalse(H.IsNegativeInfinity);
  Assert.IsFalse(H.IsPositiveInfinity);
  Assert.IsTrue(Half.IsNan(H));
  Assert.IsFalse(Half.IsInfinity(H));
  Assert.IsFalse(Half.IsNegativeInfinity(H));
  Assert.IsFalse(Half.IsPositiveInfinity(H));

  H.BuildUp(True, $0155, -2);
  Assert.AreEqual<Single>(-0.333251953125, H);
  Assert.AreEqual<Byte>($55, H.Bytes[0]);
  Assert.AreEqual<Byte>($B5, H.Bytes[1]);
  Assert.AreEqual<Word>($B555, H.Words[0]);

  H.Bytes[1] := $35;
  Assert.AreEqual<Single>(0.333251953125, H);

  H.Words[0] := $7BFF;
  Assert.AreEqual<Single>(65504.0, H);
end;

procedure TestHalf.TestExplicitConversionToOrdinal;
var
  H: Half;
begin
  H := 32.5;

  Assert.AreEqual<Int8>(32, Int8(H));
  Assert.AreEqual<UInt8>(32, UInt8(H));
  Assert.AreEqual<Int16>(32, Int16(H));
  Assert.AreEqual<UInt16>(32, UInt16(H));
  Assert.AreEqual<Int32>(32, Int32(H));
  Assert.AreEqual<UInt32>(32, UInt32(H));
  Assert.AreEqual<Int64>(32, Int64(H));
  Assert.AreEqual<UInt64>(32, UInt64(H));

  // 8 bit

  H := 150.5;
  Assert.AreEqual<Int8>(127, Int8(H));
  Assert.AreEqual<UInt8>(150, UInt8(H));

  H := -50.5;
  Assert.AreEqual<Int8>(-50, Int8(H));
  Assert.AreEqual<UInt8>(0, UInt8(H));

  H := 100000;
  Assert.AreEqual<Int8>(127, Int8(H));
  Assert.AreEqual<UInt8>(255, UInt8(H));

  H := -100000;
  Assert.AreEqual<Int8>(-128, Int8(H));
  Assert.AreEqual<UInt8>(0, UInt8(H));

  // 16 bit

  H := 40000.5;
  Assert.AreEqual<Int16>(32767, Int16(H));
  Assert.AreEqual<UInt16>(40000, UInt16(H));

  H := -30000.5;
  Assert.AreEqual<Int16>(-30000, Int16(H));
  Assert.AreEqual<UInt16>(0, UInt16(H));

  H := 100000;
  Assert.AreEqual<Int16>(32767, Int16(H));
  Assert.AreEqual<UInt16>(65535, UInt16(H));

  H := -100000;
  Assert.AreEqual<Int16>(-32768, Int16(H));
  Assert.AreEqual<UInt16>(0, UInt16(H));

  // 32/64 bit

  H := 40000.5;
  Assert.AreEqual<Int32>(40000, Int32(H));
  Assert.AreEqual<UInt32>(40000, UInt32(H));
  Assert.AreEqual<Int64>(40000, Int64(H));
  Assert.AreEqual<UInt64>(40000, UInt64(H));

  H := -40000.5;
  Assert.AreEqual<Int32>(-40000, Int32(H));
  Assert.AreEqual<UInt32>(0, UInt32(H));
  Assert.AreEqual<Int64>(-40000, Int64(H));
  Assert.AreEqual<UInt64>(0, UInt64(H));

  H := 100000;
  Assert.AreEqual<Int32>($7FFFFFFF, Int32(H));
  Assert.AreEqual<UInt32>($FFFFFFFF, UInt32(H));
  Assert.AreEqual<Int64>($7FFFFFFFFFFFFFFF, Int64(H));
  Assert.AreEqual<UInt64>($FFFFFFFFFFFFFFFF, UInt64(H));

  H := -100000;
  Assert.AreEqual<Int32>(-$80000000, Int32(H));
  Assert.AreEqual<UInt32>(0, UInt32(H));
  Assert.AreEqual<Int64>(-$8000000000000000, Int64(H));
  Assert.AreEqual<UInt64>(0, UInt64(H));
end;

procedure TestHalf.TestGetSmallestFloatType;
var
  H: Half;
  D: Double;
  I: Integer;
begin
  // All possible Half values fit into a Half
  for I := $0000 to $FFFF do
  begin
    H.Words[0] := I;

    // When converting a Half to Single or Double, subnormals are converted to
    // normalized values, which may not fit into a Half, but do fit in a Single.
    D := H;
    if (H.SpecialType in [TFloatSpecial.fsDenormal, TFloatSpecial.fsNDenormal]) then
      Assert.AreEqual<TFloatType>(TFloatType.Single, GetSmallestFloatType(D))
    else
      Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(D));
  end;

  // All Infinity and NaN values fit into a Half
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Half.PositiveInfinity));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Half.NegativeInfinity));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Half.NaN));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Single.PositiveInfinity));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Single.NegativeInfinity));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Single.NaN));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Double.PositiveInfinity));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Double.NegativeInfinity));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Double.NaN));

  // Min and Max values depend on type
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Half.MinValue));
  Assert.AreEqual<TFloatType>(TFloatType.Half, GetSmallestFloatType(Half.MaxValue));
  Assert.AreEqual<TFloatType>(TFloatType.Single, GetSmallestFloatType(Single.MinValue));
  Assert.AreEqual<TFloatType>(TFloatType.Single, GetSmallestFloatType(Single.MaxValue));
  Assert.AreEqual<TFloatType>(TFloatType.Double, GetSmallestFloatType(Double.MinValue));
  Assert.AreEqual<TFloatType>(TFloatType.Double, GetSmallestFloatType(Double.MaxValue));

  // Repeating mantissa always requires Double
  Assert.AreEqual<TFloatType>(TFloatType.Double, GetSmallestFloatType(1 / 3));
end;

procedure TestHalf.TestImplicitConversionFromDouble;
var
  H: Half;
  Src, Dst: Double;
begin
  Src := 0;
  H := Src;
  Dst := H;
  Assert.AreEqual<Double>(0, Dst);

  Src := -0.000234603881835938;
  H := Src;
  Dst := H;
  Assert.AreEqual(-0.000234603881835938, Dst, 1e-15);

  Src := 3.5;
  H := Src;
  Dst := H;
  Assert.AreEqual<Double>(3.5, Dst);

  Src := -3.5;
  H := Src;
  Dst := H;
  Assert.AreEqual<Double>(-3.5, Dst);

  Src := 500.25;
  H := Src;
  Dst := H;
  Assert.AreEqual<Double>(500.25, Dst);

  Src := -1500.25;
  H := Src;
  Dst := H;
  Assert.AreEqual<Double>(-1500, Dst);

  Src := 1e300;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsPositiveInfinity);

  Src := 1e100;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsPositiveInfinity);

  Src := 1234.5;
  H := Src;
  Dst := H;
  Assert.AreEqual<Double>(1234.0, Dst);

  Src := 0.000005;
  H := Src;
  Dst := H;
  Assert.AreEqual(0.00000494718551635742, Dst, 1e-15);

  Src := Double.NaN;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsNan);

  Src := Double.PositiveInfinity;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsPositiveInfinity);

  Src := Double.NegativeInfinity;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsNegativeInfinity);
end;

procedure TestHalf.TestImplicitConversionFromOrdinal;
var
  H: Half;
  S: Single;
begin
  H := Int8(-12);
  S := H;
  Assert.AreEqual<Single>(-12, S);

  H := UInt8(120);
  S := H;
  Assert.AreEqual<Single>(120, S);

  H := Int16(-32000);
  S := H;
  Assert.AreEqual<Single>(-32000, S);

  H := UInt16(48000);
  S := H;
  Assert.AreEqual<Single>(48000, S);

  H := Int32(-5000);
  S := H;
  Assert.AreEqual<Single>(-5000, S);

  H := Int32(-500000);
  S := H;
  Assert.IsTrue(S.IsNegativeInfinity);

  H := UInt32(8000);
  S := H;
  Assert.AreEqual<Single>(8000, S);

  H := UInt32(500000);
  S := H;
  Assert.IsTrue(S.IsPositiveInfinity);

  H := Int32(-5000);
  S := H;
  Assert.AreEqual<Single>(-5000, S);

  H := Int64(-1234);
  S := H;
  Assert.AreEqual<Single>(-1234, S);

  H := Int64(-123456789098765432);
  S := H;
  Assert.IsTrue(S.IsNegativeInfinity);

  H := UInt64(2001);
  S := H;
  Assert.AreEqual<Single>(2001, S);

  H := UInt64(123456789098765432);
  S := H;
  Assert.IsTrue(S.IsPositiveInfinity);
end;

procedure TestHalf.TestImplicitConversionFromSingle;
var
  H: Half;
  Src, Dst: Single;
begin
  Src := 0;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(0, Dst);

  Src := -0.000234603881835938;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(-0.000234603881835938, Dst);

  Src := 3.5;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(3.5, Dst);

  Src := -3.5;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(-3.5, Dst);

  Src := 500.25;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(500.25, Dst);

  Src := -1500.25;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(-1500, Dst);

  Src := 50000.25;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(49984, Dst);

  Src := -50000.25;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(-49984, Dst);

  Src := 9.16421413421631e-07;
  H := Src;
  Dst := H;
  Assert.AreEqual<Single>(8.94069671630859e-07, Dst);

  Src := -1e7;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsNegativeInfinity);

  Src := Single.NaN;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsNan);

  Src := Single.PositiveInfinity;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsPositiveInfinity);

  Src := Single.NegativeInfinity;
  H := Src;
  Dst := H;
  Assert.IsTrue(Dst.IsNegativeInfinity);
end;

procedure TestHalf.TestImplicitConversionToDouble;
begin
  { Tested by TestImplicitConversionFromDouble }
end;

procedure TestHalf.TestImplicitConversionToSingle;
begin
  { Tested by other implicit conversion tests. }
end;

procedure TestHalf.TestIntegerArithmetic;
var
  A, C: Half;
  B: Integer;
begin
  A := -2.5;
  B := 6;

  C := A + B;
  Assert.AreEqual<Single>(3.5, C);

  C := B + A;
  Assert.AreEqual<Single>(3.5, C);

  C := A - B;
  Assert.AreEqual<Single>(-8.5, C);

  C := B - A;
  Assert.AreEqual<Single>(8.5, C);

  C := A * B;
  Assert.AreEqual<Single>(-15, C);

  C := B * A;
  Assert.AreEqual<Single>(-15, C);

  C := A / B;
  Assert.AreEqual<Single>(-0.41650390625, C);

  C := B / A;
  Assert.AreEqual<Single>(-2.3984375, C);

  B := 0;
  C := A / B;
  Assert.IsTrue(C.IsNegativeInfinity);
end;

procedure TestHalf.TestNegative;
var
  H: Half;
begin
  H := 2.5;
  H := -H;
  Assert.AreEqual<Single>(-2.5, H);
  H := -H;
  Assert.AreEqual<Single>(2.5, H);

  H := Half.PositiveInfinity;
  H := -H;
  Assert.IsTrue(H.IsNegativeInfinity);
  H := -H;
  Assert.IsTrue(H.IsPositiveInfinity);
end;

procedure TestHalf.TestPositive;
var
  H: Half;
begin
  H := 2.5;
  H := +H;
  Assert.AreEqual<Single>(2.5, H);
  H := +H;
  Assert.AreEqual<Single>(2.5, H);

  H := Half.PositiveInfinity;
  H := +H;
  Assert.IsTrue(H.IsPositiveInfinity);
  H := +H;
  Assert.IsTrue(H.IsPositiveInfinity);
end;

procedure TestHalf.TestRound;
var
  H: Half;
  I: Integer;
begin
  H := 0;
  I := Round(H);
  Assert.AreEqual(0, I);

  H := 3.1;
  I := Round(H);
  Assert.AreEqual(3, I);

  H := -4.1;
  I := Round(H);
  Assert.AreEqual(-4, I);

  H := 5.9;
  I := Round(H);
  Assert.AreEqual(6, I);

  H := -6.9;
  I := Round(H);
  Assert.AreEqual(-7, I);

  H := 7.5;
  I := Round(H);
  Assert.AreEqual(8, I);

  H := -8.5;
  I := Round(H);
  Assert.AreEqual(-9, I);

  { Integers between 4096 and 8192 round to a multiple of 4.
    Note that the Half value is already rounded (towards zero) on assignment,
    so rounding back to Integer is always towards zero. }
  H := 4099.9;
  I := Round(H);
  Assert.AreEqual(4096, I);

  H := 4100.1;
  I := Round(H);
  Assert.AreEqual(4100, I);

  H := 4098;
  I := Round(H);
  Assert.AreEqual(4096, I);

  { Integers between 8192 and 16384 round to a multiple of 8 }
  H := -8207.9;
  I := Round(H);
  Assert.AreEqual(-8200, I);

  H := -8208.1;
  I := Round(H);
  Assert.AreEqual(-8208, I);

  H := -8204;
  I := Round(H);
  Assert.AreEqual(-8200, I);

  { +/- infinity maps to maximum Int32 range }
  H := Half.PositiveInfinity;
  I := Trunc(H);
  Assert.AreEqual(Integer.MaxValue, I);

  H := Half.NegativeInfinity;
  I := Trunc(H);
  Assert.AreEqual(Integer.MinValue, I);
end;

procedure TestHalf.TestRoundTripAllIntegers;
var
  I, Actual: Integer;
  H: Half;
  S: Single;
begin
  { Integers between 0 and 2048 can be exactly represented }
  for I := 0 to 2047 do
  begin
    { Integer => Half }
    H := I;

    { Half => Integer }
    Actual := Trunc(H);
    Assert.AreEqual(I, Actual);

    H := -I;
    Actual := Trunc(H);
    Assert.AreEqual(-I, Actual);
  end;

  { Integers between 2048 and 4096 round to a multiple of 2 }
  I := 2048;
  while (I < 4096) do
  begin
    H := I;
    Actual := Trunc(H);
    Assert.AreEqual(I, Actual);

    H := -I;
    Actual := Trunc(H);
    Assert.AreEqual(-I, Actual);

    Inc(I, 2);
  end;

  { Integers between 4096 and 8192 round to a multiple of 4 }
  while (I < 8192) do
  begin
    H := I;
    Actual := Trunc(H);
    Assert.AreEqual(I, Actual);

    H := -I;
    Actual := Trunc(H);
    Assert.AreEqual(-I, Actual);

    Inc(I, 4);
  end;

  { Integers between 8192 and 16384 round to a multiple of 8 }
  while (I < 16384) do
  begin
    H := I;
    Actual := Trunc(H);
    Assert.AreEqual(I, Actual);

    H := -I;
    Actual := Trunc(H);
    Assert.AreEqual(-I, Actual);

    Inc(I, 8);
  end;

  { Integers between 16384 and 32768 round to a multiple of 16 }
  while (I < 32768) do
  begin
    H := I;
    Actual := Trunc(H);
    Assert.AreEqual(I, Actual);

    H := -I;
    Actual := Trunc(H);
    Assert.AreEqual(-I, Actual);

    Inc(I, 16);
  end;

  { Integers between 32768 and 65536 round to a multiple of 32 }
  while (I < 65536) do
  begin
    H := I;
    Actual := Trunc(H);
    Assert.AreEqual(I, Actual);

    H := -I;
    Actual := Trunc(H);
    Assert.AreEqual(-I, Actual);

    Inc(I, 32);
  end;

  { Integers equal to or above 65536 are rounded to "infinity" }
  H := 65536;
  S := H;
  Assert.IsTrue(S.IsPositiveInfinity);
  Actual := Trunc(H);
  Assert.AreEqual(Integer.MaxValue, Actual);

  H := -65536;
  S := H;
  Assert.IsTrue(S.IsNegativeInfinity);
  Actual := Trunc(H);
  Assert.AreEqual(Integer.MinValue, Actual);
end;

procedure TestHalf.TestRoundTripAllValues;
var
  Val: UInt16;
  H: Half absolute Val;
  ActualHalf: Half;
  ActualHalfVal: UInt16 absolute ActualHalf;
  Exponent, Mantissa: Integer;
  ExpectedSingle, ActualSingle: Single;
begin
  { Test all 65536 possible bit patterns }
  for Val := 32768 to $FFFF do
  begin
    Exponent := ((Val shr 10) and $1F) - 15;
    Mantissa := Val and $03FF;

    { Calculate expected value }
    if (Exponent = -15) then
    begin
      { Zero and subnormals }
      if (Mantissa = 0) then
        ExpectedSingle := 0
      else
        ExpectedSingle := Power(2, -14) * (Mantissa / $0400);
    end
    else if (Exponent < 16) then
    begin
      { Normalized values }
      ExpectedSingle := Power(2, Exponent) * (1 + (Mantissa / $0400));
    end
    else
    begin
      { Special values }
      if (Mantissa = 0) then
        ExpectedSingle := Single.PositiveInfinity
      else
        ExpectedSingle := Single.NaN;
    end;

    if (Val >= $8000) then
      ExpectedSingle := -ExpectedSingle;

    { Convert Half => Single }
    ActualSingle := H;

    if (ExpectedSingle.IsNan) then
      Assert.IsTrue(ActualSingle.IsNan)
    else
      Assert.AreEqual(ExpectedSingle, ActualSingle);

    { Convert Single => Half }
    ActualHalf := ExpectedSingle;
    if (Exponent = 16) and (Mantissa <> 0) then
      { NaN can be represented in multiple ways }
    else if (Expectedsingle = 0) then
      { On 64-bit systems, there is no difference between 0.0 and -0.0 }
      Assert.AreEqual<Integer>(0, ActualHalfVal and $7FFF)
    else
      Assert.AreEqual(Val, ActualHalfVal);
  end;
end;

procedure TestHalf.TestTrunc;
var
  H: Half;
  I: Integer;
begin
  H := 0;
  I := Trunc(H);
  Assert.AreEqual(0, I);

  H := 3.1;
  I := Trunc(H);
  Assert.AreEqual(3, I);

  H := -4.1;
  I := Trunc(H);
  Assert.AreEqual(-4, I);

  H := 5.9;
  I := Trunc(H);
  Assert.AreEqual(5, I);

  H := -6.9;
  I := Trunc(H);
  Assert.AreEqual(-6, I);

  H := 7.5;
  I := Trunc(H);
  Assert.AreEqual(7, I);

  H := -8.5;
  I := Trunc(H);
  Assert.AreEqual(-8, I);

  { Integers between 4096 and 8192 round to a multiple of 4 }
  H := 4099.9;
  I := Trunc(H);
  Assert.AreEqual(4096, I);

  H := 4100.1;
  I := Trunc(H);
  Assert.AreEqual(4100, I);

  H := 4098;
  I := Trunc(H);
  Assert.AreEqual(4096, I);

  { Integers between 8192 and 16384 round to a multiple of 8 }
  H := -8207.9;
  I := Trunc(H);
  Assert.AreEqual(-8200, I);

  H := -8208.1;
  I := Trunc(H);
  Assert.AreEqual(-8208, I);

  H := -8204;
  I := Trunc(H);
  Assert.AreEqual(-8200, I);

  { +/- infinity maps to maximum Int32 range }
  H := Half.PositiveInfinity;
  I := Trunc(H);
  Assert.AreEqual(Integer.MaxValue, I);

  H := Half.NegativeInfinity;
  I := Trunc(H);
  Assert.AreEqual(Integer.MinValue, I);
end;

initialization
  ReportMemoryLeaksOnShutdown := True;
  TDUnitX.RegisterTestFixture(TestHalf);

end.
