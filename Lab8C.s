		.syntax			unified
		.cpu			cortex-m4
		.text


// ----------------------------------------------------------
// uint32_t Mul32X10(uint32_t multiplicand)
// ----------------------------------------------------------

		.global			Mul32X10
		.thumb_func
		.align
Mul32X10: 
		LSL				R1,R0,3	// R0 << 3 = 8*R0
		ADD				R0,R1,R0,LSL 1	// 8*R0 + R0 << 1 = 8*R0 + 2*R0 = 10*R0
		BX				LR	// Return


// ----------------------------------------------------------
// uint64_t Mul64X10(uint64_t multiplicand)
// ----------------------------------------------------------

		.global			Mul64X10
		.thumb_func
		.align
Mul64X10: 
		LSL				R3,R1,3	// R1*8
		ADD				R3,R3,R0,LSR 29	// R1*8 + 3 MSBs from R0
		LSL				R2,R0,3	// R0*8
		LSL				R1,R1,1	// R1*2
		ADD				R1,R3,R1	//R1*2 + R1*8 = R1*10
		ADD				R1,R1,R0,LSR 31	//R1*10 + MSB from R0
		LSL				R0,R0,1	// R0*2
		ADDS			R0,R2,R0	// R0*8 + R0*2 = R0*10 and capture carry
		ADC				R1,R1,0	// R1*10 + Carry from R0*10
		BX				LR	// Return


// ----------------------------------------------------------
// uint32_t Div32X10(uint32_t dividend)
// ----------------------------------------------------------

		.global			Div32X10
		.thumb_func
		.align
Div32X10: 
		LDR				R1,=3435973837	// (2^35 + 2)/10 = 3435973837
		UMULL			R2,R1,R1,R0	// (3435973837 x 100)
		LSR				R0,R1,3	// R1 >> 3
		BX				LR	// Return



		.end


		


