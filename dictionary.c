// Implements a dictionary's functionality

#include <stdbool.h>
#include <cs50.h>
#include <strings.h>
#include "dictionary.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 26;

// Hash table
node *table[N];

// Words counter
int wordsCounter = 0;

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // TODO
    // Hashing word
    int hashValue = hash(word);
    // Access linked list at that hashValue index in hash table
    node *n = table[hashValue];
    // Going through linked list, searching for word
    while (n != NULL)
    {
        if (strcasecmp(word, n->word) == 0)
        {
            return true;
        }
        n = n->next;
    }

    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // I will just get the first char and convert it to ASCII
    int asciiNumber = (int)tolower(word[0]);
    return asciiNumber;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // Opening the dictionary
    FILE *theDict = fopen(dictionary, "r");
    if (theDict == NULL)
    {
        return false;
    }
    // creating word array
    char nextWord[LENGTH + 1];
    while (fscanf(theDict, "%s", nextWord) != EOF)
    {
        // Creating new node and some space for our new node (n)
        node *n = malloc(sizeof(node));
        // null check
        if (n == NULL)
        {
            return false;
        }
        // Copy + paste from theDict to node (n)
        strcpy(n->word, nextWord);
        // Words counter +1
        wordsCounter++;
        // Hashing the new word
        int hashValue = hash(nextWord);
        // adding this word into array of linked lists
        n->next = table[hashValue];
        table[hashValue] = n;
    }
    fclose(theDict);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return wordsCounter;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // Iterating through the hash table
    for (int i = 0; i < N; i++)
    {
        // Assign cursor
        node *n = table[i];
        // Going through linked list
        while (n != NULL)
        {
            // Making tmp cursor;
            node *tmp = n;
            // Point cursor to next element
            n = n->next;
            // free temp
            free(tmp);
        }
        if (n == NULL && i == N - 1)
        {
            return true;
        }
    }
    return false;
}
