#include <stdint.h>

int32_t Bits2Signed(int8_t bits[8]) // Convert array of bits to signed int.
{
    int i;
    int32_t sign;
    if (bits[7] == 0) 
        sign = 0;

    else if (bits[7] == 1) // The value is negative, thus the weight of the first bit must be negative
        sign = -1;

    for (i=6; i>-1; i--) // Carries out simplified polynomial evaluation from MSB-1 to LSB
        sign = 2*sign + bits[i];

    return sign;
}

uint32_t Bits2Unsigned(int8_t bits[8]) // Convert array of bits to unsigned int
{
    int i;
    uint32_t unsign = 0;
    for (i=7; i>-1; i--) // Carries out simplified polynomial evaluation from MSB to LSB
        unsign = 2*unsign + bits[i];

    return unsign;
}

void Increment(int8_t bits[8]) // Add 1 to value represented by bit pattern
{
    int i;
    for(i=0;i<8;i++) // Start from LSB to MSB to check for carryover
    {
        if (bits[i] == 0) // Once a 0 is traversed, there is no carryover, thus the loop can end
        {
            bits[i] = 1;
            return; 
        }

        else if (bits[i] == 1) // Indicates that there is still carryover 
            bits[i] = 0;
    }
}

void Unsigned2Bits(uint32_t n, int8_t bits[8]) // Opposite of Bits2Unsigned.
{
    int i;
    for(i=0;i<8;i++) // Starts at index 0 since repeated division goes from LSB to MSB
    {
        bits[i] = n % 2; // Remainder
        n = n / 2; // Repeated division
    }
}
