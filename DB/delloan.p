TRIGGER PROCEDURE FOR DELETE OF Loan.

/* Trigger provides an information message when loans are deleted */

MESSAGE "Deleting Loan:" LoanID "Loan ID:" LoanID
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
