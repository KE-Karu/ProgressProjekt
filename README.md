# ProgressProjekt Library Software

Siin on meie lõpuprojekti kood koos andmebaasi mudeliga. Kasutajaliidese asemel näitame päringuid Postmani abil.

Päringud:

GET:

Küsi kõik raamatud: http://localhost:8080/Raamat/rest/RaamatService/Book

Küsi raamat id järgi: http://localhost:8080/Raamat/rest/RaamatService/Book/id

POST:

Lisa raamat: http://localhost:8080/Raamat/rest/RaamatService/Book
{
	"request": {
		"bookTitle": "Anna Karenina",
		"author": "Leo Tolstoy",
		"ISBN": "9788498199246"
	}
}
