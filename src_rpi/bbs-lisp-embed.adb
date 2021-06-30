with BBS.lisp;
use type BBS.lisp.ptr_type;
use type BBS.lisp.value_type;
with BBS.lisp.embed.GPIO;
with BBS.lisp.embed.stepper;
with BBS.lisp.evaluate;
with BBS.embed;
with BBS.embed.GPIO.Linux;
with BBS.embed.RPI;


package body BBS.lisp.embed is
   --
   --  Initialize the lisp interpreter and install custom lisp commands
   --
   --
   procedure init is
   begin
      BBS.lisp.add_builtin("pin-mode", BBS.lisp.embed.gpio.pin_mode'Access);
      BBS.lisp.add_builtin("pin-read", BBS.lisp.embed.gpio.read_pin'Access);
      BBS.lisp.add_builtin("pin-set", BBS.lisp.embed.gpio.set_pin'Access);
      BBS.lisp.add_builtin("stepper-delay", BBS.lisp.embed.stepper.stepper_delay'Access);
      BBS.lisp.add_builtin("stepper-init", BBS.lisp.embed.stepper.stepper_init'Access);
      BBS.lisp.add_builtin("stepper-off", BBS.lisp.embed.stepper.stepper_off'Access);
      BBS.lisp.add_builtin("stepper-step", BBS.lisp.embed.stepper.stepper_step'Access);
   end;
   --
   procedure init_discretes is
   begin
      gpio_name(4)  := BBS.embed.RPI.GPIO_4'Access;
      gpio_name(5)  := BBS.embed.RPI.GPIO_5'Access;
      gpio_name(6)  := BBS.embed.RPI.GPIO_6'Access;
      gpio_name(13) := BBS.embed.RPI.GPIO_13'Access;
      gpio_name(16) := BBS.embed.RPI.GPIO_16'Access;
      gpio_name(17) := BBS.embed.RPI.GPIO_17'Access;
      gpio_name(18) := BBS.embed.RPI.GPIO_18'Access;
      gpio_name(19) := BBS.embed.RPI.GPIO_19'Access;

      gpio_name(20) := BBS.embed.RPI.GPIO_20'Access;
      gpio_name(21) := BBS.embed.RPI.GPIO_21'Access;
      gpio_name(22) := BBS.embed.RPI.GPIO_22'Access;
      gpio_name(24) := BBS.embed.RPI.GPIO_24'Access;
      gpio_name(25) := BBS.embed.RPI.GPIO_25'Access;
      gpio_name(26) := BBS.embed.RPI.GPIO_26'Access;
      gpio_name(27) := BBS.embed.RPI.GPIO_27'Access;

      for index in gpio_name'Range loop
         if gpio_name(index) /= null then
            gpio_pin(index).configure(gpio_name(index).all, BBS.embed.GPIO.Linux.input);
         end if;
      end loop;
   end;
   --
end BBS.lisp.embed;
