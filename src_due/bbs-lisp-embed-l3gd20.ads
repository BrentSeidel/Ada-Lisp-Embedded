with BBS.lisp;
package BBS.lisp.embed.l3gd20 is
   --
   --  (l3gd20-read)
   --    Reads the gyroscope and returns a list of three items containing the
   --    x, y, and z rotations in integer values of degrees per second.
   --
   procedure read_l3gd20(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
end;
