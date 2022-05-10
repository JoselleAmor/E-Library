import 'dart:io';

class Book {
  String Title = " ";
  String Author = " ";
  String Genre = " ";
  int ID_Borrower = 0;
  bool available = true;

  List genre = [
    "Computer Science",
    "Philosophy",
    "Pure Science",
    "Art and Recreation",
    "History"
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
  List BorrowedBooks = [];

  addCutomer() {
    stdout.write("Name : ");
    Name = stdin.readLineSync()!;
    stdout.write("Address :");
    Address = stdin.readLineSync()!;
  }

  display() {
    stdout.write(" Name: " + Name + " Address: " + Address + " Books : ");
    BorrowedBooks.forEach((e) {
      if (ISBN.contains(e)) {
        stdout.write(BookDetails[e].Title + ", ");
      }
    });
    print(" ");
  }
}

displayOptions() {
  print("********* E-LIBRARY **********");
  print("Command: ");
  print("""
                addbook - Add book in E-Library
                dispAll - Display all books of Library
                dispBorrowed - Display all books that were Borrowed
                dispAvailable - Display all books that are Available
                addCustomer - Add new Customer 
                dispCutomer - Display customer Details
                borrow - Borrow a book
                return - return a book
                commands - print commands
          """);
  print("Genres Available: ");
  print('"Computer Science",\t"Philosophy"');
  print('"Pure Science",\t"History"');
  print('"Art and Recreation"');
}

LoadBook() {
  //Here we load the BookRecord CSV file into memory
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
  //Here we load the the CustomerRecord csv file into Memory
  final CustomerRecord = File("CustomerRecord.csv").readAsLinesSync();
  CustomerRecord.removeAt(0);
  for (var line in CustomerRecord) {
    var v = line.split(',');
    USERNAME.add(v[0]);
    Customer c = new Customer();
    c.Name = v[1];
    c.Address = v[2];
    print(v[3].split(';'));
    c.BorrowedBooks = v[3].split(';');
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
}

var BookDetails = new Map(); //Map for ISBN : Book Object
List ISBN = []; //List for ISBN
int bookCount = 0; //Total Number of Books

var CustomerDetails = new Map(); //Map for customer USERNAME : customerObject
List USERNAME =
    []; // List for customer USERNAME, which is unique in every customer
int customerCount = 0; //Total Number of Customer

main() {
  LoadBook();
  LoadCustomer();
  displayOptions();
  var choice = " ";

  //Here we repeat the process while not exiting
  do {
    stdout.write("Enter Command: ");
    choice = stdin.readLineSync()!;
    switch (choice) {
      case 'addBook': //Add Book Option
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

      case 'dispAll': // Display All
        {
          print("All Books: ");
          for (int a = 0; a < bookCount; a++) {
            stdout.write(ISBN[a] + " - ");
            BookDetails[ISBN[a]].display();
          }
        }
        break;

      case 'dispBorrowed': // Display Not Available
        {
          print("Borrowed Books: ");
          for (int a = 0; a < bookCount; a++) {
            if (BookDetails[ISBN[a]].available == false) {
              BookDetails[ISBN[a]].display();
            }
          }
        }
        break;

      case 'dispAvailable': // Display Available
        {
          print("Available Books");
          for (int a = 0; a < bookCount; a++) {
            if (BookDetails[ISBN[a]].available == true) {
              BookDetails[ISBN[a]].display();
            }
          }
        }
        break;

      case 'addCustomer': // Add New Customer
        {
          var temp = " ";
          stdout.write("Enter Username : ");
          temp = stdin.readLineSync()!;
          if (USERNAME.contains(temp)) {
            print("That Username already Exist");
          } else {
            USERNAME.add(temp);
            Customer c = new Customer();
            c.addCutomer();
            CustomerDetails[temp] = c;
            customerCount++;
            print("$temp Added");
          }
        }
        break;

      case 'dispCustomer': // Display All Customer
        {
          for (int a = 0; a < customerCount; a++) {
            stdout.write("USERNAME: " + USERNAME[a]);
            CustomerDetails[USERNAME[a]].display();
          }
        }
        break;

      case 'borrow': //Borrow Book
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
          CustomerDetails[tempUname].BorrowedBooks.add(tempISBN);
        }
        break;

      case 'return': //Return Book
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
          CustomerDetails[tempUname].BorrowedBooks.remove(tempISBN);
        }
        break;

      case 'clean':
        {
          print("xxx");
        }
        break;

      case 'commands':
        {
          print("""
                addbook - Add book in E-Library
                dispAll - Display all books of Library
                dispBorrowed - Display all books that were Borrowed
                dispAvailable - Display all books that are Available
                addCustomer - Add new Customer 
                dispCutomer - Display customer Details
                borrow - Borrow a book
                return - return a book
                commands - print commands
          """);
        }
        break;

      case 'exit':
        {
          UnloadCustomer();
          UnloadBook();
        }
        break;

      default:
        print("There is no such Command");
        break;
    }
  } while (choice != 'exit');
}
