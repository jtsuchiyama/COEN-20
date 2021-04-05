            .syntax     unified
            .cpu        cortex-m4
            .text
            .thumb_func
            .align      2

            .global     Add
Add:        ADD         R0,R0,R1    // R0 = a + b
            BX          LR

            .global     Less1
Less1:      SUB         R0,R0,1     // R0 = a - 1
            BX          LR

            .global     Square2x
Square2x:   ADD         R0,R0,R0    // R0 = x + x
            B           Square      // R0 <- Square(x + x)

            .global     Last
Last:       PUSH        {R4,LR}
            MOV         R4,R0       // Preserve x in R4 since you need the value in R0 to ADD
            BL          SquareRoot  // R0 <- SquareRoot(x)
            ADD         R0,R0,R4    // R0 = x + SquareRoot(x)
            POP         {R4,PC}   
        
            .end

           