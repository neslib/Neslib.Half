# Neslib.Half - Half-Precision Floating-Point for Delphi

This small library defines the `Half` type, which is a [16-bit half-precision floating-point value](https://en.wikipedia.org/wiki/Half-precision_floating-point_format).

The `Half` type uses overloaded operators so you can use it just like a `Single` or `Double` type (albeit with lower precision).

The `Neslib.Half` unit also defines a record helper for the `Half` type to provide access to the internals of the `Half` type (in a similar way that there are record helpers for the `Single` and `Double` types).

The `Half` type is used by some image formats to provide a higher dynamic range than 8 bits per channel, without resorting to the overhead of using 32 bits per channel. You can also use it for more efficient storage of floating-point values in case the value can be fit into a Half without loss of precision. You can use `GetSmallestFloatType` to determine if a `Double` value fits into a `Single` or `Half` without loss of precision.

This library uses fast conversion algorithms developed by Jeroen van der Zijp to convert from Half to Single and vice versa in a fast but accurate way (see his paper "[Fast Half Float Conversions](ftp://ftp.fox-toolkit.org/pub/fasthalffloatconversion.pdf)").

## License

Neslib.Half is licensed under the Simplified BSD License. 

See License.txt for details.