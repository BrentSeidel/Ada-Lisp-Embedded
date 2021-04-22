with BBS.lisp;
package BBS.lisp.embed.bmp180 is
   --
   --  (bmp180-read)
   --    Reads the ambient temperature in degrees C and atmospheric pressure  in
   --    Pascals from the BMP180 sensor.
   --
   procedure read_bmp180(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
end;
