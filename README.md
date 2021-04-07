# Ada-Lisp-Embedded
Extensions to the Tiny Lisp language for embedded applications

Due to hardware differences, not all operations will be supported on all
platforms.  It is expected that the Arduino Due and the Raspberry PI will
be supported.  Select the appropriate .gpr file for your platform.
Platform specific code will be in its own subdirectory, while common
code will be in a common subdirectory.

## Lisp operations for the Arduino Due
The following Lisp operations are added.
* (set-pin &lt;pin number&gt; &lt;state 0 or 1&gt;) - Sets digital output pin to specified level
* (pin-mode &lt;pin number&gt; &lt;mode 0 or 1&gt;) - Sets digital pin 0 = input, 1 = output
* (read-pin &lt;pin number&gt;) - Returns the state of a digital pin
* (read-analog &lt;analog input&gt;) - Returns the value of an analog input
* (read-bmp180) - Returns temperature (in tenth of a degree C) and pressure
  (in Pascals) from BMP180 sensor
* (set-pca9685 &lt;pin&gt; &lt;value&gt;) - Sets PWM value for the specified PCA9685 pin.
* (read-l3gd20) - Returns x, y, and z rotation rates in tenth of a degree per second.
