		.syntax			unified
		.cpu			cortex-m4
		.text


// ----------------------------------------------------------
// float EccentricAnomaly(float e, float M)
// ----------------------------------------------------------

		.global			EccentricAnomaly
		.thumb_func
		.align
EccentricAnomaly:
		PUSH			{LR}	// Preserve LR
		VPUSH			{S16,S17,S18}	// Preserve S16, S17, S18
		VMOV			S16,S0	// S16 = e
		VMOV			S17,S1	// S17 = M

		VMOV			S0,S17	// S0 = M
		BL				cosDeg	// S0 = cosDeg(M)

		VMUL.F32		S0,S0,S16	// S0 = e * cosDeg(M)

		VMOV			S2,1.0	// Load 1.0 into S2
		VADD.F32		S18,S0,S2	// S18 = 1.0 + (e * cosDeg(M))

		VMOV			S0,S17	// Move M into S0 to call sinDeg()
		BL				sinDeg	// S0 = sinDeg(M)

		VMUL.F32		S0,S0,S18	// S0 = sinDeg(M) * (1.0 + (e * cosDeg(M)))

		VMUL.F32		S0,S0,S16	// S0 = e * (sinDeg(M) * (1.0 + (e * cosDeg(M))))

		BL				Rad2Deg	// S0 = Rad2Deg(e * sinDeg(M)...)

		VADD.F32		S0,S0,S17 // S0 = M + Rad2Deg(e * sinDeg(M)...)

		VPOP			{S16,S17,S18}	// Restore S16, S17, S18
		POP				{PC}	// Return


// ----------------------------------------------------------
// float Kepler(float m, float ecc)
// ----------------------------------------------------------

		.global			Kepler
		.thumb_func
		.align
Kepler:
		PUSH			{LR}	// Preserve LR
		VPUSH			{S16,S17,S18,S19}	// Preserve S16, S17, S18

		BL				Deg2Rad	// S0 = Deg2Rad(m)
		VMOV			S16,S0	// S16 = e
		VMOV			S17,S1	// S17 = ecc	
		VMOV			S18,S0	// S18 = m

loop:
		BL				Rad2Deg	// S0 = Rad2Deg(e)
		BL				sinDeg	// S0 = sinf(Deg2Rad(e))
		VMUL.F32		S0,S0,S17	// S0 = ecc * sinf(Deg2Rad(e))
		VSUB.F32		S0,S16,S0	// S0 = e - (ecc * sinf(Deg2Rad(e)))
		VSUB.F32		S19,S0,S18	// S19 = delta = e - (ecc * sinf(Deg2Rad(e))) - m

		VMOV			S0,S16	// Move e into S0 to call cosf(e)
		BL				Rad2Deg	// S0 = Rad2Deg(e)
		BL				cosDeg	// S0 = cosf(Deg2Rad(e))
		VMUL.F32		S0,S0,S17	// S0 = ecc * cosf(e)
		VMOV			S1,1.0	// Load 1.0 into S1
		VSUB.F32		S0,S1,S0	// S0 = 1.0 - (ecc * cosf(e))
		VDIV.F32		S0,S19,S0	// S0 = delta / (1.0 - (ecc * cosf(e)))
		VSUB.F32		S16,S16,S0	// e -= (delta / (1.0 - (ecc * cosf(e))))

		VABS.F32		S0,S19	//  S0 = |delta|
		VLDR			S1,epsilon	// S1 = 1E-6
		VCMP.F32		S0,S1	// Compare |delta| to 1E-6
		VMRS			APSR_nzcv,FPSCR	// Core Flags <-- FPU Flags
		BGT				loop
		BLE				end

end:
		VMOV			S0,S16	// Move S16 to S0 to return e
		VPOP			{S16,S17,S18,S19}	// Restore S16, S17, S18
		POP				{PC}	// Return

		.align
epsilon: 
		.float			1E-6



		.end


		


