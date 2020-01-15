@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
 
 /*------------------------------------------------------------------------
    File        : customer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : marek.keskull
    Created     : Tue Dec 10 21:25:35 EET 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS customer: 
    
    DEFINE TEMP-TABLE addCust LIKE Customer.
    DEFINE TEMP-TABLE getCust LIKE Customer.
    DEFINE TEMP-TABLE updateCust LIKE Customer.
    DEFINE DATASET custSet FOR updateCust.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateCustomer(INPUT custName AS CHARACTER, country AS CHARACTER, email AS CHARACTER, OUTPUT successMessage AS CHARACTER):
        
        CREATE addCust.
        
        ASSIGN addCust.FullName = custName
        addCust.EmailAddress = email
        addCust.Country = country
        addCust.CustomerID = GetNewId().
       
        BUFFER-COPY addCust TO Customer.
        
        successMessage = "New customer is added!".    
    END METHOD.
//

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID deleteCust(INPUT CustomerID AS INTEGER,OUTPUT successMessage AS CHARACTER):
        
        FIND FIRST Customer WHERE Customer.CustomerID = CustomerID EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Customer THEN
        DO:
             DELETE Customer.
             successMessage = "Customer is deleted!".
             
        END.
        
        ELSE 
        DO:
            successMessage = "This customer is not found!".
        END.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

   @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
   METHOD PUBLIC VOID getCust( OUTPUT TABLE getCust, OUTPUT successMessage AS CHARACTER ):
        
        EMPTY TEMP-TABLE getCust.
        
        FOR EACH Customer NO-LOCK:
            
            CREATE getCust.
            BUFFER-COPY Customer TO getCust.
            
        END.
        
        successMessage = "Customers are fetched successfully!".
        
        RETURN.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID getCustByID(INPUT CustomerID AS INTEGER, OUTPUT TABLE getCust, OUTPUT successMessage AS CHARACTER):
            
        EMPTY TEMP-TABLE getCust.
        FIND FIRST Customer WHERE Customer.CustomerID = CustomerID NO-LOCK NO-ERROR.
        IF AVAILABLE Customer
        THEN DO:
            CREATE getCust.
            BUFFER-COPY Customer TO getCust.
            successMessage = "This customer is found!".      
        END.
        ELSE DO:
            successMessage = "This customer is not found!".     
        END.  

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC INTEGER GetNewId(  ):
        
        DEFINE VARIABLE custID AS INTEGER INIT 0.
        FIND LAST Customer NO-LOCK NO-ERROR.
        IF AVAILABLE Customer THEN
         DO:
            custID = Customer.CustomerID.
         END.
         
         REPEAT:
             FIND FIRST Customer WHERE Customer.CustomerID = custID + 1 NO-LOCK NO-ERROR.
             custID = custID + 1.
             IF NOT AVAILABLE Customer THEN LEAVE.
         END.
         
         RETURN custID.

    END METHOD.    

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
{
    "request":{
        "custSet":{
            "updateCust":[{
                "FullName": "joonas",
                "EmailAddress":"makest2222u",
                "Country":"fin"
            }]
        }
    }
}
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID updateCust( INPUT CustomerID AS INTEGER, INPUT DATASET custSet, OUTPUT successMessage AS CHARACTER):
        FIND FIRST updateCust.
        
        FIND FIRST Customer WHERE Customer.CustomerID = CustomerID EXCLUSIVE-LOCK NO-ERROR.     
        ASSIGN
        updateCust.CustomerID = CustomerID.
        
        IF AVAILABLE Customer THEN
        DO:
            BUFFER-COPY updateCust TO Customer.
            successMessage = "Customer is updated!".
        END.
        ELSE
        DO:
            successMessage = "This customer is not found!".                                                
        END.
    END METHOD.    

END CLASS.