with BBS.embed;
with BBS.embed.GPIO.Due;
with BBS.lisp;
use type BBS.lisp.value_type;
with BBS.lisp.evaluate;
package body BBS.lisp.embed.gpio is
   --
   --  Set the state of a digital pin  Two parameters are read.  The first
   --  parameter is the pin number (0 .. discretes.max_pin).  The second
   --  is the state (0 is low, 1 is high).
   --
   procedure set_pin(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      pin_elem : BBS.lisp.element_type;
      state_elem  : BBS.lisp.element_type;
      pin : Integer;
      state : Integer;
      rest : BBS.lisp.cons_index := s;
   begin
      --
      --  Get the first and second values
      --
      pin_elem := BBS.lisp.evaluate.first_value(rest);
      state_elem := BBS.lisp.evaluate.first_value(rest);
      --
      --  Check if the pin number value is an integer element.
      --
      if pin_elem.kind = BBS.lisp.V_INTEGER then
         pin := Integer(pin_elem.i);
      else
         BBS.lisp.error("set-pin", "Pin number must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if the pin state is an integer element.
      --
      if state_elem.kind = BBS.lisp.V_INTEGER then
         state := Integer(state_elem.i);
      else
         BBS.lisp.error("set-pin", "Pin state must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if the pin number is within range of the valid pins.  Note that
      --  pin 4 cannot be used.
      --
      if (pin < 0) or (pin > gpio_max_pin) or (pin = 4) then
         BBS.lisp.error("set-pin", "Pin number is out of range.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_RANGE);
         return;
      end if;
      --
      --  If everything is OK, then set the pin
      --
      if state = 0 then
         gpio_pin(pin).all.set(0);
      else
         gpio_pin(pin).all.set(1);
      end if;
      e := BBS.lisp.NIL_ELEM;
   end;
   --
   --  Set the state of a digital pin  Two parameters are read.  The first
   --  parameter is the pin number (0 .. discretes.max_pin).  The second
   --  is the state (0 is low, 1 is high).
   --
   procedure read_pin(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      param : BBS.lisp.element_type;
      pin : Integer;
      rest : BBS.lisp.cons_index := s;
      value : BBS.embed.Bit;
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
      --  Check if the pin number is within range of the valid pins.  Not that
      --  pin 4 cannot be used.
      --
         if (pin < 0) or (pin > gpio_max_pin) or (pin = 4) then
            BBS.lisp.error("read-pin", "Pin number is out of range.");
            e := BBS.lisp.make_error(BBS.lisp.ERR_RANGE);
            return;
         end if;
      else
         BBS.lisp.error("read-pin", "Parameter must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  If the parameter is an integer and in range, then read the pin and try
      --  to return the value.
      --
      value := gpio_pin(pin).all.get;
      e := (kind => BBS.lisp.V_INTEGER, i => BBS.lisp.int32(value));
   end;
   --
   --  Set the mode (input or output) of a digital pin.  Two parameters are read.
   --  The first parameter is the pin number (0 .. discretes.max_pin).  The
   --  second is the mode (0 is input, 1 is output).
   --
   procedure pin_mode(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      pin_elem : BBS.lisp.element_type;
      mode_elem  : BBS.lisp.element_type;
      pin : Integer;
      state : Integer;
      rest : BBS.lisp.cons_index := s;
   begin
      --
      --  Get the first value
      --
      pin_elem := BBS.lisp.evaluate.first_value(rest);
      --
      --  Get the second value
      --
      mode_elem := BBS.lisp.evaluate.first_value(rest);
      --
      --  Check if the pin number value is an integer element.
      --
      if pin_elem.kind = BBS.lisp.V_INTEGER then
         pin := Integer(pin_elem.i);
      else
         BBS.lisp.error("pin-mode", "Pin number must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if the pin state is an integer element.
      --
      if mode_elem.kind = BBS.lisp.V_INTEGER then
         state := Integer(mode_elem.i);
      else
         BBS.lisp.error("pin-mode", "Pin mode must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if the pin number is within range of the valid pins.  Not that
      --  pin 4 cannot be used.
      --
      if (pin < 0) or (pin > gpio_max_pin) or (pin = 4) then
         BBS.lisp.error("pin-mode", "Pin number is out of range.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_RANGE);
         return;
      end if;
      --
      --  If everything is OK, then set the pin
      --
      if state = 0 then
         gpio_pin(pin).all.config(BBS.embed.GPIO.Due.gpio_input);
      else
         gpio_pin(pin).all.config(BBS.embed.GPIO.Due.gpio_output);
      end if;
      e := BBS.lisp.NIL_ELEM;
   end;
   --
   --
   --  Enable or disable the pullup resistor of a digital pin.  Two parameters are read.
   --  The first parameter is the pin number (0 .. discretes.max_pin).  The
   --  second is the mode (NIL is disable, T is enable).
   --
   --  (pullup-pin integer boolean)
   --    The integer is the pin number range checked as above.
   --    The boolean enables or disables the pullup resistor for the specified pin.
   --
   procedure pin_pullup(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      pin_elem : BBS.lisp.element_type;
      pullup_elem  : BBS.lisp.element_type;
      pin : Integer;
      pullup : Boolean;
      rest : BBS.lisp.cons_index := s;
   begin
      --
      --  Get the first value
      --
      pin_elem := BBS.lisp.evaluate.first_value(rest);
      --
      --  Get the second value
      --
      pullup_elem := BBS.lisp.evaluate.first_value(rest);
      --
      --  Check if the pin number value is an integer element.
      --
      if pin_elem.kind = BBS.lisp.V_INTEGER then
         pin := Integer(pin_elem.i);
      else
         BBS.lisp.error("pin-pullup", "Pin number must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if the pin state is an integer element.
      --
      if pullup_elem.kind = BBS.lisp.V_BOOLEAN then
         pullup := pullup_elem.b;
      else
         BBS.lisp.error("pin-pullup", "Pin pullup must be boolean.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if the pin number is within range of the valid pins.  Not that
      --  pin 4 cannot be used.
      --
      if (pin < 0) or (pin > gpio_max_pin) or (pin = 4) then
         BBS.lisp.error("pin-pullup", "Pin number is out of range.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_RANGE);
         return;
      end if;
      --
      --  If everything is OK, then set the pullup resistor for the pin
      --
      if pullup then
         gpio_pin(pin).all.pullup(1);
      else
         gpio_pin(pin).all.pullup(0);
      end if;
      e := BBS.lisp.NIL_ELEM;
   end;
end;
