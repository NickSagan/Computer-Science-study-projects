#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <cs50.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./recover image\n");
        return 1;
    }

    // Creating a buffer for images
    uint8_t buffer[512];
    char outputFileName[8];
    int jpgCounter = 0;
    // opening the card.raw file
    FILE *file = fopen(argv[1], "r");

    if (file == NULL)
    {
        printf("Could not open file.\n");
        return 1;
    }
    // reading throgh the file
    FILE *img = NULL;

    while (fread(&buffer[0], sizeof(uint8_t), 512, file) == 512)
    {
        if ((buffer[0] == 0xff) && (buffer[1] == 0xd8) && (buffer[2] == 0xff) && ((buffer[3] & 0xf0) == 0xe0))
        {
            // closing previous img if found
            if (img != NULL)
            {
                fclose(img);
            }
            // creating a new file name, starting from 000.jpg
            sprintf(outputFileName, "%03i.jpg", jpgCounter);
            // file name counter +1
            jpgCounter++;
            // opening new img
            img = fopen(outputFileName, "w");
        }
        // checking if img is not NULL
        if (img != NULL)
        {
            fwrite(&buffer[0], sizeof(uint8_t), 512, img);
        }

    }
    fclose(img);
    fclose(file);


}