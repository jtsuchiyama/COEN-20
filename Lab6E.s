		.syntax			unified
		.cpu			cortex-m4
		.text

// ----------------------------------------------------------
// int Between(int min, int value, int max)
// ----------------------------------------------------------
// value <= max: If value-min <= max-min, then min can be added to both sides, resulting in value <= max
// min <= value: If max is always greater than min, then it will never overflow

		.global			Between
		.thumb_func
		.align

Between:
		SUB				R1,R1,R0	// Calculate value-min
		SUB				R2,R2,R0	// Calculate max-min
		CMP				R1,R2	// Compare value-min and max-min
		ITE				LS	
		LDRLS			R0,=1	// If value-min <= max-min, return 1 (True)			
		LDRHI			R0,=0	// If value-min > max-min, return 0 (False)
		BX				LR	// Return

// ----------------------------------------------------------
// int Count(int cells[], int numb, int value)
// ----------------------------------------------------------

		.global			Count
		.thumb_func
		.align
Count:
		LDR 			R3,=0	// Set the counter for the return to 0
		SUB				R1,R1,1	// Adjust R1 since the number of elements is 1 greater than the index
		LSL				R1,R1,2	// Adjust since each element is 4 bytes long
		ADD				R1,R0,R1	// Calculate the last index in the array
		
top:	
		CMP				R0,R1	// Compare the current index to the final index
		BEQ				done	// If at the end of traversal, branch to done
		LDR				R12,[R0],4	// Load R12 with the value at the address R0 and then increment to the next index
		CMP				R2,R12	// Compare value and the current element in cells
		IT				EQ
		ADDEQ			R3,R3,1	// Increment counter if value and the current element are the same	
		B				top	// Branch to top

done:	
		MOV				R0,R3	// Move counter to R0 to prepare for return
		BX				LR
		
		.end

		


