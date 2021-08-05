with bbs.embed.i2c.due;
use type bbs.embed.i2c.err_code;
use type bbs.embed.i2c.due.port_id;
with BBS.embed.i2c.L3GD20H;
with BBS.lisp.conses;
with BBS.lisp.evaluate;
with BBS.lisp.memory;
package body BBS.lisp.embed.l3gd20 is
   --
   --  (l3gd20-read)
   --    returns a list of three items containing the x, y, and z
   --    rotations in integer values of degrees per second.
   --
   procedure read_l3gd20(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      pragma Unreferenced (s);
      err  : BBS.embed.i2c.err_code;
      flag : Boolean;
      rot  : BBS.embed.i2c.L3GD20H.rotations_dps;
      head : BBS.lisp.cons_index;
      t1   : BBS.lisp.cons_index;
      t2   : BBS.lisp.cons_index;
   begin
      --
      --  First check if the L3GD20 is present
      --
      if l3gd20_found = absent then
         BBS.lisp.error("read_l3gd20", "L3GD20 not configured in system");
         e := BBS.lisp.make_error(BBS.lisp.ERR_HARDWARE);
         return;
      end if;
      rot := L3GD20_info.get_rotations(err);
      if err /= BBS.embed.i2c.none then
         BBS.lisp.error("read_l3gd20", "Error occured reading from device " &
                 BBS.embed.i2c.err_code'Image(err));
         e := BBS.lisp.make_error(BBS.lisp.ERR_HARDWARE);
         return;
      end if;
      flag := BBS.lisp.conses.alloc(head);
      if not flag then
         BBS.lisp.error("read_l3gd20", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_ALLOCCONS);
         return;
      end if;
      BBS.lisp.conses.set_car(head, (kind => BBS.lisp.V_INTEGER, i =>
                                       BBS.lisp.int32(float(rot.x)*10.0)));
      flag := BBS.lisp.conses.alloc(t1);
      if not flag then
         BBS.lisp.conses.deref(head);
         BBS.lisp.error("read_l3gd20", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_ALLOCCONS);
         return;
      end if;
      BBS.lisp.conses.set_cdr(head, BBS.lisp.evaluate.makeList(t1));
      BBS.lisp.conses.set_car(t1, (kind => BBS.lisp.V_INTEGER, i =>
                                     BBS.lisp.int32(float(rot.y)*10.0)));
      flag := BBS.lisp.conses.alloc(t2);
      if not flag then
         BBS.lisp.conses.deref(head);
         BBS.lisp.error("read_l3gd20", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_ALLOCCONS);
         return;
      end if;
      BBS.lisp.conses.set_cdr(t1, BBS.lisp.evaluate.makeList(t2));
      BBS.lisp.conses.set_car(t2, (kind => BBS.lisp.V_INTEGER, i =>
                                     BBS.lisp.int32(float(rot.z)*10.0)));
      e := BBS.lisp.evaluate.makeList(head);
   end;
   --
end;
