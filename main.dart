import 'dart:io';

class Book {
  String Title = " ";
  String Author = " ";
  String Genre = " ";
  int ID_Borrower = 0;
  bool available = true;

  List genre = [
    "computer science",
    "philosophy",
    "pure science",
    "art and recreation",
    "history"
  ];

  addBook() {
    stdout.write("Title : ");
    Title = stdin.readLineSync()!;
    stdout.write("Author :");
    Author = stdin.readLineSync()!;
    //the genre keeps on looping until the input is valid
    do {
      stdout.write("Genre: ");
      Genre = stdin.readLineSync()!;
      Genre = Genre.toLowerCase();
    } while (!genre.contains(Genre));
  }

  display() {
    stdout.write(Title + " - " + Author + " - " + Genre);
    if (available == true) {
      print(" Status : Available");
    } else {
      print(" Status : Borrowed");
    }
  }
}

class Customer {
  String Name = " ";
  String Address = " ";
  String ISBNbooks = "";

  addCustomer() {
    stdout.write("Name : ");
    Name = stdin.readLineSync()!;
    stdout.write("Address :");
    Address = stdin.readLineSync()!;
  }

  display() {
    print(" Name: " + Name + " Address: " + Address + " Books : " + ISBNbooks);
    //tried converting the string ISBN into title
    /*  if (ISBNbooks.isEmpty) {
    } else {
      List b = ISBNbooks.split(' ');
      b.forEach((element) {
        stdout.write(BookDetails[element].Title);
      });
    }*/
  }
}

LoadBook() {
  //Here we load the bookRecord CSV file into memory
  final BookRecord = File("BookRecord.csv").readAsLinesSync();
  BookRecord.removeAt(0);
  for (var line in BookRecord) {
    var v = line.split(',');
    ISBN.add(v[0]);
    Book b = new Book();
    b.Title = v[1];
    b.Author = v[2];
    b.Genre = v[3];
    if (v[4] == 'true')
      b.available = true;
    else
      b.available = false;
    BookDetails[v[0]] = b;
    bookCount++;
  }
}

LoadCustomer() {
  //Here we load the CustomerRecord file into memory
  final CustomerRecord = File("CustomerREcord.csv").readAsLinesSync();
  CustomerRecord.removeAt(0);
  for (var line in CustomerRecord) {
    var v = line.split(',');
    USERNAME.add(v[0]);
    Customer c = new Customer();
    c.Name = v[1];
    c.Address = v[2];
    if (v[3].isEmpty) {
      c.ISBNbooks = " ";
    } else {
      c.ISBNbooks = v[3];
    }
    CustomerDetails[v[0]] = c;
    customerCount++;
  }
}

UnloadBook() {
  File Unload = new File("BookRecord.csv");
  Unload.writeAsStringSync("ISBN,Title,Author,Genre,Available");
  String text = "\n";
  ISBN.forEach((e) {
    text += e + ", " + BookDetails[e].Title + ", " + BookDetails[e].Author;
    text += ", " + BookDetails[e].Genre + ",";
    if (BookDetails[e].available == true) {
      text += "true";
    } else {
      text += "false";
    }
    Unload.writeAsStringSync(text, mode: FileMode.append);
    text = "\n";
  });
}

UnloadCustomer() {
  File Unload = new File("CustomerRecord.csv");
  Unload.writeAsStringSync("USERNAME,Name,Address,Books");
  String text = "\n";
  USERNAME.forEach((e) {
    text += e + ", " + CustomerDetails[e].Name;
    text += ", " + CustomerDetails[e].Address;
    text += ", " + CustomerDetails[e].ISBNbooks;
    Unload.writeAsStringSync(text, mode: FileMode.append);
    text = "\n";
  });
}

command() {
  print("""
                add book - Add book in E-Library
                display book - Display all books of Library
                display borrowed - Display all books that were Borrowed
                display available - Display all books that are Available
                add Customer - Add new Customer 
                display Cutomer - Display customer Details
                borrow - Borrow a book
                return - return a book
                commands - print commands
                book count - display all books, available and borrowed
                exit - exit E-Library
          """);
}

var BookDetails = new Map(); //Map for ISBN : Book Object
List ISBN = []; //List for ISBN
int bookCount = 0; //Total Number of Books

var CustomerDetails = new Map(); //Map for customer USERNAME : customerObject
List USERNAME = []; // List for customer USERNAME,
//which is unique in every customer
int customerCount = 0;

