TRIGGER PROCEDURE FOR DELETE OF Customer.

/* Customer record cannot be deleted if ongoing loans are found */

FIND FIRST loan OF customer NO-ERROR.
IF NOT AVAILABLE loan THEN DO:
   RETURN.
END.   
ELSE DO:
   MESSAGE "Open loans exist for Customer " customer.customerID  
           ".  Cannot delete."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   RETURN ERROR.
END.     
