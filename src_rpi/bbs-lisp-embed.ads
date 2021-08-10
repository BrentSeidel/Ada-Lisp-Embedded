with BBS.embed.GPIO.Linux;
with BBS.embed.i2c.linux;
with BBS.embed.i2c.MCP23017;
package BBS.lisp.embed is

   procedure init;
   --
   --  Info for GPIO
   --
   type pin_name_ptr is access Constant String;
   gpio_max_pin : Natural := 27;
   gpio_pin : array (4 .. gpio_max_pin) of aliased BBS.embed.GPIO.Linux.Linux_GPIO_record;
   gpio_name : array (gpio_pin'Range) of pin_name_ptr := (others => null);
   --
   --  Info for I2C devices
   --
   MCP23017_found  : array (0 .. 7) of boolean;
   --
   MCP23017_info : array (0 .. 7) of aliased BBS.embed.i2c.MCP23017.MCP23017_record;

private
   --
   --  Private initialization routines
   --
   procedure init_discretes;
   procedure init_i2c;
   --
   --  Private data
   --
   --  I2C device record
   --
   i2c : aliased BBS.embed.i2c.linux.linux_i2c_interface_record;
   i2c_ptr : BBS.embed.i2c.linux.linux_i2c_interface := i2c'access;

end BBS.lisp.embed;
