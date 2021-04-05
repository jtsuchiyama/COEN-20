/*
	This code was written to support the book, "ARM Assembly for Embedded Applications",
	by Daniel W. Lewis. Permission is granted to freely share this software provided
	that this notice is not removed. This software is intended to be used with a run-time
    library adapted by the author from the STM Cube Library for the 32F429IDISCOVERY 
    board and available for download from http://www.engr.scu.edu/~dlewis/book3.
*/
		.syntax			unified
		.cpu			cortex-m4
		.text

// ----------------------------------------------------------
// void OffBy0(void *dst, const void *src) 
// ----------------------------------------------------------

		.global			OffBy0
        .thumb_func
        .align
OffBy0:	// R0 = op1, R1 = op2
        .rept           250     // 1000 / 4 = 250 repeats
        LDR				R2,[R1],4	// Load content into dif. register, increment by 4 bytes
        STR				R2,[R0],4	// Store content to dst, increment by 4 bytes  
        .endr

        BX				LR // Return


// ----------------------------------------------------------
// void OffBy1(void *dst, const void *src)
// ----------------------------------------------------------

		.global			OffBy1
        .thumb_func
        .align
OffBy1:	// R0 = op1, R1 = op2
        .rept			3       // Reset and begin at next word
        LDRB			R2,[R1],1	// Load content into dif. register, increment by 1 byte
        STRB			R2,[R0],1	// Store content to dst, increment by 1 byte
        .endr

        .rept    		249	// 996 / 4 = 249 repeats due to offset
        LDR      		R2,[R1],4	// Load content into dif. register, increment by 4 bytes
        STR       		R2,[R0],4	// Store content to dst, increment by 4 bytes  
        .endr    

        // Last read due to offset
        LDRB     		R2,[R1],1	// Load content into dif. register, increment by 1 byte
        STRB       		R2,[R0],1	// Store content to dst, increment by 1 byte

        BX        		LR	// Return
		

// ----------------------------------------------------------
// void OffBy2(void *dst, const void *src)
// ----------------------------------------------------------

		.global			OffBy2
        .thumb_func
        .align

OffBy2:	// R0 = op1, R1 = op2
        .rept			2	// Reset and begin at next word
        LDRB			R2,[R1],1	// Load content into dif. register, increment by 1 byte
        STRB			R2,[R0],1	// Store content to dst, increment by 1 byte
        .endr

        .rept			249 // 996 / 4 = 249 repeats due to offset
        LDR				R2,[R1],4	// Load content into dif. register, increment by 4 bytes
        STR				R2,[R0],4	// Store content to dst, increment by 4 bytes  
        .endr

        .rept			2 // Last reads due to offset
        LDRB			R2,[R1],1	// Load content into dif. register, increment by 1 byte
        STRB			R2,[R0],1	// Store content to dst, increment by 1 byte
        .endr

		BX				LR	// Return

// ----------------------------------------------------------
// void OffBy3(void *dst, const void *src)
// ----------------------------------------------------------

		.global			OffBy3
        .thumb_func
        .align

OffBy3:	// R0 = op1, R1 = op2
        // Reset and begin at next word
        LDRB			R2,[R1],1	// Load content into dif. register, increment by 1 byte
        STRB			R2,[R0],1	// Store content to dst, increment by 1 byte

        .rept			249	// 996 / 4 = 249 repeats due to offset
        LDR				R2,[R1],4	// Load content into dif. register, increment by 4 bytes
        STR				R2,[R0],4	// Store content to dst, increment by 4 bytes  
        .endr    

        .rept			3	// Last reads due to offset
        LDRB			R2,[R1],1	// Load content into dif. register, increment by 1 byte
        STRB			R2,[R0],1	// Store content to dst, increment by 1 byte
        .endr

        BX				LR	// Return

        .end


