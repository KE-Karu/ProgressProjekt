TRIGGER PROCEDURE FOR CREATE OF Loan.

/* Automatically Increment LoanID using NextLoanNum Sequence */

ASSIGN loan.loanID =  NEXT-VALUE(NextLoanID) 

/* Set Burrowed Date to TODAY */

loan.dateBurrowed = TODAY