main() {
  var choice = " ";
  LoadBook();
  LoadCustomer();

  print("**********WELCOME TO E-LIBRARY!***************");
  command();
  do {
    stdout.write("Enter Command: ");
    choice = stdin.readLineSync()!;
    choice.toLowerCase();
    switch (choice) {
      case 'add book': //Add Book Option
        {
          var temp = " ";
          stdout.write("Enter ISBN : ");
          temp = stdin.readLineSync()!;
          if (ISBN.contains(temp)) {
            print("That ISBN already Exist");
          } else {
            ISBN.add(temp);
            Book b = new Book();
            b.addBook();
            BookDetails[temp] = b;
            bookCount++;
            stdout.write(b.Title);
            print(" Added");
          }
        }
        break;

      case 'display book': // Display All
        {
          print("All Books: ");
          for (int a = 0; a < bookCount; a++) {
            stdout.write(ISBN[a] + " - ");
            BookDetails[ISBN[a]].display();
          }
        }
        break;

      case 'display borrowed': // Display Not Available
        {
          print("Borrowed Books: ");
          for (int a = 0; a < bookCount; a++) {
            if (BookDetails[ISBN[a]].available == false) {
              BookDetails[ISBN[a]].display();
            }
          }
        }
        break;

      case 'display available': // Display Available
        {
          print("Available Books");
          for (int a = 0; a < bookCount; a++) {
            if (BookDetails[ISBN[a]].available == true) {
              BookDetails[ISBN[a]].display();
            }
          }
        }
        break;

      case 'add customer':
        {
          var temp = " ";
          stdout.write("Enter Username : ");
          temp = stdin.readLineSync()!;
          if (USERNAME.contains(temp)) {
            print("That Username already Exist");
          } else {
            USERNAME.add(temp);
            Customer c = new Customer();
            c.addCustomer();
            CustomerDetails[temp] = c;
            customerCount++;
            print("$temp Added");
          }
        }
        break;

      case 'display customer': // Display All Customer
        {
          for (int a = 0; a < customerCount; a++) {
            stdout.write("USERNAME: " + USERNAME[a]);
            CustomerDetails[USERNAME[a]].display();
          }
        }
        break;

      case 'borrow':
        {
          var tempUname = " ";
          stdout.write("Enter Username : ");
          tempUname = stdin.readLineSync()!;
          //check if  user name exist
          if (!USERNAME.contains(tempUname)) {
            print("Username doesn't Exist, add customer or review username");
            continue;
          }
          var tempISBN = " ";
          stdout.write("Enter ISBN : ");
          tempISBN = stdin.readLineSync()!;
          //check if book exist
          if (!ISBN.contains(tempISBN)) {
            print("Book doesn't Exist, add book or review ISBN");
            continue;
          }
          //check if book is available
          if (BookDetails[tempISBN].available == false) {
            print("Book is not Available");
            continue;
          }
          BookDetails[tempISBN].available = false;
          CustomerDetails[tempUname].ISBNbooks += tempISBN + " ";
        }
        break;

      case 'return':
        {
          var tempUname = " ";
          stdout.write("Enter Username : ");
          tempUname = stdin.readLineSync()!;
          if (!USERNAME.contains(tempUname)) {
            print("Username doesn't Exist, add customer or review username");
            continue;
          }
          var tempISBN = " ";
          stdout.write("Enter ISBN : ");
          tempISBN = stdin.readLineSync()!;
          if (!ISBN.contains(tempISBN)) {
            print("Book doesn't Exist, add book or review ISBN");
            continue;
          }
          if (BookDetails[tempISBN].available == true) {
            print("Book already on library");
            continue;
          }
          BookDetails[tempISBN].available = true;
          var str = CustomerDetails[tempUname]
              .ISBNbooks
              .replaceAll(tempISBN + " ", "");
          CustomerDetails[tempUname].ISBNbooks = str;
        }
        break;

      case 'commands':
        {
          command();
        }
        break;

      case 'book count':
        {
          print("All books : $bookCount");
          int av = 0;
          for (int a = 0; a < bookCount; a++) {
            if (BookDetails[ISBN[a]].available == true) {
              av++;
            }
          }
          print("Available Books: $av");
          print("Borrowed Books : " + (bookCount - av).toString());
        }
        break;
    }
  } while (choice != "exit");

  UnloadBook();
  UnloadCustomer();
} //main
