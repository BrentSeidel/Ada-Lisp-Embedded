--
--  This package contains code for the lisp interpreter to run stepper motors.
--
with BBS.embed;
with BBS.embed.GPIO.tb6612;
with BBS.lisp;
package BBS.lisp.embed.stepper is

   --
   --  Data for stepper motors.  Each stepper motor is controlled by 4 digital
   --  I/O pins.  I currently have 4 controllers and motors, so I've set
   --  num_steppers to 4.  Change if you have more, or less.
   --
   num_steppers : constant Integer := 4;
   steppers : array (1 .. num_steppers) of BBS.embed.GPIO.tb6612.TB6612_record;
   --
   --  (stepper-init num a b c d)
   --    Initializes stepper controller num and sets the pin numbers for pins a,
   --    b, c, and d.  Phase is set to 1 and the pins are set appropriately.
   --
   procedure stepper_init(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --  (stepper-delay num delay)
   --    Set the delay between steps for the specified stepper to the specified
   --    number of milliseconds.  The default is 5mS.
   --
   procedure stepper_delay(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --  (step num amount)
   --    Moves the specified stepper motor the specified number of steps.
   --    Direction is indicated by the sign.  The actual direction depends on
   --    the wiring.
   --
   procedure stepper_step(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --  (stepper-off num)
   --    Turns the coils for the specified stepper off..
   --
   procedure stepper_off(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);

end;
