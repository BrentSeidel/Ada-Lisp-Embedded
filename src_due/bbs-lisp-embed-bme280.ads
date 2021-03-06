with BBS.lisp;
package BBS.lisp.embed.bme280 is
   --
   --  (bme280-read)
   --    Reads the sensors and returns a list of three items containing the
   --    temperature (C), pressure (Pa), and humidity (%), in that order.
   --
   procedure read_bme280(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   -- (bme280-read-raw)
   --    Reads the sensors and returns a list of three items containing the raw
   --    values for temperature, pressure, and humidity, in that order.
   --
   procedure read_bme280_raw(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
end;
