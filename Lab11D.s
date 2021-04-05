		.syntax			unified
		.cpu			cortex-m4
		.text


// ----------------------------------------------------------
// Q16 Normalize(Q16 divisor, int zeros)
// ----------------------------------------------------------

		.global			Normalize
		.thumb_func
		.align
Normalize:
		CMP				R1,16	// Compare zeros to 16
		BLT				elseN	// Branch to else if less then
ifN:
		SUB				R1,R1,16	// R1 = zeros - 16
		LSL				R0,R0,R1	// R0 = divisor << (zeros - 16)
		B				endN	// Branch to end

elseN:
		RSB				R1,R1,16	// R1 = 16 - zeros
		LSR				R0,R0,R1	// R0 = divisor >> (16 - zeros)

endN:
		BX				LR	// Return


// ----------------------------------------------------------
// Q16 Denormalize(Q16 estimate, int zeros) 
// ----------------------------------------------------------

		.global			Denormalize
		.thumb_func
		.align
Denormalize:
		CMP				R1,16	// Compare zeros to 16
		BLT				elseD	// Branch to else if less then

ifD:
		SUB				R1,R1,16	// R1 = zeros - 16
		LSR				R0,R0,R1	// R0 = estimate >> (zeros - 16)
		B				endD	// Branch to end

elseD:
		RSB				R1,R1,16	// R1 = 16 - zeros
		LSL				R0,R0,R1	// R0 = estimate << (16 - zeros)

endD:
		BX				LR	// Return


// ----------------------------------------------------------
// Q16 NormalizedEstimate(Q16 divisor) 
// ----------------------------------------------------------

		.global			NormalizedEstimate
		.thumb_func
		.align
NormalizedEstimate:
		LDR				R1,=123362	// R1 = FIXED(32.0/17.0)
		SMULL			R0,R1,R0,R1	// Q16Product(divisor, FIXED(32.0/17.0))
		LSR				R0,R0,16	// Shift to get the middle 32 bits right-aligned
		ORR				R0,R0,R1,LSL 16	// Extract the middle 32 bits	
		LDR				R1,=185043	// R1 = FIXED(48.0/17.0)
		SUB				R0,R1,R0	// FIXED(48.0/17.0) - Q16Product(...)
		BX				LR	// Return


// ----------------------------------------------------------
// Q16 InitialEstimate(Q16 divisor) 
// ----------------------------------------------------------

		.global			InitialEstimate
		.thumb_func
		.align
InitialEstimate:
		PUSH			{R4,LR}	// Preserve R4 and LR
		CLZ				R1,R0	// R1 = LeadingZeros(divisor)
		MOV				R4,R1	// R4 = zeros
		BL				Normalize	// R0 = Normalize(divisor, zeros)
		BL				NormalizedEstimate	// R0 = NormalizedEstimate(divisor)
		MOV				R1,R4	// R1 = zeros
		BL				Denormalize	// R0 = Denormalize(estimate, zeros)
		POP				{R4,PC}	// Restore R4 and LR
		BX				LR	// Return


// ----------------------------------------------------------
// Q16 Reciprocal(Q16 divisor)
// ----------------------------------------------------------

		.global			Reciprocal
		.thumb_func
		.align
Reciprocal:
		PUSH			{R4,R5,LR}
		MOV				R4,R0	// R4 = divisor
		BL				InitialEstimate	// R0 = InitialEstimate(divisor)
		MOV				R5,R0	// R5 = curr

loop:
		MOV				R2,R5	// R2 = prev = curr

		SMULL			R0,R1,R4,R2	// R0 = Q16Product(divisor, prev)
		LSR				R0,R0,16	// Shift to get the middle 32 bits right-aligned
		ORR				R0,R0,R1,LSL 16	// Extract the middle 32 bits
		RSB				R0,R0,131072 // R0 = temp = FIXED(2.0) - Q16Product(...)

		SMULL			R0,R1,R0,R2	// R5 = curr = Q16roduct(temp, prev)
		LSR				R0,R0,16	// Shift to get the middle 32 bits right-aligned
		ORR				R5,R0,R1,LSL 16	// Extract the middle 32 bits
		
		SUB				R0, R5, R2	// R0 = diff = curr - prev

		ADD				R0,R0,66	// R0 = diff + FIXED(0.001)
		CMP				R0,132	// Compare (diff + FIXED(0.001)) to 2*FIXED(0.001)
		BGT				loop	// Branch to loop if greater than

		MOV				R0,R5	// Move curr to R0 to be returned
		POP				{R4,R5,PC}
		BX				LR	// Return



		.end


		


