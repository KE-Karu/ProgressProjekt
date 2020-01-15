USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS loan: 
    DEFINE TEMP-TABLE addLoan LIKE Loan.
    DEFINE TEMP-TABLE updateBook LIKE Book.
    
   
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID addLoan(INPUT bookID AS INTEGER, customerID AS INTEGER, OUTPUT successMessage AS CHARACTER):
        CREATE addLoan.
        FIND FIRST book WHERE Book.BookID = bookID AND book.inLibrary = TRUE EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE book THEN DO:
            ASSIGN addLoan.DateBorrowed = DATE(NOW).
               addLoan.Deadline = DATETIME(DATE(NOW)+ 30).
               addLoan.CustomerID = CustomerID.
               addLoan.BookID = BookID.
               book.inLibrary = NO.
               addLoan.LoanID = GetNewId().
                   
            BUFFER-COPY addLoan TO Loan.
            successMessage = "New loan added!".
        END. 
        ELSE
        DO:
          successMessage = "This loan can not be added!".
        END.
        //EMPTY TEMP-TABLE addLoan NO-ERROR.
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID returnBook(INPUT BookID AS INTEGER, LoanID AS INTEGER, OUTPUT successMessage AS CHARACTER):
        CREATE addLoan.
        CREATE updateBook.
        FIND FIRST Loan WHERE Loan.LoanID = LoanID EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN 
        addLoan.LoanID = LoanID.
        addLoan.BookID = BookID.
        
        IF AVAILABLE Loan THEN
        DO:
            ASSIGN 
            addLoan.DateReturned = DATE(NOW).
            BUFFER-COPY addLoan EXCEPT addLoan.CustomerID addLoan.LoanID TO Loan.
           
            END.
        
        FIND FIRST Book WHERE Book.BookID = BookID EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN updateBook.BookID = BookID.
        IF AVAILABLE Book THEN
        DO:
            ASSIGN 
            Book.inLibrary = YES.
           // BUFFER-COPY BookUpt 
            //TO Book.
            successMessage = "Book is returned!".
        END.
        ELSE
        DO:
            successMessage = "This loan is not found!".                                                 
        END.

    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    METHOD PUBLIC INTEGER GetNewId(  ):
        
        DEFINE VARIABLE LoanID AS INTEGER INIT 0.
        FIND LAST Loan NO-LOCK NO-ERROR.
        IF AVAILABLE Loan THEN
         DO:
            LoanID = Loan.LoanID.
         END.
         
         REPEAT:
             FIND FIRST Loan WHERE Loan.LoanID = LoanID + 1 NO-LOCK NO-ERROR.
             LoanID = LoanID + 1.
             IF NOT AVAILABLE Loan THEN LEAVE.
         END.
         
         RETURN LoanID.

    END METHOD.

END CLASS.