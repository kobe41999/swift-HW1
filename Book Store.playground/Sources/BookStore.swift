import UIKit
import PlaygroundSupport

// We use a `typealias` which marks a tuple as a `Book` type.
public typealias Book = (title: String, author: String, price: Double)


// MARK: - Book Store (Model and Main class)

public struct BookStore {

    public init() {}

    // MARK: Function interfaces

    var totalBookPrice: Double = 0
    var books: [Book] = []
    var authors: [String] = []

    public mutating func setDataSource(priceCalculator totalBookPrice: (() -> Double)) {
        self.totalBookPrice = totalBookPrice()
    }

    public mutating func setDataSource<Authors: Collection>(authorsGetter distinctAuthors: (() -> Authors))
        where Authors.Iterator.Element == String {
            self.authors = distinctAuthors().sorted()
    }

    public mutating func setDataSource(bookGetter: ((Int) -> Book?)) {
        var books = [Book]()
        var index = 0
        while let book = bookGetter(index) {
            defer { index += 1 }
            books.append(book)
        }
        self.books = books
    }

}


// MARK: - Book List (View and Controller)

class BookListViewController: UITableViewController {

    var authors: [String] = []
    var books: [Book] = []
    var totalPrice: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Book Shopping Cart ($\(self.totalPrice))"
    }

    // MARK: Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.authors.count
        case 1:
            return self.books.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Authors"
        case 1:
            return "Books"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "BookCell"
        let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
            UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier))

        if indexPath.section == 0 {
            self.setup(authorCell: cell, at: indexPath.row)
        } else if indexPath.section == 1 {
            self.setup(bookCell: cell, at: indexPath.row)
        }

        return cell
    }

    func setup(authorCell cell: UITableViewCell, at index: Int) {
        cell.textLabel!.text = self.authors[index]
    }

    func setup(bookCell cell: UITableViewCell, at index: Int) {
        let book = self.books[index]
        cell.textLabel!.text = "\(book.title) ($\(book.price))"
        cell.detailTextLabel!.text = book.author
    }

    // MARK: Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
