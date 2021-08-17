with BBS.lisp.embed.GPIO;
with BBS.lisp.embed.mcp23017;
with BBS.lisp.embed.stepper;
with BBS.lisp.evaluate;
with BBS.embed;
use type BBS.embed.addr7;
with BBS.embed.GPIO.Linux;
with BBS.embed.RPI;
with bbs.embed.i2c;
use type bbs.embed.i2c.err_code;
with BBS.embed.i2c.MCP23017;


package body BBS.lisp.embed is
   --
   --  Initialize the lisp interpreter and install custom lisp commands
   --
   procedure init is
   begin
      init_discretes;
      init_i2c;
      BBS.lisp.add_builtin("mcp23017-dir", BBS.lisp.embed.mcp23017.mcp23017_dir'Access);
      BBS.lisp.add_builtin("mcp23017-polarity", BBS.lisp.embed.mcp23017.mcp23017_polarity'Access);
      BBS.lisp.add_builtin("mcp23017-pullup", BBS.lisp.embed.mcp23017.mcp23017_pullup'Access);
      BBS.lisp.add_builtin("mcp23017-read", BBS.lisp.embed.mcp23017.mcp23017_read'Access);
      BBS.lisp.add_builtin("mcp23017-set", BBS.lisp.embed.mcp23017.mcp23017_data'Access);
      BBS.lisp.add_builtin("pin-mode", BBS.lisp.embed.gpio.pin_mode'Access);
      BBS.lisp.add_builtin("pin-read", BBS.lisp.embed.gpio.read_pin'Access);
      BBS.lisp.add_builtin("pin-set", BBS.lisp.embed.gpio.set_pin'Access);
      BBS.lisp.add_builtin("stepper-delay", BBS.lisp.embed.stepper.stepper_delay'Access);
      BBS.lisp.add_builtin("stepper-init", BBS.lisp.embed.stepper.stepper_init'Access);
      BBS.lisp.add_builtin("stepper-off", BBS.lisp.embed.stepper.stepper_off'Access);
      BBS.lisp.add_builtin("stepper-step", BBS.lisp.embed.stepper.stepper_step'Access);
   end;
   --
   procedure init_discretes is
   begin
      gpio_name(4)  := BBS.embed.RPI.GPIO_4'Access;
      gpio_name(5)  := BBS.embed.RPI.GPIO_5'Access;
      gpio_name(6)  := BBS.embed.RPI.GPIO_6'Access;
      gpio_name(13) := BBS.embed.RPI.GPIO_13'Access;
      gpio_name(16) := BBS.embed.RPI.GPIO_16'Access;
      gpio_name(17) := BBS.embed.RPI.GPIO_17'Access;
      gpio_name(18) := BBS.embed.RPI.GPIO_18'Access;
      gpio_name(19) := BBS.embed.RPI.GPIO_19'Access;

      gpio_name(20) := BBS.embed.RPI.GPIO_20'Access;
      gpio_name(21) := BBS.embed.RPI.GPIO_21'Access;
      gpio_name(22) := BBS.embed.RPI.GPIO_22'Access;
      gpio_name(23) := BBS.embed.RPI.GPIO_23'Access;
      gpio_name(24) := BBS.embed.RPI.GPIO_24'Access;
      gpio_name(25) := BBS.embed.RPI.GPIO_25'Access;
      gpio_name(26) := BBS.embed.RPI.GPIO_26'Access;
      gpio_name(27) := BBS.embed.RPI.GPIO_27'Access;

      for index in gpio_name'Range loop
         if gpio_name(index) /= null then
            gpio_pin(index).configure(gpio_name(index).all, BBS.embed.GPIO.Linux.input);
         end if;
      end loop;
   end;
   --
   procedure init_i2c is
     err  : BBS.embed.i2c.err_code;
     temp : BBS.embed.uint8;
     addr : BBS.embed.addr7;
     i2c_bus : BBS.embed.i2c.i2c_interface := BBS.embed.i2c.i2c_interface(i2c_ptr);
   begin
      i2c.configure(BBS.embed.RPI.I2C_1);
      --
      --  Look for MCP23017 devices on the bus.
      --
      for i in mcp23017_found'range loop
         addr := BBS.embed.i2c.MCP23017.addr_0 + BBS.embed.addr7(i);
         temp := i2c_ptr.read(addr, BBS.embed.i2c.MCP23017.IOCON, err);
         if err = BBS.embed.i2c.NONE then
            MCP23017_info(i).configure(i2c_bus, addr, err);
            MCP23017_found(i) := True;
            put_line("MCP23017(" & Integer'Image(i) & ") Found at address " & Integer'image(Integer(addr)));
         else
            put_line("MCP23017(" & Integer'Image(i) & ") Not found at address " & Integer'image(Integer(addr))
                     & " - " & BBS.embed.i2c.err_code'Image(err));
            MCP23017_found(i) := False;
         end if;
      end loop;
   end;
   --
end BBS.lisp.embed;
