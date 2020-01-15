# ProgressProjekt Library Software

Siin on meie lõpuprojekti kood koos andmebaasi mudeliga. Kasutajaliidese asemel näitame päringuid Postmani abil.

BOOK klassi Päringud:

GET:

Küsi kõik raamatud: http://localhost:8810/Library/rest/LibraryService/Book

Küsi raamat id järgi: http://localhost:8810/Library/rest/LibraryService/Book/{BookID}

DELETE:
Kustuta raamat id järgi: http://localhost:8810/Library/rest/LibraryService/Book/{BookID}
NB! Raamatut, millel on aktiivne laenutus, ei saa kustutada!
POST:

Lisa raamat: http://localhost:8810/Library/rest/LibraryService/Book

{
	"request":{
		"bookTitle": "Hairy Potter",
		"Author":"A.Lindsn",
		"ISBN":"999999992"
	}
}
PUT:

Muuda raamatut: http://localhost:8810/Library/rest/LibraryService/Book/{BookID}
{  
   "request":{  
      "BookSet":{  
         "updateBook":[
            {
               "Author":"value1",
               "ISBN":"98463853334",
               "BookTitle":"Lolita"
            }
         ]
      }
   }
}

CUSTOMER klassi päringud:

GET:

Küsi kõik kliendid: http://localhost:8810/Library/rest/LibraryService/Customer

Küsi kliendid id järgi: http://localhost:8810/Library/rest/LibraryService/Customer/{CustomerID}

DELETE:
Kustuta klient id järgi: http://localhost:8810/Library/rest/LibraryService/Customer/{CustomerID}
NB! Klienti, kellel on aktiivsed laenutused, ei saa kustutada!

POST:

Lisa klient: http://localhost:8810/Library/rest/LibraryService/Customer
{
	"request":{
		"custName": "Meelis Tusik",
		"email":"Meelis123@gmail.com",
		"country":"EST"
	}
}

PUT:

Muuda klienti: http://localhost:8810/Library/rest/LibraryService/Customer/{CustomerID}
{
	"request":{
		"custSet":{
			"updateCust":[{
			"FullName": "Joonas Tamm",
		        "EmailAddress":"JoonasT@gmail.com",
		        "Country":"FIN"
			}]
		}
	}
}

LOAN klassi päringud:
GET:

Küsi kõik laenud: http://localhost:8810/Library/rest/LibraryService/Loan

Küsi laenud kliendi id järgi: http://localhost:8810/Library/rest/LibraryService/Loan/Customer/{CustomerID}
Küsi laenud raamatu id järgi: http://localhost:8810/Library/rest/LibraryService/Loan/{BookID}

POST:

Lisa laenutus: http://localhost:8810/Library/rest/LibraryService/Loan
{
	"request":{
		"CustomerID": "6",
		"BookID":"13"
	}
}

PUT:

Tagasta raamat:http://localhost:8810/Library/rest/LibraryService/Loan
{
	"request":{
		"LoanID": "4",
		"BookID":"10"
	}
}	
.
