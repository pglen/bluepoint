#                             README
## The bluepoint algorythm

 This directory contains the bluepoint algorithm and test suite.

The hs_crypt() family of functions are block handling loops to iterate
over buffers in a consistent manner.

This is bluepoint version 2, and 3, see documentation on differences.
The bluepoint version 3, (the virtual machine version) is under development.
Version 3 might be quantum resistant;


Bluepoint 3 data flow:

    // Run through the pre-defined VM stack

    // Pre - do password vector modification
    // This modifies the algorythm so the pass is connected to the
    // virtual machine

    // Pre - do the regular encryption process
    // This section is run in case the modified virtual machine creates
    // a short circuit like pairs; with it, the scramble is always strong

        PASSLOOP(+)
        MIXIT2(+)       MIXIT2R(+)
        HECTOR(+)       FWLOOP(+)
        MIXIT2(+)       MIXIT2R(+)
        PASSLOOP(+)     FWLOOP(+)
        HECTOR(+)       FWLOOP(+)
        MIXIT(+)        MIXITR(+)
        BWLOOP(+)       HECTOR(+)

    // Done

    // Decryption is run in reverse
    //   Static
    //   Regular
    //   Pass vector

 Both processes start with a password obfuscation;

Sun 16.Oct.2022 updated bluepoint 3

// EOF
