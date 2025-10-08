/**************************************************************************
 * C S 429 Assembly Coding Lab
 *
 * testbench.c - Testbench for all the assembly functions.
 *
 * Copyright (c) 2022, 2023, 2024.
 * Authors: Anoop Rachakonda, Kavya Rathod, Prithvi Jamadagni
 * All rights reserved.
 * May not be used, modified, or copied without permission.
 **************************************************************************/

#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>


/**
 * A struct representing a student. The various fields
 * will be compared in the compare() function.
 */
typedef struct concert_ticket {
  unsigned long unique_id;      // 1
  char seat_code[3];            // 2
  double price;                 // 3
  bool special_admission;       // 4
  struct concert_ticket *recommendations;          // 5
  bool refundable;              // 6
} concert_ticket_t;

/**
 * A struct that represents a node of a binary tree.
 * It contains pointers to its 2 children and 1 piece of data.
 */
typedef struct tree_node {
  struct tree_node *left, *right;
  uint64_t data;
} node_t;

// Week 1:

/**
 * bit_rotate_l function
 * 
 * Given a uint64_t n and a rotate amount shift, perform a left rotation on the given value.
 * 
 * @param n is the value to be rotated.
 * @param shift is the rotation amount, done through a combination of left and right shifts.
 * @return the result of the rotation as a uint64_t.
 */
uint64_t bit_rotate_l(const uint64_t n, const uint64_t shift);

/**
 * bit_rotate_r function
 * 
 * Given a uint64_t n and a rotate amount shift, perform a right rotation on the given value.
 * 
 * @param n is the value to be rotated.
 * @param shift is the rotation amount, done through a combination of left and right shifts.
 * @return the result of the rotation as a uint64_t.
 */
uint64_t bit_rotate_r(const uint64_t n, const uint64_t shift);

/**
 * UTF8 to unicode function
 * 
 * Returns the Unicode codepoint of a UTF-8 encoding stored in utf8.
 * May be a four byte, three byte, two byte, or one byte long encoding.
 * There is no need to check for any error conditions.
 *
 * @param utf8 is the char array containing the UTF-8 encoding.
 * @return the Unicode codepoint of the given encoding.
 */
uint64_t UTF8_to_unicode(const char utf8[4]);

/**
 * unicode to UTF8 function
 * 
 * Converts given Unicode codepoint a into a valid UTF-8 encoding, stored in utf8.
 * May be a four byte, three byte, two byte, or one byte long encoding.
 * If a falls outside the valid Unicode codespace, all elements of utf8 must be 0xFF.
 *
 * @param a is the Unicode codepoint to convert.
 * @param utf8 is the array in which to store the UTF8 value.
 * This function does not return any value.
 */
void unicode_to_UTF8(const uint64_t a, char utf8[4]);

/**
 * compare function
 * 
 * Given two pointers to concert_ticket_t structs, perform a field-by-field
 * comparison and return 0 if the two structs have the same field values.
 *
 * Compare characters, ints via numerical comparison.
 * Compare floats as raw binary strings, disregarding their numerical value.
 * Compare pointers by seeing if they point to the same memory location.
 * 
 * @param a a pointer to the first struct to compare
 * @param b a pointer to the second struct to compare
 * @return a uint64_t representing the ordinal position of the first field
 *          that the two structs differ. For example if the structs first
 *          differ in the "gpa" field, return 3.
 */
uint64_t compare(concert_ticket_t *a, concert_ticket_t *b);

// Week 2:

/**
 * change_case function
 *
 * Given a pointer to a string, modify the case of the string according
 * to the flag. If the flag is true, make the string uppercase. If it
 * is false, make the string lowercase. Ignore non-alphabetical characters
 * in the string (that is, keep them the same).
 * 
 * This function modifies the string in-place. It does NOT create a new
 * string or copy it to a different location.
 *
 * @param str a pointer to the string to modify.
 * @param flag the flag to specify uppercase or lowercase operation.
 * This function does not return any value.
 */
void change_case(char *str, bool flag);

/**
 * tree_depth function
 * 
 * Given a pointer to the root of a binary tree, return the depth of the tree.
 * The tree is not necessarily complete or balanced.
 * A tree with only 1 node (the root) has depth 1.
 * This function must use recursion.
 *
 * @param root a pointer to the root node of the tree.
 * @return the depth of the tree.
 */
uint64_t tree_depth(node_t *root);

/**
 * ustrncmp function
 * 
 * Compare the first num characters of str1 and str2.
 * If all first num characters in both strings are equal, return 2.
 * If one encounters a null terminator in either string before reaching num, return 100.
 * If the strings differ before reaching num amount of characters,
 * return -1 if str1[i] < str2[i], and 1 if str2[i] <= str1[i].
 * There is no need to check for any null input.
 *
 * @param str1 is the first out of two strings.
 * @param str2 is the second out of two strings.
 * @param num is the amount of chars to check.
 * @return a numerical value reflecting the result of the comparison.
 */
uint64_t ustrncmp(const char* str1, const char* str2, const uint64_t num);

/**
 * random_num_gen function
 * 
 * Generates a pseudo-random value based on the given state array.
 * Then, modifies the state array according to the xoshiro256 algorithm.
 * 
 * @param state is the state array to modify.
 * @return the pseudo-random number generated from the given state.
 */
uint64_t random_num_gen(uint64_t state[4]);


#endif
