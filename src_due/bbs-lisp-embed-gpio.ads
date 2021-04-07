with BBS.lisp;
package BBS.lisp.embed.gpio is
   --
   --  Set the state of a digital pin  Two parameters are read.  The first
   --  parameter is the pin number (0 .. discretes.max_pin).  The second
   --  is the state (0 is low, 1 is high).
   --
   --  (set-pin integer integer)
   --    The first integer is the pin number and the second integer is the
   --    pin state.  The pin number is range checked to be between 0 and 53
   --    inclusive and not equal to 4.  The pin state is set to low for a
   --    value of 0 and high otherwise.  Returns NIL.
   --
   procedure set_pin(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --
   --  Set the state of a digital pin  Two parameters are read.  The first
   --  parameter is the pin number (0 .. discretes.max_pin).  The second
   --  is the state (0 is low, 1 is high).
   --
   --  (pin-mode integer integer)
   --    The first integer is the pin number and the second integer is the mode
   --    to set for the pin.  The pin number is range checked as above.  Mode 0
   --    sets the pin to input mode while any other value sets the pin to output
   --    mode.  Returns NIL.
   --
   procedure read_pin(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --
   --  Set the mode (input or output) of a digital pin.  Two parameters are read.
   --  The first parameter is the pin number (0 .. discretes.max_pin).  The
   --  second is the mode (0 is input, 1 is output).
   --
   --  (mode integer integer)
   --    The integer is the pin number range checked as above.  The second is
   --    the mode (0 is input, 1 is output).
   --
   procedure pin_mode(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
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
   procedure pin_pullup(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
end;
