with BBS.lisp;
package BBS.lisp.embed.pca9685 is
   --
   --  (set-pca9685 integer integer)
   --    The first integer is the channel number (0-15).  The second integer is
   --    the PWM value to set (0-4095).  Sets the specified PCA9685 PWM channel
   --    to the specified value.  Returns NIL.
   --
   procedure set_pca9685(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
end;
