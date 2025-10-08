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
 ** REPLACE THIS YOUR NAME AND EID **
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

    ret
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

    ret
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

    ret
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
    