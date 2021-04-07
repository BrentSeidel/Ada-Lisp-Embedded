package BBS.lisp.embed.mcp23017 is

   --
   --  Set direction of bits in the MCP23017 port.
   --  (mcp23017-dir addr dir)
   --    addr is the device address
   --    dir is the direction (0-read, 1-write) bit encoded into a 16 bit
   --      unsigned integer
   --
   procedure mcp23017_dir(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --  Enable/disable pull-up resistors for bits in the MCP23017 port.
   --  (mcp23017-pullup addr pull)
   --    addr is the device address
   --    dir is the pullup setting (0-disable, 1-enable) bit encoded into a 16 bit
   --      unsigned integer
   --
   procedure mcp23017_pullup(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --  Set polarity of bits in the MCP23017 port.
   --  (mcp23017-set-dir addr pol)
   --    addr is the device address
   --    pol is the polarity (0-normal, 1-inverted) bit encoded into a 16 bit
   --      unsigned integer
   --
   procedure mcp23017_polarity(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --  Set output data of bits in the MCP23017 port.
   --  (mcp23017-write addr data)
   --    addr is the device address
   --    data is the output value as a 16 bit unsigned integer
   --
   procedure mcp23017_data(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);
   --
   --  Read data from a MCP23017 port
   --  (mcp23017-read addr)
   --    addr is the device address
   --    returns the bits read as a 16 bit unsigned integer
   --
   procedure mcp23017_read(e : out BBS.lisp.element_type; s : BBS.lisp.cons_index);

end;
