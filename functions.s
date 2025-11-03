/**************************************************************************
 * C S 429 Assembly Coding Lab
 *
 * functions.s - Template for all functions to be implemented.
 *
 * Copyright (c) 2022, 2023, 2024, 2025
 * Authors: Kavya Rathod, Prithvi Jamadagni, Anoop Rachakonda, Zeeshan Ahmad
 * All rights reserved.
 * May not be used, modified, or copied without permission.
 **************************************************************************/

 /*
 ** Beatrice Olaosebikan BTO334
 */
    
    .arch armv8-a
	.file	"functions.c"
	.text


// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global bit_rotate_l
    .type   bit_rotate_l, %function
bit_rotate_l:
    // (STUDENT TODO) Code for bit_rotate_l goes here.
    // Input parameter n is passed in X0; input parameter shift is passed in X1.
    // Output value is returned in X0.
    LSL     X2, X0, X1           // X2 = n << shift
    MOVZ    X3, #64
    SUBS     X3, X3, X1            // X3 = 64 - shift
    LSR     X3, X0, X3           // X3 = n >> (64 - shift)
    ORR     X0, X2, X3           // X0 = (n << shift) | (n >> (64 - shift))
    

    ret
    .size   bit_rotate_l, .-bit_rotate_l
    // ... and ends with the .size above this line.


// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global bit_rotate_r
    .type   bit_rotate_r, %function
bit_rotate_r:
    // (STUDENT TODO) Code for bit_rotate_r goes here.
    // Input parameter n is passed in X0; input parameter shift is passed in X1.
    // Output value is returned in X0.
    LSR     X2, X0, X1           // X2 = n >> shift
    MOVZ    X3, #64
    SUBS     X3, X3, X1            // X3 = 64 - shift
    LSL     X3, X0, X3           // X3 = n << (64 - shift)
    ORR     X0, X2, X3           // X0 = (n >> shift) | (n << (64 - shift))

    ret
    .size   bit_rotate_r, .-bit_rotate_r
    // ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
	.align	2
	.global	UTF8_to_unicode
	.type	UTF8_to_unicode, %function
