# Ada-Lisp-Embedded
Extensions to the Tiny Lisp language for embedded applications

Due to hardware differences, not all operations will be supported on all
platforms.  It is expected that the Arduino Due and the Raspberry PI will
be supported.  Select the appropriate .gpr file for your platform.
Platform specific code will be in its own subdirectory, while common
code will be in a common subdirectory.  Refer to the [documentation](../blob/main/doc/Lisp-Embedded.pdf) for
the operations added for each platform and how to embed each platform.

Currently supported targets are:
* Arduino Due
