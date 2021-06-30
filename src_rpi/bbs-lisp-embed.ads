with BBS.embed.GPIO.Linux;
with BBS.lisp;
package BBS.lisp.embed is

   procedure init;
   procedure init_discretes;
   --
   --  Info for GPIO
   --
   type pin_name_ptr is access Constant String;
   gpio_max_pin : Natural := 27;
   gpio_pin : array (4 .. gpio_max_pin) of aliased BBS.embed.GPIO.Linux.Linux_GPIO_record;
   gpio_name : array (gpio_pin'Range) of pin_name_ptr := (others => null);

end BBS.lisp.embed;
