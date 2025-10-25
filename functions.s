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

            //   1-byte check (< 0x80)  
            MOVZ X3, #0x80
            CMP  X0, X3
            B.LT one_byte

            //   2-byte check (< 0x800)  
            MOVZ X3, #0x800
            CMP  X0, X3
            B.LT two_bytes

            //   3-byte check (< 0x10000)  
            MOVZ X3, #0x1, LSL #16
            CMP  X0, X3
            B.LT three_bytes

            // else, 4-byte
            B four_bytes

        //     1-byte    
        one_byte:
            MOVZ X3, #0x7F
            ANDS X4, X0, X3
            STUR X4, [X1, #0]
            RET

        //     2-byte    
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

        //     3-byte    
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

        //   4-byte  
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

        //   Invalid    
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

    ret
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

ret

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

    ret
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

    .size   random_num_gen, .-random_num_gen
    // ... and ends with the .size above this line.
    