UTF8_to_unicode:
    // (STUDENT TODO) Code for UTF8_to_unicode goes here.
    // Input parameter utf8 is passed in X0
    // Output value is returned in X0


            LDUR X1, [X0, #0]        // load first byte
            UBFM X1, X1, #0, #7      // isolate lowest 8 bits

                // Masks for first byte

                MOVZ X2, #0x80            // check 1-byte
                MOVZ X3, #0xE0            // check 2-byte
                MOVZ X4, #0xF0            // check 3-byte
                MOVZ X5, #0xF8            // check 4-byte

                // Masks for comparisons
                MOVZ X9,  #0xC0            // 110xxxxx
                MOVZ X10, #0xE0            // 1110xxxx
                MOVZ X11, #0xF0            // 11110xxx

                // Mask for continuation bytes
                MOVZ X12, #0x3F            // 0b00111111

                // 1-byte ASCII
                ANDS X6, X1, X2
                B.EQ utf8_one_byte

                // 2-byte
                ANDS X6, X1, X3
                CMP X6, X9
                B.EQ utf8_two_byte

                // 3-byte
                ANDS X6, X1, X4
                CMP X6, X10
                B.EQ utf8_three_byte

                // 4-byte
            utf8_four_byte:
                LDUR X6, [X0, #1]
                UBFM X6, X6, #0, #7
                LDUR X7, [X0, #2]
                UBFM X7, X7, #0, #7
                LDUR X8, [X0, #3]
                UBFM X8, X8, #0, #7

                UBFM X1, X1, #0, #2         // mask first byte (0x07)
                LSL  X1, X1, #18

                ANDS X6, X6, X12            // continuation mask
                LSL  X6, X6, #12
                ORR  X1, X1, X6

                ANDS X7, X7, X12
                LSL  X7, X7, #6
                ORR  X1, X1, X7

                ANDS X8, X8, X12
                ORR  X0, X1, X8
                RET

            utf8_three_byte:
                LDUR X6, [X0, #1]
                UBFM X6, X6, #0, #7
                LDUR X7, [X0, #2]
                UBFM X7, X7, #0, #7

                UBFM X1, X1, #0, #3         // first byte mask (0x0F)
                LSL  X1, X1, #12

                ANDS X6, X6, X12
                LSL  X6, X6, #6
                ORR  X1, X1, X6

                ANDS X7, X7, X12
                ORR  X0, X1, X7
                RET

            utf8_two_byte:
                LDUR X6, [X0, #1]
                UBFM X6, X6, #0, #7

                UBFM X1, X1, #0, #4         // first byte mask (0x1F)
                LSL  X1, X1, #6

                ANDS X6, X6, X12
                ORR  X0, X1, X6
                RET

            utf8_one_byte:
                ORR X0, X1, XZR
                RET
            .size	UTF8_to_unicode, .-UTF8_to_unicode
            // ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
    .align	2
    .global	unicode_to_UTF8
    .type	unicode_to_UTF8, %function
unicode_to_UTF8:
    // (STUDENT TODO) Code for unicode_to_UTF8 goes here.
    // Input parameter a is passed in X0; input parameter utf8 is passed in X1
    // There are no output values
    
        MOVZ X2, #0x10, LSL #16
    MOVK X2, #0xFFFF
    CMP  X0, X2
    B.GT invalid_codepoint

       // 1-byte check (< 0x80)  
    MOVZ X3, #0x80
    CMP  X0, X3
    B.LT one_byte

       // 2-byte check (< 0x800)  
    MOVZ X3, #0x800
    CMP  X0, X3
    B.LT two_bytes

       // 3-byte check (< 0x10000)  
    MOVZ X3, #0x1, LSL #16
    CMP  X0, X3
    B.LT three_bytes

    // else, 4-byte
    B four_bytes

      // 1-byte    
one_byte:
    MOVZ X3, #0x7F
    ANDS X4, X0, X3
    STUR X4, [X1, #0]
    RET

      // 2-byte    
two_bytes:
    MOVZ X5, #0x3F
    ANDS X4, X0, X5        // second byte mask
    MOVZ X5, #0x80
    ORR  X4, X4, X5        // second byte = masked | 0x80

    LSR  X3, X0, #6
    MOVZ X5, #0xC0
    ORR  X3, X3, X5        // first byte = (X0>>6) | 0xC0

    LSL  X4, X4, #8
    ORR  X3, X3, X4
    STUR X3, [X1, #0]
    RET

      // 3-byte    
three_bytes:
    MOVZ X7, #0x3F
    ANDS X6, X0, X7        // third byte
    ADD  X6, X6, #0x80
    LSR  X5, X0, #6
    ANDS X5, X5, X7        // second byte
    ADD  X5, X5, #0x80
    LSR  X4, X0, #12
    ADD  X4, X4, #0xE0      // first byte
    LSL  X5, X5, #8
    LSL  X6, X6, #16
    ORR  X4, X4, X5
    ORR  X4, X4, X6
    STUR X4, [X1, #0]
    RET

   // 4-byte  
four_bytes:
    MOVZ X8, #0x3F
    ANDS X7, X0, X8        // fourth byte
    ADD  X7, X7, #0x80
    LSR  X6, X0, #6
    ANDS X6, X6, X8        // third byte
    ADD  X6, X6, #0x80
    LSR  X5, X0, #12
    ANDS X5, X5, X8        // second byte
    ADD  X5, X5, #0x80
    LSR  X4, X0, #18
    ADD  X4, X4, #0xF0      // first byte
    LSL  X5, X5, #8
    LSL  X6, X6, #16
    LSL  X7, X7, #24
    ORR  X4, X4, X5
    ORR  X4, X4, X6
    ORR  X4, X4, X7
    STUR X4, [X1, #0]
    RET

   // Invalid    
invalid_codepoint:
    MOVZ X3, #0xFFFF
    LSL  X3, X3, #16
    MOVK X3, #0xFFFF
    STUR X3, [X1, #0]
    RET


	.size	unicode_to_UTF8, .-unicode_to_UTF8
	// ... ANDS ends with the .size above this line.

// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global compare
    .type   compare, %function
compare:
    // (STUDENT TODO) Code for compare goes here.
    // Input parameter a is passed in X0; input parameter b is passed in X1.
    // Output value is returned in X0.


            // Field 1: unique_id (unsigned long at offset 0)   
        LDUR    X2, [X0, #0]      // load a->unique_id
        LDUR    X3, [X1, #0]      // load b->unique_id
        CMP     X2, X3
        B.NE    compare_not_equal

        // Prepare mask for 1-byte comparisons
        MOVZ    X4, #0xFF

        // Field 2: seat_code[3] at offsets 8,9,10   
        LDUR    X2, [X0, #8]
        ANDS    X2, X2, X4
        LDUR    X3, [X1, #8]
        ANDS    X3, X3, X4
        CMP     X2, X3
        B.NE    compare_not_equal

        LDUR    X2, [X0, #9]
        ANDS    X2, X2, X4
        LDUR    X3, [X1, #9]
        ANDS    X3, X3, X4
        CMP     X2, X3
        B.NE    compare_not_equal

        LDUR    X2, [X0, #10]
        ANDS    X2, X2, X4
        LDUR    X3, [X1, #10]
        ANDS    X3, X3, X4
        CMP     X2, X3
        B.NE    compare_not_equal

        // Field 3: price (double at offset 16)
        LDUR    X2, [X0, #16]     // load 8 bytes from a
        LDUR    X3, [X1, #16]     // load 8 bytes from b
        CMP     X2, X3
        B.NE    compare_not_equal

        // Field 4: special_admission (bool at offset 24)
        LDUR    X2, [X0, #24]
        ANDS    X2, X2, X4
        LDUR    X3, [X1, #24]
        ANDS    X3, X3, X4
        CMP     X2, X3
        B.NE    compare_not_equal

        // Field 5: recommendations (pointer at offset 32)
        LDUR    X2, [X0, #32]
        LDUR    X3, [X1, #32]
        CMP     X2, X3
        B.NE    compare_not_equal

        // Field 6: refundable (bool at offset 40)
        LDUR    X2, [X0, #40]
        ANDS    X2, X2, X4
        LDUR    X3, [X1, #40]
        ANDS    X3, X3, X4
        CMP     X2, X3
        B.NE    compare_not_equal

        // All fields equal
        MOVZ    X0, #0
        RET

        compare_not_equal:
            MOVZ    X0, #1
            RET

    .size   compare, .-compare
    // ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
	.align	2
	.global	tree_depth
	.type	tree_depth, %function
tree_depth:
    // (STUDENT TODO) Code for tree_depth goes here.
    // Input parameter root is passed in X0.
    // Output value is returned in X0.
     // if root == NULL, return 0

        // if (root == NULL) return 0
    CMP X0, XZR
    B.EQ base_case

          // make a stack frame    
    SUB SP, SP, #32
    STUR X30, [SP, #16]      // save return address
    STUR X0, [SP, #8]        // save root pointer

          // compute left depth    
    LDUR X0, [SP, #8]        // reload root
    LDUR X0, [X0, #0]         // load left pointer
    BL tree_depth
    STUR X0, [SP, #0]        // store left depth at [SP,#0]

          // compute right depth    
    LDUR X0, [SP, #8]        // reload root
    LDUR X0, [X0, #8]         // load right pointer
    BL tree_depth
    LDUR X2, [SP, #0]        // X2 = left depth
    ADD X3, X0, #0          // X3 = right depth

       // choose max(left,right)  
    CMP X2, X3
    B.GE left_greater
    ADD X0, X3, #1            // X0 = right_depth + 1
    B end

left_greater:
    ADD X0, X2, #1            // X0 = left_depth + 1

end:
    LDUR X30, [SP, #16]      // restore LR
    ADD SP, SP, #32         // pop frame
    RET

base_case:
    MOVZ X0, #0
    RET
	.size	tree_depth, .-tree_depth
	// ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
	.align	2
	.global	change_case
	.type	change_case, %function
change_case:
    // (STUDENT TODO) Code for change_case goes here.
    // Input parameter str is passed in X0; input parameter flag is passed in X1.
    // There is no output value. Parameter str will be mutated.

change_case:
    // X0 = str, X1 = flag
    // We'll use X2–X9 as temporaries

loop:
    LDUR X2, [X0, #0]             // Load 8 bytes
    MOVZ X3, #0                   // Byte index = 0

byte_loop:
    // Extract one byte: X4 = (X2 >> (X3*8)) & 0xFF
    LSL X5, X3, #3                // shift = index * 8
    LSR X4, X2, X5
    MOVZ X8, 0XFF
    ANDS X4, X4, X8           // keep lowest byte
    CMP X4, XZR                  // check for null
    B.EQ done                     // end if '\0'

    // flag == 0 ? lowercase : uppercase
    CMP X1, XZR
    B.EQ to_lower

//  to UPPER   
    MOVZ X8, #'a'
    CMP X4, X8                // if below 'a' skip
    B.LT skip
    MOVZ X8, #'z'
    CMP X4, X8
    B.GT skip
    SUB X4, X4, #0x20             // convert to uppercase
    B insert

   //  to LOWER   
to_lower:
    MOVZ X8, #'A'
    CMP X4, X8
    B.LT skip
    MOVZ X8, #'Z'
    CMP X4, x8
    B.GT skip
    ADD X4, X4, #0x20             // convert to lowercase

   //  insert   
insert:
    // Clear target byte from X2 and reinsert new value
    MOVZ X6, #0xFF
    LSL X6, X6, X5                // X6 = mask << shift
    MVN X6, X6                    // invert mask (clear target byte)
    ANDS X2, X2, X6               // clear that byte
    LSL X7, X4, X5                // place byte in position
    ORR X2, X2, X7                // insert it

skip:
    ADD X3, X3, #1                // next byte index
    MOVZ X8, #8
    CMP X3, X8
    B.LT byte_loop

    STUR X2, [X0, #0]             // store modified 8 bytes
    ADD X0, X0, #8                // move pointer
    B loop                        // continue

done:
    STUR X2, [X0, #0]             // store partial block (safe)
    RET

	.size	change_case, .-change_case
	// ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global ustrncmp
    .type   ustrncmp, %function
ustrncmp:
    // (STUDENT TODO) Code for ustrncmp goes here.
    // Input parameter str1 is passed in X0; Input parameter str2 is passed in X1; Input parameter num is passed in X2
    // Output value is returned in X0.


     MOVZ    X3, #0              // index = 0

    ustrncmp_loop:
        CMP     X3, X2              // index >= num ?
        B.GE    ustrncmp_all_equal  // yes → all equal

        // Load bytes from str1/str2
        LDUR    X4, [X0, #0]        // load 8 bytes from str1
        LDUR    X5, [X1, #0]        // load 8 bytes from str2

        // extract lowest byte
        MOVZ X8, #0xFF
        ANDS    X6, X4, X8
        ANDS    X7, X5, X8

        // if either null terminator, done (equal so far)
        CMP     X6, XZR
        B.EQ    ustrncmp_null_hit
        CMP     X7, XZR
        B.EQ    ustrncmp_null_hit

        // compare bytes
        CMP     X6, X7
        B.EQ    ustrncmp_next_byte
        B.LT    ustrncmp_less
        B.GT    ustrncmp_greater

    ustrncmp_next_byte:
        // advance pointers +1
        ADD     X0, X0, #1
        ADD     X1, X1, #1
        ADD     X3, X3, #1
        B       ustrncmp_loop


    ustrncmp_less:
        // return -1
        MOVZ    X0, #1
        MVN     X0, X0          // X0 = ~1 = 0xFFFFFFFFFFFFFFFE
        ADD     X0, X0, #1      // X0 = -1
        RET

    ustrncmp_greater:
        MOVZ    X0, #1
        RET

    ustrncmp_null_hit:
        MOVZ    X0, #100
        RET

    ustrncmp_all_equal:
        MOVZ    X0, #2
        RET
    .size   ustrncmp, .-ustrncmp
    // ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global random_num_gen
    .type   random_num_gen, %function
random_num_gen:
    // (STUDENT TODO) Code for random_num_gen goes here.
    // Input parameter state is passed in X0
    // Output value is returned in X0.

 SUB     SP, SP, #48
    STUR    X30, [SP, #40]
    STUR    X0,  [SP, #32]      // save base pointer

    // Load state[0..3]
    LDUR    X1, [X0, #0]        // s0
    LDUR    X2, [X0, #8]        // s1
    LDUR    X3, [X0, #16]       // s2
    LDUR    X4, [X0, #24]       // s3

    // Return value = s0 + s3
    ADDS     X5, X1, X4          // rand = s0 + s3

    // Save original s1 for later use
    ORR     X6, XZR, X2              // old_s1 = s1

    // Step 1: s2 ^= s0
    EOR     X3, X3, X1

    // Step 2: s3 ^= s1
    EOR     X4, X4, X2

    // Step 3: s1 ^= s2
    EOR     X2, X2, X3

    // Step 4: s0 ^= s3
    EOR     X1, X1, X4

    // Step 5: s2 ^= (old_s1 << 17)
    LSL     X7, X6, #17
    EOR     X3, X3, X7

    // Step 6: rotate s3 left by 45 bits
    // (need to preserve s0–s2 before call)
    STUR    X1, [SP, #0]        // save s0
    STUR    X2, [SP, #8]        // save s1
    STUR    X3, [SP, #16]       // save s2

    ORR     X0, XZR, X4              // arg0 = s3
    MOVZ    X1, #45             // arg1 = 45
    BL      bit_rotate_l        // returns rotated s3 in X0

    ORR     X4, XZR, X0              // restore rotated s3
    LDUR    X1, [SP, #0]        // reload s0
    LDUR    X2, [SP, #8]        // reload s1
    LDUR    X3, [SP, #16]       // reload s2

    // Restore pointer
    LDUR    X0, [SP, #32]

    // Store updated state
    STUR    X1, [X0, #0]        // state[0] = s0
    STUR    X2, [X0, #8]        // state[1] = s1
    STUR    X3, [X0, #16]       // state[2] = s2
    STUR    X4, [X0, #24]       // state[3] = s3

    // Return rand
    ORR     X0, XZR, X5

    LDUR    X30, [SP, #40]
    ADD     SP, SP, #48
    RET

    .size   random_num_gen, .-random_num_gen
    // ... and ends with the .size above this line.
    