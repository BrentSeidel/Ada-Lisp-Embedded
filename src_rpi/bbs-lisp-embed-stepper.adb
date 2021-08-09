with Ada.Real_Time;
use type Ada.Real_Time.Time;
with BBS.embed.GPIO.Due;
with BBS.lisp.evaluate;
package body BBS.lisp.embed.stepper is
   --
   --  (stepper-init num a b c d)
   --    Initializes stepper controller num and sets the pin numbers for pins a,
   --    b, c, and d.  Phase is set to 1 and the pins are set appropriately.
   --
   procedure stepper_init(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      rest : cons_index := s;
      pin_elem : element_type;
      stepper_elem  : element_type;
      stepper : Integer;
      pin_a : Integer;
      pin_b : Integer;
      pin_c : Integer;
      pin_d : Integer;
   begin
      --
      --  Check if the stepper number value is an integer element.
      --
      stepper_elem := BBS.lisp.evaluate.first_value(rest);
      if stepper_elem.kind = V_INTEGER then
         stepper := Integer(stepper_elem.i);
      else
         error("stepper-init", "Stepper number must be integer.");
         e := make_error(ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if pin a is an integer element.
      --
      pin_elem := BBS.lisp.evaluate.first_value(rest);
      if pin_elem.kind = V_INTEGER then
         pin_a := Integer(pin_elem.i);
      else
         error("stepper-init", "Pin-a number must be integer.");
         e := make_error(ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if pin b is an integer element.
      --
      pin_elem := BBS.lisp.evaluate.first_value(rest);
      if pin_elem.kind = V_INTEGER then
         pin_b := Integer(pin_elem.i);
      else
         error("stepper-init", "Pin-b number must be integer.");
         e := make_error(ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if pin c is an integer element.
      --
      pin_elem := BBS.lisp.evaluate.first_value(rest);
      if pin_elem.kind = V_INTEGER then
         pin_c := Integer(pin_elem.i);
      else
         error("stepper-init", "Pin-c number must be integer.");
         e := make_error(ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if pin d is an integer element.
      --
      pin_elem := BBS.lisp.evaluate.first_value(rest);
      if pin_elem.kind = V_INTEGER then
         pin_d := Integer(pin_elem.i);
      else
         error("stepper-init", "Pin-d number must be integer.");
         e := make_error(ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Now range check the values
      --
      if stepper < 1 or stepper > num_steppers then
         error("stepper-init", "Stepper number out of range.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      --
      --  Check if pin numbers are within range of the valid pins.  Note that
      --  pin 4 cannot be used.
      --
      if ((pin_a < 0) or (pin_a > gpio_max_pin)) or else (gpio_name(pin_a) = null) then
         error("stepper-init", "Pin-a is out of range.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      if (pin_b < 0) or (pin_b > gpio_max_pin) then
         error("stepper-init", "Pin-b is out of range.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      if (pin_c < 0) or (pin_c > gpio_max_pin) then
         error("stepper-init", "Pin-c is out of range.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      if (pin_d < 0) or (pin_d > gpio_max_pin) then
         error("stepper-init", "Pin-d is out of range.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      --
      --  If everything is OK, then setup the stepper
      --
      gpio_pin(pin_a).set_dir(gpio_name(pin_a).all, BBS.embed.GPIO.Linux.output);
      gpio_pin(pin_b).set_dir(gpio_name(pin_b).all, BBS.embed.GPIO.Linux.output);
      gpio_pin(pin_c).set_dir(gpio_name(pin_c).all, BBS.embed.GPIO.Linux.output);
      gpio_pin(pin_d).set_dir(gpio_name(pin_d).all, BBS.embed.GPIO.Linux.output);
      steppers(stepper).init(gpio_pin(pin_a)'Access,
                             gpio_pin(pin_b)'Access,
                             gpio_pin(pin_c)'Access,
                             gpio_pin(pin_d)'Access);
      e := NIL_ELEM;
   end;
   --
   --  (stepper-delay num delay)
   --    Set the delay between steps for the specified stepper to the specified
   --    number of milliseconds.  The default is 5mS.
   --
   procedure stepper_delay(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      rest : cons_index := s;
      delay_elem : element_type;
      stepper_elem  : element_type;
      stepper : Integer;
      delay_time : Integer;
   begin
      --
      --  Check if the stepper number value is an integer element.
      --
      stepper_elem := BBS.lisp.evaluate.first_value(rest);
      if stepper_elem.kind = V_INTEGER then
         stepper := Integer(stepper_elem.i);
      else
         error("stepper-delay", "Stepper number must be integer.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      --
      --  Check if delay time is an integer element.
      --
      delay_elem := BBS.lisp.evaluate.first_value(rest);
         if delay_elem.kind = V_INTEGER then
            delay_time := Integer(delay_elem.i);
         else
            error("stepper-delay", "Delay time must be integer.");
         end if;
      if delay_time < 0 then
         BBS.lisp.error("stepper-delay", "Delay time must be zero or greater.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      steppers(stepper).set_delay(delay_time);
      e := NIL_ELEM;
   end;

   --
   --  (stepper-step num amount)
   --    Moves the specified stepper motor the specified number of steps.
   --    Direction is indicated by the sign.  The actual direction depends on
   --    the wiring.
   --
   procedure stepper_step(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      rest : cons_index := s;
      amount_elem : element_type;
      stepper_elem  : element_type;
      stepper : Integer;
      amount : Integer;
   begin
      --
      --  Check if the stepper number value is an integer element.
      --
      stepper_elem := BBS.lisp.evaluate.first_value(rest);
      if stepper_elem.kind = V_INTEGER then
         stepper := Integer(stepper_elem.i);
      else
         BBS.lisp.error("step", "Stepper number must be integer.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      --
      --  Check if step amount is an integer element.
      --
      amount_elem := BBS.lisp.evaluate.first_value(rest);
      if amount_elem.kind = V_INTEGER then
         amount := Integer(amount_elem.i);
      else
         BBS.lisp.error("step", "Amount must be integer.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      --
      --  Check for stepping one way or the other.  Zero steps does nothing.
      --
      BBS.lisp.msg("Step", "Stepping stepper " & Integer'Image(stepper) &
                     " by " & Integer'Image(amount) & " steps.");
      steppers(stepper).step(amount);
      e := NIL_ELEM;
   end;
   --
   --  (stepper-off num)
   --    Turns the coils for the specified stepper off..
   --
   procedure stepper_off(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      rest : cons_index := s;
      stepper_elem  : element_type;
      stepper : Integer;
   begin
      --
      --  Check if the stepper number value is an integer element.
      --
      stepper_elem := BBS.lisp.evaluate.first_value(rest);
      if stepper_elem.kind = BBS.lisp.V_INTEGER then
         stepper := Integer(stepper_elem.i);
      else
         BBS.lisp.error("step", "Stepper number must be integer.");
         e := make_error(ERR_RANGE);
         return;
      end if;
      steppers(stepper).stepper_off;
      e := NIL_ELEM;
   end;
   --
end;
