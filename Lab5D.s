		.syntax			unified
		.cpu			cortex-m4
		.text

// ----------------------------------------------------------
// uint64_t TireDiam(uint32_t W, uint32_t A, uint32_t R)
// ----------------------------------------------------------

		.global			TireDiam
		.thumb_func
		.align
TireDiam: 
		PUSH			{R4,LR}	// Preserve the content in R4 and LR
		LDR				R3,=1270	// Load the value 1270 into R3
		MUL				R0,R1,R0	// A*W
		UDIV			R4,R0,R3	// (A*W)/1270

		ADD				R1,R2,R4	// R + (A*W)/1270
		MLS				R0,R4,R3,R0	// (A*W) - (A*W)/1270*1270
		
		POP				{R4,PC} // Restore content
		BX				LR // Return


// ----------------------------------------------------------
// uint64_t TireCirc(uint32_t W, uint32_t A, uint32_t R)
// ----------------------------------------------------------

		.global			TireCirc
		.thumb_func
		.align
TireCirc:
		PUSH			{LR}	// Preserve content
		BL				TireDiam	// Content in R0 (31-0) and R1 (63-32)
		LDR				R2,=4987290	// Load the value 4987290 into R2
		LDR				R3,=3927 // Load the value 3927 into R3
		MUL				R2,R1,R2 // D63-32*4987290
		MUL				R3,R0,R3 // D31-0*3927

		ADD				R2,R2,R3 // D63-32*4987290 + D31-0*3927
		LDR				R3,=1587500 // Load the value 1587500 into R3

		UDIV			R1,R2,R3 // Solve quotient for C63-32
		MLS				R0,R1,R3,R2 // Solve remainder for C31-0
		
		POP				{PC}	// Restore content
		BX				LR	// Return
		
		.end
		


