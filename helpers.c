#include "helpers.h"
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <cs50.h>
#include <string.h>
#include <stdlib.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float avrgFloat = (float)(((float)image[i][j].rgbtBlue + (float)image[i][j].rgbtRed + (float)image[i][j].rgbtGreen) / (float)3);
            int avrg = roundf(avrgFloat);
            if (avrg < 0)
            {
                avrg = 0;
            }
            else if (avrg > 255)
            {
                avrg = 255;
            }
            image[i][j].rgbtBlue = avrg;
            image[i][j].rgbtGreen = avrg;
            image[i][j].rgbtRed = avrg;
        }
    }
    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            // Formula to convert image into sepia style
            float tmpFloat = (float)(0.393 * (float)image[i][j].rgbtRed);
            tmpFloat += (0.769 * (float)image[i][j].rgbtGreen);
            tmpFloat += (0.189 * (float)image[i][j].rgbtBlue);
            int tmp = roundf(tmpFloat);
            if (tmp < 0)
            {
                tmp = 0;
            }
            else if (tmp > 255)
            {
                tmp = 255;
            }
            // Formula to convert image into sepia style
            float tmpFloat2 = (float)(0.349 * (float)image[i][j].rgbtRed);
            tmpFloat2 += (0.686 * (float)image[i][j].rgbtGreen);
            tmpFloat2 += (0.168 * (float)image[i][j].rgbtBlue);
            int tmp2 = roundf(tmpFloat2);
            if (tmp2 < 0)
            {
                tmp2 = 0;
            }
            else if (tmp2 > 255)
            {
                tmp2 = 255;
            }
            // Formula to convert image into sepia style
            float tmpFloat3 = (float)(0.272 * (float)image[i][j].rgbtRed);
            tmpFloat3 += (0.534 * (float)image[i][j].rgbtGreen);
            tmpFloat3 += (0.131 * (float)image[i][j].rgbtBlue);
            int tmp3 = roundf(tmpFloat3);
            if (tmp3 < 0)
            {
                tmp3 = 0;
            }
            else if (tmp3 > 255)
            {
                tmp3 = 255;
            }
            // updating image
            image[i][j].rgbtRed = tmp;
            image[i][j].rgbtGreen = tmp2;
            image[i][j].rgbtBlue = tmp3;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE buffer[width];
    for (int i = 0; i < height; i++)
    {
        // Appending to buffer
        for (int j = 0; j < width; j++)
        {
            buffer[j] = image[i][j];
        }
        // Going through the buffer

        for (int z = 0; z < width; z++)
        {
            image[i][z] = buffer[width - z - 1];
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    // def new duplicate for image
    RGBTRIPLE imageDuplicate[height][width];

    // making this duplicate pixel by pixel
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            imageDuplicate[i][j] = image[i][j];
        }
    }

    // main logic. going through all rows and columns to calculate average
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            // self pixel added to clculations
            int sumOfRedPixelsAround = imageDuplicate[i][j].rgbtRed;
            int sumOfGreenPixelsAround = imageDuplicate[i][j].rgbtGreen;
            int sumOfBluePixelsAround = imageDuplicate[i][j].rgbtBlue;
            int numOfPixelsAround = 1;
            // checking top side
            if (i - 1 >= 0)
            {
                sumOfRedPixelsAround += imageDuplicate[i - 1][j].rgbtRed;
                sumOfGreenPixelsAround += imageDuplicate[i - 1][j].rgbtGreen;
                sumOfBluePixelsAround += imageDuplicate[i - 1][j].rgbtBlue;
                numOfPixelsAround ++;
                if (j - 1 >= 0)
                {
                    // checking left side
                    sumOfRedPixelsAround += imageDuplicate[i - 1][j - 1].rgbtRed;
                    sumOfGreenPixelsAround += imageDuplicate[i - 1][j - 1].rgbtGreen;
                    sumOfBluePixelsAround += imageDuplicate[i - 1][j - 1].rgbtBlue;
                    numOfPixelsAround ++;
                }
                if (j + 1 < width)
                {
                    // checking right side
                    sumOfRedPixelsAround += imageDuplicate[i - 1][j + 1].rgbtRed;
                    sumOfGreenPixelsAround += imageDuplicate[i - 1][j + 1].rgbtGreen;
                    sumOfBluePixelsAround += imageDuplicate[i - 1][j + 1].rgbtBlue;
                    numOfPixelsAround ++;
                }
            }
            // checking bottom side
            if (i + 1 < height)
            {
                sumOfRedPixelsAround += imageDuplicate[i + 1][j].rgbtRed;
                sumOfGreenPixelsAround += imageDuplicate[i + 1][j].rgbtGreen;
                sumOfBluePixelsAround += imageDuplicate[i + 1][j].rgbtBlue;
                numOfPixelsAround ++;
                // checking left bottom side
                if (j - 1 >= 0)
                {
                    sumOfRedPixelsAround += imageDuplicate[i + 1][j - 1].rgbtRed;
                    sumOfGreenPixelsAround += imageDuplicate[i + 1][j - 1].rgbtGreen;
                    sumOfBluePixelsAround += imageDuplicate[i + 1][j - 1].rgbtBlue;
                    numOfPixelsAround ++;
                }
                // checking bottom right side
                if (j + 1 < width)
                {
                    sumOfRedPixelsAround += imageDuplicate[i + 1][j + 1].rgbtRed;
                    sumOfGreenPixelsAround += imageDuplicate[i + 1][j + 1].rgbtGreen;
                    sumOfBluePixelsAround += imageDuplicate[i + 1][j + 1].rgbtBlue;
                    numOfPixelsAround ++;
                }
            }
            // checking only left side
            if (j - 1 >= 0)
            {
                sumOfRedPixelsAround += imageDuplicate[i][j - 1].rgbtRed;
                sumOfGreenPixelsAround += imageDuplicate[i][j - 1].rgbtGreen;
                sumOfBluePixelsAround += imageDuplicate[i][j - 1].rgbtBlue;
                numOfPixelsAround ++;
            }
            // checking only right side
            if (j + 1 < width)
            {
                sumOfRedPixelsAround += imageDuplicate[i][j + 1].rgbtRed;
                sumOfGreenPixelsAround += imageDuplicate[i][j + 1].rgbtGreen;
                sumOfBluePixelsAround += imageDuplicate[i][j + 1].rgbtBlue;
                numOfPixelsAround ++;
            }
            // changing pixel of the original image
            image[i][j].rgbtRed = round((float)sumOfRedPixelsAround / (float)numOfPixelsAround);
            image[i][j].rgbtGreen = round((float)sumOfGreenPixelsAround / (float)numOfPixelsAround);
            image[i][j].rgbtBlue = round((float)sumOfBluePixelsAround / (float)numOfPixelsAround);

        }
    }
    return;
}
