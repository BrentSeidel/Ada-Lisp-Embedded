with BBS.lisp;
--use type BBS.lisp.ptr_type;
use type BBS.lisp.value_type;
with BBS.lisp.evaluate;
with BBS.embed;
with BBS.embed.ain.due;
with BBS.embed.Due.GPIO;
with BBS.embed.due.serial.int;
with BBS.lisp.embed.bme280;
with BBS.lisp.embed.bmp180;
with BBS.lisp.embed.gpio;
with BBS.lisp.embed.l3gd20;
with BBS.lisp.embed.mcp23017;
with BBS.lisp.embed.pca9685;
with BBS.lisp.embed.stepper;

package body BBS.lisp.embed is
   --
   --  Initialize the lisp interpreter and install custom lisp commands
   --
   --
   procedure init is
   begin
      BBS.lisp.add_builtin("analog-read", read_analog'Access);
      BBS.lisp.add_builtin("bme280-read", BBS.lisp.embed.bme280.read_bme280'Access);
      BBS.lisp.add_builtin("bme280-read-raw", BBS.lisp.embed.bme280.read_bme280_raw'Access);
      BBS.lisp.add_builtin("bmp180-read", BBS.lisp.embed.bmp180.read_bmp180'Access);
      BBS.lisp.add_builtin("pin-mode", BBS.lisp.embed.gpio.pin_mode'Access);
      BBS.lisp.add_builtin("pin-pullup", BBS.lisp.embed.gpio.pin_pullup'Access);
      BBS.lisp.add_builtin("pin-read", BBS.lisp.embed.gpio.read_pin'Access);
      BBS.lisp.add_builtin("pin-set", BBS.lisp.embed.gpio.set_pin'Access);
      BBS.lisp.add_builtin("l3gd20-read", BBS.lisp.embed.l3gd20.read_l3gd20'Access);
      BBS.lisp.add_builtin("mcp23017-dir", BBS.lisp.embed.mcp23017.mcp23017_dir'Access);
      BBS.lisp.add_builtin("mcp23017-polarity", BBS.lisp.embed.mcp23017.mcp23017_polarity'Access);
      BBS.lisp.add_builtin("mcp23017-pullup", BBS.lisp.embed.mcp23017.mcp23017_pullup'Access);
      BBS.lisp.add_builtin("mcp23017-read", BBS.lisp.embed.mcp23017.mcp23017_read'Access);
      BBS.lisp.add_builtin("mcp23017-set", BBS.lisp.embed.mcp23017.mcp23017_data'Access);
      BBS.lisp.add_builtin("pca9685-set", BBS.lisp.embed.pca9685.set_pca9685'Access);
      BBS.lisp.add_builtin("stepper-delay", BBS.lisp.embed.stepper.stepper_delay'Access);
      BBS.lisp.add_builtin("stepper-init", BBS.lisp.embed.stepper.stepper_init'Access);
      BBS.lisp.add_builtin("stepper-off", BBS.lisp.embed.stepper.stepper_off'Access);
      BBS.lisp.add_builtin("stepper-step", BBS.lisp.embed.stepper.stepper_step'Access);
   end;
   --
   procedure init_discretes is
   begin
      gpio_pin(0) := BBS.embed.Due.GPIO.pin0;
      gpio_pin(1) := BBS.embed.Due.GPIO.pin1;
      gpio_pin(2) := BBS.embed.Due.GPIO.pin2;
      gpio_pin(3) := BBS.embed.Due.GPIO.pin3;
      gpio_pin(4) := BBS.embed.Due.GPIO.pin4;  -- Don't use this one
      gpio_pin(5) := BBS.embed.Due.GPIO.pin5;
      gpio_pin(6) := BBS.embed.Due.GPIO.pin6;
      gpio_pin(7) := BBS.embed.Due.GPIO.pin7;
      gpio_pin(8) := BBS.embed.Due.GPIO.pin8;
      gpio_pin(9) := BBS.embed.Due.GPIO.pin9;

      gpio_pin(10) := BBS.embed.Due.GPIO.pin10;
      gpio_pin(11) := BBS.embed.Due.GPIO.pin11;
      gpio_pin(12) := BBS.embed.Due.GPIO.pin12;
      gpio_pin(13) := BBS.embed.Due.GPIO.pin13;
      gpio_pin(14) := BBS.embed.Due.GPIO.pin14;
      gpio_pin(15) := BBS.embed.Due.GPIO.pin15;
      gpio_pin(16) := BBS.embed.Due.GPIO.pin16;
      gpio_pin(17) := BBS.embed.Due.GPIO.pin17;
      gpio_pin(18) := BBS.embed.Due.GPIO.pin18;
      gpio_pin(19) := BBS.embed.Due.GPIO.pin19;

      gpio_pin(20) := BBS.embed.Due.GPIO.pin20;
      gpio_pin(21) := BBS.embed.Due.GPIO.pin21;
      gpio_pin(22) := BBS.embed.Due.GPIO.pin22;
      gpio_pin(23) := BBS.embed.Due.GPIO.pin23;
      gpio_pin(24) := BBS.embed.Due.GPIO.pin24;
      gpio_pin(25) := BBS.embed.Due.GPIO.pin25;
      gpio_pin(26) := BBS.embed.Due.GPIO.pin26;
      gpio_pin(27) := BBS.embed.Due.GPIO.pin27;
      gpio_pin(28) := BBS.embed.Due.GPIO.pin28;
      gpio_pin(29) := BBS.embed.Due.GPIO.pin29;

      gpio_pin(30) := BBS.embed.Due.GPIO.pin30;
      gpio_pin(31) := BBS.embed.Due.GPIO.pin31;
      gpio_pin(32) := BBS.embed.Due.GPIO.pin32;
      gpio_pin(33) := BBS.embed.Due.GPIO.pin33;
      gpio_pin(34) := BBS.embed.Due.GPIO.pin34;
      gpio_pin(35) := BBS.embed.Due.GPIO.pin35;
      gpio_pin(36) := BBS.embed.Due.GPIO.pin36;
      gpio_pin(37) := BBS.embed.Due.GPIO.pin37;
      gpio_pin(38) := BBS.embed.Due.GPIO.pin38;
      gpio_pin(39) := BBS.embed.Due.GPIO.pin39;

      gpio_pin(40) := BBS.embed.Due.GPIO.pin40;
      gpio_pin(41) := BBS.embed.Due.GPIO.pin41;
      gpio_pin(42) := BBS.embed.Due.GPIO.pin42;
      gpio_pin(43) := BBS.embed.Due.GPIO.pin43;
      gpio_pin(44) := BBS.embed.Due.GPIO.pin44;
      gpio_pin(45) := BBS.embed.Due.GPIO.pin45;
      gpio_pin(46) := BBS.embed.Due.GPIO.pin46;
      gpio_pin(47) := BBS.embed.Due.GPIO.pin47;
      gpio_pin(48) := BBS.embed.Due.GPIO.pin48;
      gpio_pin(49) := BBS.embed.Due.GPIO.pin49;

      gpio_pin(50) := BBS.embed.Due.GPIO.pin50;
      gpio_pin(51) := BBS.embed.Due.GPIO.pin51;
      gpio_pin(52) := BBS.embed.Due.GPIO.pin52;
      gpio_pin(53) := BBS.embed.Due.GPIO.pin53;
   end;
   --
   --  Functions for custom lisp commands for the Arduino Due
   --
   --  Read the value of one of the analog inputs.
   --
   procedure read_analog(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      param : BBS.lisp.element_type;
      pin : Integer;
      rest : BBS.lisp.cons_index := s;
      value : BBS.embed.uint12;
      ain  : BBS.embed.AIN.due.Due_AIN_record;
   begin
      --
      --  Get the first value
      --
      param := BBS.lisp.evaluate.first_value(rest);
      --
      --  Check if the first value is an integer element.
      --
      if param.kind = BBS.lisp.V_INTEGER then
         pin := Integer(param.i);
         --
         --  Check if the pin number is within range of the valid pins.  Note that
         --  pin 4 cannot be used.
         --
         if (pin < BBS.embed.ain.due.AIN_Num'First) or (pin > BBS.embed.ain.due.AIN_Num'Last) then
            BBS.lisp.error("read-analog", "Pin number is out of range.");
            e := BBS.lisp.make_error(BBS.lisp.ERR_RANGE);
            return;
         end if;
      else
         BBS.lisp.error("read-analog", "Parameter must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  If the parameter is an integer and in range, then read the pin and try
      --  to return the value.
      --
      ain.channel := pin;
      value := ain.get;
      e := (kind => BBS.lisp.V_INTEGER, i => BBS.lisp.int32(value));
   end;
   --
   --  Read the value of one of the analog inputs.
   --
   procedure set_analog(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      pragma Unreferenced (s);
   begin
      e := BBS.lisp.NIL_ELEM;
   end;
   --
end BBS.lisp.embed;
