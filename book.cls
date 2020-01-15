@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
 
 /*------------------------------------------------------------------------
    File        : book
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : marek.keskull
    Created     : Fri Dec 13 16:00:27 EET 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS book:
   DEFINE TEMP-TABLE addBook LIKE Book.
   DEFINE TEMP-TABLE getBook LIKE Book.
   DEFINE TEMP-TABLE updateBook LIKE Book.
   DEFINE DATASET bookSet FOR updateBook.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID getBook( OUTPUT TABLE getBook, OUTPUT successMessage AS CHARACTER ):
        
        EMPTY TEMP-TABLE getBook.
        
        FOR EACH Book NO-LOCK:
            
            CREATE getBook.
            BUFFER-COPY Book TO getBook.
            
        END.
        
        successMessage = "Books fetched successfully!".
        
        RETURN.

    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID createBook(INPUT bookTitle AS CHARACTER, Author AS CHARACTER, ISBN AS INT64, OUTPUT successMessage AS CHARACTER):
        
        CREATE addBook.
        
        ASSIGN addBook.BookTitle = bookTitle.
        addBook.Author = Author.
        addBook.ISBN = ISBN.
        addBook.BookID = getNewId().      
        BUFFER-COPY addBook TO Book.
        
        successMessage = "New book is added!".

    END METHOD.
    METHOD PUBLIC INTEGER getNewId(  ):
        DEFINE VARIABLE BookID AS INTEGER INIT 0.
        FIND LAST Book NO-LOCK NO-ERROR.
        IF AVAILABLE Book THEN
         DO:
            BookID = Book.BookID.
         END.
         
         REPEAT:
             FIND FIRST Book WHERE Book.BookID = BookID + 1 NO-LOCK NO-ERROR.
             BookID = BookID + 1.
             IF NOT AVAILABLE Book THEN LEAVE.
         END.
         
         RETURN BookID.
        
    END METHOD.
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID updateBook( INPUT BookID AS INTEGER, INPUT DATASET BookSet, OUTPUT successMessage AS CHARACTER):
    

        FIND FIRST updateBook.
        
        FIND FIRST Book WHERE Book.BookID = BookID EXCLUSIVE-LOCK NO-ERROR.     
        ASSIGN
        updateBook.BookID = BookID.
        
        IF AVAILABLE Book THEN
        DO:
            BUFFER-COPY updateBook TO Book.
            successMessage = "Book is updated!".

        END.
        ELSE
        DO:
            successMessage = "This book is not found!".
                                                   
        END.
    END METHOD.    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID deleteBook(INPUT BookID AS INTEGER,OUTPUT successMessage AS CHARACTER):
        
        FIND FIRST Book WHERE Book.BookID = BookID EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Book THEN
        DO:
             IF Book.inLibrary EQ TRUE THEN DO :
                DELETE Book.
                successMessage = "Book is deleted!".
                END.
        ELSE DO:
                successMessage = "Can't delete book with loan!".
            END.       
        END.
        
        ELSE 
        DO:
            successMessage = "This book is not found!".
        END.

    END METHOD.
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID getBookByID(INPUT BookID AS INTEGER, OUTPUT TABLE getBook, OUTPUT successMessage AS CHARACTER ):
            
        EMPTY TEMP-TABLE getBook.
        FIND FIRST Book WHERE Book.BookID = BookID NO-LOCK NO-ERROR.
        IF AVAILABLE Book
        THEN DO:
            CREATE getBook.
            BUFFER-COPY Book TO getBook.
            successMessage = "This book is found!".                    
        END.
        
        ELSE DO:
            successMessage = "This book is not found!".       
        END.  

    END METHOD.

END CLASS.