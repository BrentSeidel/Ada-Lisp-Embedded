with BBS.lisp;
use type BBS.lisp.ptr_type;
use type BBS.lisp.value_type;
use type BBS.lisp.int32;
with BBS.lisp.evaluate;
with BBS.embed;
with bbs.embed.i2c;
use type bbs.embed.i2c.err_code;
with BBS.embed.i2c.MCP23017;
package body BBS.lisp.embed.mcp23017 is
   --
   --  Some helper functions.
   --
   --  Process the address parameter.
   --
   function process_address(p : BBS.lisp.element_type; device : out BBS.embed.i2c.MCP23017.MCP23017_record)
                            return Boolean is
      addr : BBS.lisp.int32;
   begin
      device := MCP23017_0_info;
      if p.kind = BBS.lisp.E_VALUE then
         if p.v.kind = BBS.lisp.V_INTEGER then
            addr := p.v.i;
            if (addr = 0) and (mcp23017_0_found /= absent) then
               device := MCP23017_0_info;
               return True;
            elsif (addr = 2) and (mcp23017_2_found /= absent) then
               device := MCP23017_2_info;
               return True;
            elsif (addr = 6) and (mcp23017_6_found /= absent) then
               device := MCP23017_6_info;
               return True;
            else
               BBS.lisp.error("process_address", "Address must be 0, 2, or 6.");
            end if;
         else
            BBS.lisp.error("process_address", "Address must be integer.");
         end if;
      else
         BBS.lisp.error("process_address", "Address must be an element.");
         BBS.lisp.print(p, False, True);
      end if;
      return False;
   end;
   --
   --  Process the data parameter.  This should always be a 16 bit unsigned integer
   --
   function process_data(p : BBS.lisp.element_type; data : out BBS.embed.uint16)
                         return Boolean is
   begin
      data := 0;
      if p.kind = BBS.lisp.E_VALUE then
         if p.v.kind = BBS.lisp.V_INTEGER then
            if p.v.i >= 0 and p.v.i <= 16#FFFF# then
               data := BBS.embed.uint16(p.v.i);
               return True;
            else
               BBS.lisp.error("process_data", "Data must be in range 0-#xFFFF.");
            end if;
         else
            BBS.lisp.error("process_data", "Data must be integer.");
         end if;
      else
         BBS.lisp.error("process_data", "Data must be an element.");
         BBS.lisp.print(p, False, True);
      end if;
      return False;
   end;

   --
   --  Set direction of bits in the MCP23017 port.
   --  (mcp23017-set-dir addr dir)
   --    addr is the device address
   --    dir is the direction (0-read, 1-write) bit encoded into a 16 bit
   --      unsigned integer
   --
   procedure mcp23017_dir(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index)is
      rest : BBS.lisp.cons_index := s;
      param : BBS.lisp.element_type;
      data : BBS.embed.uint16;
      MCP23017 : aliased BBS.embed.i2c.MCP23017.MCP23017_record;
      err    : BBS.embed.i2c.err_code;
   begin
      --
      --  Process the first parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_address(param, MCP23017) then
         BBS.lisp.error("mcp23017-dir", "Error occured processing address parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      --
      --  Process the second parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_data(param, data) then
         BBS.lisp.error("mcp23017-dir", "Error processing data parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      --
      --  Both parameters are valid and in range.  Perform the function
      --
      MCP23017.set_dir(data, err);
      if err = BBS.embed.i2c.none then
         e := (kind => BBS.lisp.E_VALUE, v => (kind => BBS.lisp.V_INTEGER,
                                               i => BBS.lisp.int32(data)));
         return;
      end if;
      BBS.lisp.error("mcp23017-dir", "Error setting direction: " &
                       BBS.embed.i2c.err_code'Image(err));
      e := (kind => BBS.lisp.E_ERROR);
   end;
   --
   --  Enable/disable pull-up resistors for bits in the MCP23017 port.
   --  (mcp23017-pullup addr pull)
   --    addr is the device address
   --    dir is the pullup setting (0-disable, 1-enable) bit encoded into a 16 bit
   --      unsigned integer
   --
--   function mcp23017_pullup(s : BBS.lisp.cons_index) return BBS.lisp.element_type is
   procedure mcp23017_pullup(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      rest : BBS.lisp.cons_index := s;
      param : BBS.lisp.element_type;
      data : BBS.embed.uint16;
      MCP23017 : aliased BBS.embed.i2c.MCP23017.MCP23017_record;
      err    : BBS.embed.i2c.err_code;
   begin
      --
      --  Process the first parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_address(param, MCP23017) then
         BBS.lisp.error("mcp23017-pullup", "Error occured processing address parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      --
      --  Process the second parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_data(param, data) then
         BBS.lisp.error("mcp23017-pullup", "Error processing data parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      --
      --  Both parameters are valid and in range.  Perform the function
      --
      MCP23017.set_pullup(data, err);
      if err = BBS.embed.i2c.none then
         e := (kind => BBS.lisp.E_VALUE, v => (kind => BBS.lisp.V_INTEGER,
                                               i => BBS.lisp.int32(data)));
         return;
      end if;
      BBS.lisp.error("mcp23017-pullup", "Error setting pullup: " &
                       BBS.embed.i2c.err_code'Image(err));
      e := (kind => BBS.lisp.E_ERROR);
   end;
   --
   --  Set polarity of bits in the MCP23017 port.
   --  (mcp23017-set-dir addr pol)
   --    addr is the device address
   --    pol is the polarity (0-normal, 1-inverted) bit encoded into a 16 bit
   --      unsigned integer
   --
   procedure mcp23017_polarity(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      rest : BBS.lisp.cons_index := s;
      param : BBS.lisp.element_type;
      data : BBS.embed.uint16;
      MCP23017 : aliased BBS.embed.i2c.MCP23017.MCP23017_record;
      err    : BBS.embed.i2c.err_code;
   begin
      --
      --  Process the first parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_address(param, MCP23017) then
         BBS.lisp.error("mcp23017-polarity", "Error occured processing address parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      --
      --  Process the second parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_data(param, data) then
         BBS.lisp.error("mcp23017-polarity", "Error processing data parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      --
      --  Both parameters are valid and in range.  Perform the function
      --
      MCP23017.set_polarity(data, err);
      if err = BBS.embed.i2c.none then
         e := (kind => BBS.lisp.E_VALUE, v => (kind => BBS.lisp.V_INTEGER,
                                               i => BBS.lisp.int32(data)));
         return;
      end if;
      BBS.lisp.error("mcp23017-polarity", "Error setting polarity: " &
                       BBS.embed.i2c.err_code'Image(err));
      e := (kind => BBS.lisp.E_ERROR);
   end;
   --
   --  Set output data of bits in the MCP23017 port.
   --  (mcp23017-write addr data)
   --    addr is the device address
   --    data is the output value as a 16 bit unsigned integer
   --
--   function mcp23017_data(s : BBS.lisp.cons_index) return BBS.lisp.element_type is
   procedure mcp23017_data(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      rest : BBS.lisp.cons_index := s;
      param : BBS.lisp.element_type;
      data : BBS.embed.uint16;
      MCP23017 : aliased BBS.embed.i2c.MCP23017.MCP23017_record;
      err    : BBS.embed.i2c.err_code;
   begin
      --
      --  Process the first parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_address(param, MCP23017) then
         BBS.lisp.error("mcp23017-data", "Error occured processing address parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      --
      --  Process the second parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_data(param, data) then
         BBS.lisp.error("mcp23017-data", "Error processing data parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      --
      --  Both parameters are valid and in range.  Perform the function
      --
      MCP23017.set_data(data, err);
      if err = BBS.embed.i2c.none then
         e := (kind => BBS.lisp.E_VALUE, v => (kind => BBS.lisp.V_INTEGER,
                                               i => BBS.lisp.int32(data)));
         return;
      end if;
      BBS.lisp.error("mcp23017-data", "Error setting data: " &
                       BBS.embed.i2c.err_code'Image(err));
      e := (kind => BBS.lisp.E_ERROR);
   end;
   --
   --  Read data from a MCP23017 port
   --  (mcp23017-read addr)
   --    addr is the device address
   --    returns the bits read as a 16 bit unsigned integer
   --
   procedure mcp23017_read(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index) is
      rest : BBS.lisp.cons_index := s;
      param : BBS.lisp.element_type;
      data : BBS.embed.uint16;
      MCP23017 : aliased BBS.embed.i2c.MCP23017.MCP23017_record;
      err    : BBS.embed.i2c.err_code;
   begin
      --
      --  Process the first parameter.
      --
      param := BBS.lisp.evaluate.first_value(rest);
      if not process_address(param, MCP23017) then
         BBS.lisp.error("mcp23017-data", "Error occured processing address parameter");
         e := (kind => BBS.lisp.E_ERROR);
         return;
      end if;
      data := mcp23017.get_data(err);
      if err = BBS.embed.i2c.none then
         e := (kind => BBS.lisp.E_VALUE, v => (kind => BBS.lisp.V_INTEGER,
                                               i => BBS.lisp.int32(data)));
         return;
      end if;
      BBS.lisp.error("mcp23017-read", "Error getting data: " &
                       BBS.embed.i2c.err_code'Image(err));
      e := (kind => BBS.lisp.E_ERROR);
   end;
end;