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
    MOVZ    X5, #64          // X5 = 64
    SUB     X4, X5, X1       // X4 = 64 - shift
    LSL     X3, X0, X1       // X3 = n << shift
    LSR     X2, X0, X4       // X2 = n >> (64 - shift)
    ORR     X0, X3, X2       // X0 = (n << shift) ^ (n >> (64 - shift))
    

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
    movz    x5, #64
    sub     x4, x5, x1        // x4 = 64 - shift
    lsl     x3, x0, x4        // x3 = n << (64 - shift)
    lsr     x2, x0, x1        // x2 = n >> shift
    orr     x0, x3, x2        // x0 = (n << (64 - shift)) | (n >> shift)

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
    
 
    // load first byte (64-bit, then mask low 8 bits)
    LDUR    X1, [X0, #0]
    AND     X1, X1, #0xFF

    // if 0xxxxxxx → one byte
    AND     X2, X1, #0x80
    CMP     X2, #0
    B.EQ    u8u_len1

    // 110xxxxx → 2 bytes
    AND     X2, X1, #0xE0
    MOVZ    X9, #0xC0
    CMP     X2, X9
    B.EQ    u8u_len2

    // 1110xxxx → 3 bytes
    AND     X2, X1, #0xF0
    MOVZ    X9, #0xE0
    CMP     X2, X9
    B.EQ    u8u_len3

    // 11110xxx → 4 bytes
    AND     X2, X1, #0xF8
    MOVZ    X9, #0xF0
    CMP     X2, X9
    B.EQ    u8u_len4

    B       u8u_invalid

//    1-byte   
u8u_len1:
    AND     X0, X1, #0x7F
    RET

//    2-byte   
u8u_len2:
    ADD     X10, X0, #1
    LDUR    X2, [X10, #0]
    AND     X2, X2, #0xFF
    AND     X3, X2, #0xC0
    MOVZ    X9, #0x80
    CMP     X3, X9
    B.NE    u8u_invalid

    AND     X3, X1, #0x1F
    LSL     X3, X3, #6
    AND     X4, X2, #0x3F
    ORR     X0, X3, X4
    CMP     X0, #0x80
    B.LT    u8u_invalid
    RET

//    3-byte   
u8u_len3:
    ADD     X10, X0, #1
    LDUR    X2, [X10, #0]
    AND     X2, X2, #0xFF
    ADD     X10, X0, #2
    LDUR    X3, [X10, #0]
    AND     X3, X3, #0xFF

    AND     X4, X2, #0xC0
    MOVZ    X9, #0x80
    CMP     X4, X9
    B.NE    u8u_invalid
    AND     X4, X3, #0xC0
    CMP     X4, X9
    B.NE    u8u_invalid

    AND     X4, X1, #0x0F
    LSL     X4, X4, #12
    AND     X5, X2, #0x3F
    LSL     X5, X5, #6
    AND     X6, X3, #0x3F
    ORR     X0, X4, X5
    ORR     X0, X0, X6

    CMP     X0, #0x800
    B.LT    u8u_invalid

    // reject surrogates 0xD800..0xDFFF
    MOVZ    X9, #0xD800
    CMP     X0, X9
    B.LT    u8u_ok3
    MOVZ    X9, #0xDFFF
    CMP     X0, X9
    B.LE    u8u_invalid

u8u_ok3:
    RET

//    4-byte   
u8u_len4:
    ADD     X10, X0, #1
    LDUR    X2, [X10, #0]
    AND     X2, X2, #0xFF
    ADD     X10, X0, #2
    LDUR    X3, [X10, #0]
    AND     X3, X3, #0xFF
    ADD     X10, X0, #3
    LDUR    X4, [X10, #0]
    AND     X4, X4, #0xFF

    MOVZ    X9, #0x80
    AND     X5, X2, #0xC0
    CMP     X5, X9
    B.NE    u8u_invalid
    AND     X5, X3, #0xC0
    CMP     X5, X9
    B.NE    u8u_invalid
    AND     X5, X4, #0xC0
    CMP     X5, X9
    B.NE    u8u_invalid

    AND     X5, X1, #0x07
    LSL     X5, X5, #18
    AND     X6, X2, #0x3F
    LSL     X6, X6, #12
    AND     X7, X3, #0x3F
    LSL     X7, X7, #6
    AND     X8, X4, #0x3F
    ORR     X0, X5, X6
    ORR     X0, X0, X7
    ORR     X0, X0, X8

    CMP     X0, #0x10000
    B.LT    u8u_invalid

    MOVZ    X9, #0x10, LSL #16
    MOVK    X9, #0xFFFF
    CMP     X0, X9
    B.GT    u8u_invalid
    RET

//    invalid   
u8u_invalid:
    MOVZ    X0, #0xFFFF
    LSL     X0, X0, #16
    ORR     X0, X0, #0xFFFF
    RET


	.size	UTF8_to_unicode, .-UTF8_to_unicode
	// ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
	.align	2
	.global	unicode_to_UTF8
	.type	unicode_to_UTF8, %function
unicode_to_UTF8:
    // (STUDENT TODO) Code for unicode_to_UTF8 goes here.
    // Input parameter a is passed in X0; input parameter utf8 is passed in X2
    // There are no output values
    
        // check if a > 0x10FFFF
    MOVZ X2, #0x1F6, LSL #16
    MOVK X2, #0x38
    CMP  X0, X2
    B.GT invalid_codepoint

    // check length
    CMP X0, #0x80
    B.LT one_byte
    CMP X0, #0x800
    B.LT two_bytes
    CMP X0, #0x10000
    B.LT three_bytes
    B four_bytes

//    1-byte   
one_byte:
    AND X3, X0, #0x7F
    STUR X3, [X1, #0]
    RET

//    2-byte   
two_bytes:
    LSR X3, X0, #6
    ORR X3, X3, #0xC0              // first byte (b1)
    AND X4, X0, #0x3F
    ORR X4, X4, #0x80              // second byte (b2)
    // little-endian pack: low byte = b1, next = b2
    LSL X4, X4, #8
    ORR X3, X3, X4
    STUR X3, [X1, #0]
    RET

//    3-byte   
three_bytes:
    LSR X3, X0, #12
    ORR X3, X3, #0xE0              // first byte (b1)
    LSR X4, X0, #6
    AND X4, X4, #0x3F
    ORR X4, X4, #0x80              // second byte (b2)
    AND X5, X0, #0x3F
    ORR X5, X5, #0x80              // third byte (b3)
    // pack: b1 | (b2<<8) | (b3<<16)
    LSL X4, X4, #8
    LSL X5, X5, #16
    ORR X3, X3, X4
    ORR X3, X3, X5
    STUR X3, [X1, #0]
    RET

//    4-byte   
four_bytes:
    LSR X3, X0, #18
    ORR X3, X3, #0xF0              // first byte (b1)
    LSR X4, X0, #12
    AND X4, X4, #0x3F
    ORR X4, X4, #0x80              // second byte (b2)
    LSR X5, X0, #6
    AND X5, X5, #0x3F
    ORR X5, X5, #0x80              // third byte (b3)
    AND X6, X0, #0x3F
    ORR X6, X6, #0x80              // fourth byte (b4)
    // pack: b1 | (b2<<8) | (b3<<16) | (b4<<24)
    LSL X4, X4, #8
    LSL X5, X5, #16
    LSL X6, X6, #24
    ORR X3, X3, X4
    ORR X3, X3, X5
    ORR X3, X3, X6
    STUR X3, [X1, #0]
    RET

//    invalid   
invalid_codepoint:
    MOVZ X3, #0xFFFF
    LSL X3, X3, #16
    ORR X3, X3, #0xFFFF            // 0xFFFFFFFF
    STUR X3, [X1, #0]
    RET

	.size	unicode_to_UTF8, .-unicode_to_UTF8
	// ... and ends with the .size above this line.

// Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global compare
    .type   compare, %function
compare:
    // (STUDENT TODO) Code for compare goes here.
    // Input parameter a is passed in X0; input parameter b is passed in X1.
    // Output value is returned in X0.
       // ----- Field 1: unique_id (unsigned long at offset 0) -----
    LDUR    X2, [X0, #0]      // load a->unique_id
    LDUR    X3, [X1, #0]      // load b->unique_id
    CMP     X2, X3
    B.NE    compare_not_equal

    // ----- Field 2: seat_code[3] at offsets 8,9,10 (use LDUR + mask) -----
    LDUR    X2, [X0, #8]
    AND     X2, X2, #0xFF
    LDUR    X3, [X1, #8]
    AND     X3, X3, #0xFF
    CMP     X2, X3
    B.NE    compare_not_equal

    LDUR    X2, [X0, #9]
    AND     X2, X2, #0xFF
    LDUR    X3, [X1, #9]
    AND     X3, X3, #0xFF
    CMP     X2, X3
    B.NE    compare_not_equal

    LDUR    X2, [X0, #10]
    AND     X2, X2, #0xFF
    LDUR    X3, [X1, #10]
    AND     X3, X3, #0xFF
    CMP     X2, X3
    B.NE    compare_not_equal

    // ----- Field 3: price (double at offset 16) -----
    // Compare bitwise as 64-bit integers to avoid FP instructions.
    LDUR    X2, [X0, #16]     // load 8 bytes of double from a
    LDUR    X3, [X1, #16]     // load 8 bytes of double from b
    CMP     X2, X3
    B.NE    compare_not_equal

    // ----- Field 4: special_admission (bool at offset 24) -----
    LDUR    X2, [X0, #24]
    AND     X2, X2, #0xFF
    LDUR    X3, [X1, #24]
    AND     X3, X3, #0xFF
    CMP     X2, X3
    B.NE    compare_not_equal

    // ----- Field 5: recommendations (pointer at offset 32) -----
    LDUR    X2, [X0, #32]
    LDUR    X3, [X1, #32]
    CMP     X2, X3
    B.NE    compare_not_equal

    // ----- Field 6: refundable (bool at offset 40) -----
    LDUR    X2, [X0, #40]
    AND     X2, X2, #0xFF
    LDUR    X3, [X1, #40]
    AND     X3, X3, #0xFF
    CMP     X2, X3
    B.NE    compare_not_equal

    // All fields equal
    MOV     X0, #0
    RET

compare_not_equal:
    MOV     X0, #1
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
    