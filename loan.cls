@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
 
 /*------------------------------------------------------------------------
    File        : loan
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : marek.keskull
    Created     : Mon Dec 16 22:06:45 EET 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS loan: 
    DEFINE TEMP-TABLE addLoan LIKE Loan.
    DEFINE TEMP-TABLE BookUpdate LIKE Book.
    DEFINE TEMP-TABLE getLoan LIKE Loan.
    


    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID addLoan(INPUT BookID AS INTEGER, CustomerID AS INTEGER,OUTPUT successMessage AS CHARACTER):
        CREATE addLoan.
        FIND FIRST book WHERE Book.BookID = bookID AND book.inLibrary = TRUE EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE book THEN DO:
          ASSIGN addLoan.DateBorrowed = DATE(NOW).
               addLoan.BookDeadLine = DATETIME(DATE(NOW)+ 30).
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
          EMPTY TEMP-TABLE addLoan NO-ERROR.
END METHOD.
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

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID ReturnBook(INPUT BookID AS INTEGER,LoanID AS INTEGER, OUTPUT successMessage AS CHARACTER ):
        CREATE addLoan.
        CREATE BookUpdate.
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
        ASSIGN BookUpdate.BookID = BookID.
        IF AVAILABLE Book THEN
        DO:
            ASSIGN 
            Book.inLibrary = YES.
           // BUFFER-COPY BookUpdate 
            //TO Book.
            successMessage = "Book is returned!".
        END.
        ELSE
        DO:
            successMessage = "This loan is not found!".
                                                    
        END.

    END METHOD.
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID getLoan( OUTPUT TABLE getLoan, OUTPUT successMessage AS CHARACTER ):
        
        EMPTY TEMP-TABLE getLoan.
        
        FOR EACH Loan NO-LOCK:           
            CREATE getLoan.
            BUFFER-COPY Loan TO getLoan.          
        END.
        
        successMessage = "Loans are fetched successfully!".
        
        RETURN.

    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID getLoanByBookID(INPUT BookID AS INTEGER, OUTPUT TABLE getLoan, OUTPUT successMessage AS CHARACTER ):
            
        EMPTY TEMP-TABLE getLoan.
        FIND FIRST Loan WHERE Loan.BookID = BookID NO-LOCK NO-ERROR.
        IF AVAILABLE Loan
        THEN DO:
            CREATE getLoan.
            BUFFER-COPY Loan TO getLoan.
            successMessage = "All loans for this book are found!".                    
        END.
        
        ELSE DO:
            successMessage = "Loans for this book are not found!".       
        END.  

    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID getLoanByCustID(INPUT CustomerID AS INTEGER, OUTPUT TABLE getLoan, OUTPUT successMessage AS CHARACTER ):
            
        EMPTY TEMP-TABLE getLoan.
        FIND FIRST Loan WHERE Loan.CustomerID = CustomerID NO-LOCK NO-ERROR.
        IF AVAILABLE Loan
        THEN DO:
            CREATE getLoan.
            BUFFER-COPY Loan TO getLoan.
            successMessage = "All loans for this customer are found!".                    
        END.
        
        ELSE DO:
            successMessage = "Loans for this customer are not found!".       
        END.  

    END METHOD.

END CLASS.