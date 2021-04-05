		.syntax			unified
		.cpu			cortex-m4
		.text


// ----------------------------------------------------------
// int32_t Sum1(int32_t Ai, int32_t Bi, int32_t Ci)
// ----------------------------------------------------------

		.global			Sum1
		.thumb_func
		.align
Sum1: 
		EOR				R0,R0,R1	// Ai ^ Bi
		EOR				R0,R0,R2    // (Ai ^ Bi) ^ Ci
		BX				LR	// Return
	

// ----------------------------------------------------------
// int32_t Sum2(int32_t Ai, int32_t Bi, int32_t Ci)
// ----------------------------------------------------------

		.global			Sum2
		.thumb_func
		.align
Sum2: 
		ADD				R0,R0,R1	// Ai + Bi
		ADD				R0,R0,R2	// (Ai + Bi) + Ci
		AND				R0,R0,1	// (Ai + Bi + Ci) & 1
		BX				LR	// Return


// ----------------------------------------------------------
// int32_t Sum3(int32_t Ai, int32_t Bi, int32_t Ci)
// ----------------------------------------------------------

		.global			Sum3
		.thumb_func
		.align
Sum3: 
		LSL				R0,R0,2	// Ai << 2
		LSL				R1,R1,1	// Bi << 1
		ORR				R0,R0,R1	// (Ai << 2) | (Bi << 1)
		ORR				R0,R0,R2	// shift = ((Ai << 2) | (Bi << 1)) | Ci
		LDR				R1,=0b10010110 // Load binary 10010110 into R1
		LSR				R0,R1,R0	// 0b10010110 >> shift
		AND				R0,R0,1	// (0b10010110 >> shift) & 1
		BX				LR	// Return


// ----------------------------------------------------------
// int32_t Sum4(int32_t Ai, int32_t Bi, int32_t Ci)
// ----------------------------------------------------------

		.global			Sum4
		.thumb_func
		.align
Sum4: 
		LSL				R0,R0,2	// Ai << 2
		LSL				R1,R1,1	// Bi << 1
		ORR				R0,R0,R1	// (Ai << 2) | (Bi << 1)
		ORR				R0,R0,R2	// index = ((Ai << 2) | (Bi << 1)) | Ci

		LDR				R3,=s1	// Load address of the .byte s1 into R3
		LDRB			R0,[R3,R0]	// Load the content in the address R3 + R0
		BX				LR	// Return
		
s1:
		.byte			0,1,1,0,1,0,0,1	// Initiate the desired array
		

// ----------------------------------------------------------
// int32_t Cout1(int32_t Ai, int32_t Bi, int32_t Ci)
// ----------------------------------------------------------

		.global			Cout1
		.thumb_func
		.align
Cout1: 
		AND				R3,R0,R1	// Ai & Bi
		AND				R0,R0,R2	// Ai & Ci
		AND				R1,R1,R2	// Bi & Ci
		ORR				R0,R0,R3	// (Ai & Bi) | (Ai & Ci)
		ORR				R0,R0,R1	// ((Ai & Bi) | (Ai & Ci)) | (Bi & Ci)
		BX				LR	// Return


// ----------------------------------------------------------
// int32_t Cout2(int32_t Ai, int32_t Bi, int32_t Ci)
// ----------------------------------------------------------

		.global			Cout2
		.thumb_func
		.align
Cout2: 
		ADD				R0,R0,R1	// Ai + Bi
		ADD				R0,R0,R2	// (Ai + Bi) + Ci
		LSR				R0,R0,1	// (Ai + Bi + Ci) >> 1
		BX				LR	// Return


// ----------------------------------------------------------
// int32_t Cout3(int32_t Ai, int32_t Bi, int32_t Ci)
// ----------------------------------------------------------

		.global			Cout3
		.thumb_func
		.align
Cout3: 
		LSL				R0,R0,2	// Ai << 2
		LSL				R1,R1,1	// Bi << 1
		ORR				R0,R0,R1	// (Ai << 2) | (Bi << 1)
		ORR				R0,R0,R2	// shift = ((Ai << 2) | (Bi << 1)) | Ci
		LDR				R1,=0b11101000	// Load binary 11101000 into R1
		LSR				R0,R1,R0	// 0b11101000 >> shift
		AND				R0,R0,1	// (0b11101000 >> shift) & 1
		BX				LR	// Return


// ----------------------------------------------------------
// int32_t Cout4(int32_t Ai, int32_t Bi, int32_t Ci)
// ----------------------------------------------------------

		.global			Cout4
		.thumb_func
		.align
Cout4: 
		LSL				R0,R0,2	// Ai << 2
		LSL				R1,R1,1	// Bi << 1
		ORR				R0,R0,R1	// (Ai << 2) | (Bi << 1)
		ORR				R0,R0,R2	// index = ((Ai << 2) | (Bi << 1)) | Ci

		LDR				R3,=s2	// Load address of the .byte s2 into R3
		LDRB			R0,[R3,R0]	// Load the content in the address R3 + R0
		BX				LR	// Return
		
s2:
		.byte			0,0,0,1,0,1,1,1	// Initiate the desired array
		


		.end


		


