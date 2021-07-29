with BBS.units;
with BBS.embed.due.serial.int;
with BBS.embed.i2c.due;
use type bbs.embed.i2c.err_code;
use type bbs.embed.i2c.due.port_id;
with BBS.embed.i2c.BME280;
with BBS.lisp;
use type BBS.lisp.value_type;
with BBS.lisp.evaluate;
with BBS.lisp.memory;
package body BBS.lisp.embed.bme280 is
   --
   --  (bme280-read)
   --    returns a list of three items containing the x, y, and z
   --    rotations in integer values of degrees per second.
   --
   procedure read_bme280(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      pragma Unreferenced (s);
      std : constant BBS.embed.due.serial.int.serial_port := BBS.embed.due.serial.int.get_port(0);
      err  : BBS.embed.i2c.err_code;
      flag : Boolean;
      temp : BBS.units.temp_c;
      press : BBS.units.press_p;
      hum  : Integer;
      head : BBS.lisp.cons_index;
      t1   : BBS.lisp.cons_index;
      t2   : BBS.lisp.cons_index;
   begin
      --
      --  First check if the L3GD20 is present
      --
      if bme280_found = absent then
         BBS.lisp.error("read_bme280", "BME280 not configured in system");
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      --
      --  Then get values from the sensor
      --
      BME280_info.start_conversion(err);
      if err /= BBS.embed.i2c.none then
         BBS.lisp.error("read-bme280", "Error starting conversion: " & BBS.embed.i2c.err_code'Image(err));
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      loop
         flag := BME280_info.data_ready(err);
         exit when flag;
         exit when err /= BBS.embed.i2c.none;
      end loop;
      if err /= BBS.embed.i2c.none then
         BBS.lisp.error("read-bme280", "Error waiting for conversion: " & BBS.embed.i2c.err_code'Image(err));
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BME280_info.read_data(err);
      if err /= BBS.embed.i2c.none then
         BBS.lisp.error("read-bme280", "Error reading data: " & BBS.embed.i2c.err_code'Image(err));
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      temp := BME280_info.get_temp;
      std.put_line("BME280 Temperature " & Integer'Image(Integer(temp)));
      press := BME280_info.get_press;
      std.put_line("BME280 Pressure " & Integer'Image(Integer(press)));
      hum := BME280_info.get_hum;
      std.put_line("BME280 Humidity " & Integer'Image(Integer(Float(hum)/102.4)));
      flag := BBS.lisp.memory.alloc(head);
      if not flag then
         BBS.lisp.error("read_bme280", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BBS.lisp.cons_table(head).car := (kind => BBS.lisp.V_INTEGER, i =>
                                                BBS.lisp.int32(float(temp)*10.0));
      flag := BBS.lisp.memory.alloc(t1);
      if not flag then
         BBS.lisp.memory.deref(head);
         BBS.lisp.error("read_bme280", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BBS.lisp.cons_table(head).cdr := BBS.lisp.evaluate.makeList(t1);
      BBS.lisp.cons_table(t1).car := (kind => BBS.lisp.V_INTEGER, i =>
                                                BBS.lisp.int32(float(press)));
      flag := BBS.lisp.memory.alloc(t2);
      if not flag then
         BBS.lisp.memory.deref(head);
         BBS.lisp.error("read_bme280", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BBS.lisp.cons_table(t1).cdr := BBS.lisp.evaluate.makeList(t2);
      BBS.lisp.cons_table(t2).car := (kind => BBS.lisp.V_INTEGER, i =>
                                                BBS.lisp.int32(hum));
      e := BBS.lisp.evaluate.makeList(head);
   end;
   --
   -- (bme280-read-raw)
   --    Reads the sensors and returns a list of three items containing the raw
   --    values for temperature, pressure, and humidity, in that order.
   --
   procedure read_bme280_raw(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      pragma Unreferenced (s);
      std : constant BBS.embed.due.serial.int.serial_port := BBS.embed.due.serial.int.get_port(0);
      err  : BBS.embed.i2c.err_code;
      flag : Boolean;
      raw_temp : BBS.embed.uint32;
      raw_press : BBS.embed.uint32;
      raw_hum  : BBS.embed.uint32;
      head : BBS.lisp.cons_index;
      t1   : BBS.lisp.cons_index;
      t2   : BBS.lisp.cons_index;
   begin
      --
      --  First check if the L3GD20 is present
      --
      if bme280_found = absent then
         BBS.lisp.error("read_bme280-raw", "BME280 not configured in system");
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      --
      --  Then get values from the sensor
      --
      BME280_info.start_conversion(err);
      if err /= BBS.embed.i2c.none then
         BBS.lisp.error("read-bme280-raw", "Error starting conversion: " & BBS.embed.i2c.err_code'Image(err));
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      loop
         flag := BME280_info.data_ready(err);
         exit when flag;
         exit when err /= BBS.embed.i2c.none;
      end loop;
      if err /= BBS.embed.i2c.none then
         BBS.lisp.error("read-bme280-raw", "Error waiting for conversion: " & BBS.embed.i2c.err_code'Image(err));
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BME280_info.read_data(err);
      if err /= BBS.embed.i2c.none then
         BBS.lisp.error("read-bme280-raw", "Error reading data: " & BBS.embed.i2c.err_code'Image(err));
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BME280_info.get_raw(raw_temp, raw_press, raw_hum);
      std.put_line("BME280 Temperature " & Integer'Image(Integer(raw_temp)));
      std.put_line("BME280 Pressure " & Integer'Image(Integer(raw_press)));
      std.put_line("BME280 Humidity " & Integer'Image(Integer(raw_hum)));
      flag := BBS.lisp.memory.alloc(head);
      if not flag then
         BBS.lisp.error("read_bme280-raw", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BBS.lisp.cons_table(head).car := (kind => BBS.lisp.V_INTEGER, i =>
                                                BBS.lisp.int32(raw_temp));
      flag := BBS.lisp.memory.alloc(t1);
      if not flag then
         BBS.lisp.memory.deref(head);
         BBS.lisp.error("read_bme280-raw", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BBS.lisp.cons_table(head).cdr := BBS.lisp.evaluate.makeList(t1);
      BBS.lisp.cons_table(t1).car := (kind => BBS.lisp.V_INTEGER, i =>
                                                BBS.lisp.int32(raw_press));
      flag := BBS.lisp.memory.alloc(t2);
      if not flag then
         BBS.lisp.memory.deref(head);
         BBS.lisp.error("read_bme280-raw", "Unable to allocate cons for results");
         e := BBS.lisp.make_error(BBS.lisp.ERR_UNKNOWN);
         return;
      end if;
      BBS.lisp.cons_table(t1).cdr := BBS.lisp.evaluate.makeList(t2);
      BBS.lisp.cons_table(t2).car := (kind => BBS.lisp.V_INTEGER, i =>
                                                BBS.lisp.int32(raw_hum));
      e := BBS.lisp.evaluate.makeList(head);
   end;
   --
end;
