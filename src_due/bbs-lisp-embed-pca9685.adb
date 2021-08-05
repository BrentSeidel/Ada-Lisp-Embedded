with bbs.embed.i2c.due;
use type bbs.embed.i2c.err_code;
use type bbs.embed.i2c.due.port_id;
with BBS.embed.i2c.PCA9685;
with BBS.lisp.evaluate;
package body BBS.lisp.embed.pca9685 is
   --
   --  (pca9685-set integer integer)
   --    The first integer is the channel number (0-15).  The second integer is
   --    the PWM value to set (0-4095).  Sets the specified PCA9685 PWM channel
   --    to the specified value.  Returns NIL.
   --
   procedure set_pca9685(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      err    : BBS.embed.i2c.err_code;
      chan_elem : BBS.lisp.element_type;
      value_elem  : BBS.lisp.element_type;
      channel : Integer;
      value : Integer;
      rest : BBS.lisp.cons_index := s;
   begin
      --
      --  First check if the PCA9685 is present
      --
      if pca9685_found = absent then
         BBS.lisp.error("set-pca9685", "PCA9685 not configured in system");
         e := BBS.lisp.make_error(BBS.lisp.ERR_HARDWARE);
         return;
      end if;
      --
      --  Get the first value
      --
      chan_elem := BBS.lisp.evaluate.first_value(rest);
      --
      --  Get the second value
      --
      value_elem := BBS.lisp.evaluate.first_value(rest);
      --
      --  Check if the channel number value is an integer atom.
      --
      if chan_elem.kind = BBS.lisp.V_INTEGER then
         channel := Integer(chan_elem.i);
      else
         BBS.lisp.error("set-pca9685", "PCA9685 channel must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if the channel value is an integer atom.
      --
      if value_elem.kind = BBS.lisp.V_INTEGER then
         value := Integer(value_elem.i);
      else
         BBS.lisp.error("set-pca9685", "PCA9685 channel value must be integer.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_WRONGTYPE);
         return;
      end if;
      --
      --  Check if the channel number is within range of the valid pins.
      --
      if (channel < 0) or (channel > 15) then
         BBS.lisp.error("set-pca9685", "PCA9685 channel number is out of range.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_RANGE);
         return;
      end if;
      --
      --  Check that the cannel value is within the range 0-4095.
      --
      if (value < 0) or (value > 4095) then
         BBS.lisp.error("set-pca9685", "PCA9685 channel value is out of range.");
         e := BBS.lisp.make_error(BBS.lisp.ERR_RANGE);
         return;
      end if;
      --
      --  If everything is OK, then set the channel
      --
      PCA9685_info.set(BBS.embed.i2c.PCA9685.channel(channel), 0,
                       BBS.embed.uint12(value), err);
      if err /= BBS.embed.i2c.none then
         BBS.lisp.error("set-pca9685", "PCA9685 Error: " & BBS.embed.i2c.err_code'Image(err));
         e := BBS.lisp.make_error(BBS.lisp.ERR_HARDWARE);
         return;
      end if;
      e := BBS.lisp.NIL_ELEM;
   end;
   --
end;
