with bbs.embed.i2c.due;
use type bbs.embed.i2c.err_code;
use type bbs.embed.i2c.due.port_id;
with BBS.embed.i2c.PCA9685;
with BBS.lisp;
use type BBS.lisp.ptr_type;
use type BBS.lisp.value_type;
with BBS.lisp.evaluate;
package body BBS.lisp.embed.pca9685 is
   --
   --  (set-pca9685 integer integer)
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
      ok : Boolean := True;
   begin
      --
      --  First check if the PCA9685 is present
      --
      if pca9685_found = absent then
         BBS.lisp.error("set-pca9685", "PCA9685 not configured in system");
         e := (kind => BBS.lisp.E_ERROR);
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
      if chan_elem.kind = BBS.lisp.E_VALUE then
         if chan_elem.v.kind = BBS.lisp.V_INTEGER then
            channel := Integer(chan_elem.v.i);
         else
            BBS.lisp.error("set-pca9685", "PCA9685 channel must be integer.");
            ok := False;
         end if;
      else
         BBS.lisp.error("set-pca9685", "PCA9685 channel must be an element.");
         BBS.lisp.print(chan_elem, False, True);
         ok := False;
      end if;
      --
      --  Check if the channel value is an integer atom.
      --
      if value_elem.kind = BBS.lisp.E_VALUE then
         if value_elem.v.kind = BBS.lisp.V_INTEGER then
            value := Integer(value_elem.v.i);
         else
            BBS.lisp.error("set-pca9685", "PCA9685 channel value must be integer.");
            ok := False;
         end if;
      else
         BBS.lisp.error("set-pca9685", "PCA9685 channel value must be an atom.");
         BBS.lisp.print(value_elem, False, True);
         ok := False;
      end if;
      --
      --  Check if the channel number is within range of the valid pins.
      --
      if (channel < 0) or (channel > 15) then
         BBS.lisp.error("set-pca9685", "PCA9685 channel number is out of range.");
         ok := False;
      end if;
      --
      --  Check that the cannel value is within the range 0-4095.
      --
      if (value < 0) or (value > 4095) then
         BBS.lisp.error("set-pca9685", "PCA9685 channel value is out of range.");
         ok := False;
      end if;
      --
      --  If everything is OK, then set the channel
      --
      if ok then
         PCA9685_info.set(BBS.embed.i2c.PCA9685.channel(channel), 0,
                         BBS.embed.uint12(value), err);
         if err /= BBS.embed.i2c.none then
            BBS.lisp.error("set-pca9685", "PCA9685 Error: " & BBS.embed.i2c.err_code'Image(err));
            e := (kind => BBS.lisp.E_ERROR);
            return;
         end if;
      else
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      e := BBS.lisp.NIL_ELEM;
   end;
   --
end;
