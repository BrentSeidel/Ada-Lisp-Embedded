with BBS.lisp;
package BBS.lisp.embed.gpio is
   --
   --  Set the state of a digital pin  Two parameters are read.  The first
   --  parameter is the pin number (0 .. discretes.max_pin).  The second
   --  is the state (0 is low, 1 is high).
   --
   --  (pin-set integer integer)
   --    The first integer is the pin number and the second integer is the
   --    pin state.  The pin number is range checked to be between 0 and 53
   --    inclusive and not equal to 4.  The pin state is set to low for a
   --    value of 0 and high otherwise.  Returns NIL.
   --
   procedure set_pin(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --
   --  Reads the state of a digital pin  Two is the pin number
   --  (0 .. discretes.max_pin).  The return value is the state of the pin.
   --
   --  (pin-read integer)
   --    The parameter is the pin number.  Returns the state of the pin
   --    (0-low, 1-high).
   --
   procedure read_pin(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --
   --  Set the mode (input or output) of a digital pin.  Two parameters are read.
   --  The first parameter is the pin number (0 .. discretes.max_pin).  The
   --  second is the mode (0 is input, 1 is output).
   --
   --  (pin-mode integer integer)
   --    The integer is the pin number range checked as above.  The second is
   --    the mode (0 is input, 1 is output).
   --
   procedure pin_mode(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
end;
