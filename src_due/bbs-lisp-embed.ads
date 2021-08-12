with BBS.embed.GPIO.Due;
with BBS.embed.i2c.BME280;
with BBS.embed.i2c.BMP180;
with BBS.embed.i2c.L3GD20H;
with BBS.embed.i2c.MCP23017;
with BBS.embed.i2c.PCA9685;
with BBS.lisp;
package BBS.lisp.embed is

   procedure init;
   procedure init_discretes;
   --
   --  Flags for I2C devices
   --
   type i2c_device_location is (absent, bus0, bus1);
   bme280_found      : i2c_device_location := absent;
   bmp180_found      : i2c_device_location := absent;
   l3gd20_found      : i2c_device_location := absent;
   pca9685_found     : i2c_device_location := absent;
   lsm303dlhc_found  : i2c_device_location := absent;
   MCP23017_found    : array (0 .. 7) of i2c_device_location;
   --
   --  Device records
   --
   BMP180_info   : aliased BBS.embed.i2c.BMP180.BMP180_record;
   BME280_info   : aliased BBS.embed.i2c.BME280.BME280_record;
   L3GD20_info   : aliased BBS.embed.i2c.L3GD20H.L3GD20H_record;
   PCA9685_info  : aliased BBS.embed.i2c.PCA9685.PS9685_record;
   MCP23017_info : array (0 .. 7) of aliased BBS.embed.i2c.MCP23017.MCP23017_record;
   --
   --  Info for GPIO
   --
   gpio_max_pin : Natural := 53;
   gpio_pin : array (0 .. gpio_max_pin) of BBS.embed.GPIO.Due.Due_GPIO_ptr;
private
   --
   --  Functions for custom lisp operations for the Arduino Due
   --
   --  Currently defined lisp operations in this package are:
   --
   --  Read the value of one of the analog inputs.
   --
   procedure read_analog(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --  (analog-read integer)
   --    The integer is the pin number range checked to the subtype
   --    BBS.embed.ain.due.AIN_Num.  Returns the analog value of the pin.
   --
   --
   --  Sets the value of one of the analog outputs (not yet implemented).
   --
   procedure set_analog(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --  (analog-set integer integer)
   --    The first integer is the pin number range checked to 0 or 1.  The second
   --    integer is the value to write to the output, range limited to 0-4095.
   --    Returns NIL.
   --

end BBS.lisp.embed;
