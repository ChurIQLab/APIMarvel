import UIKit
import Alamofire

final class ComicsViewController: UIViewController {

    // MARK: - Properties

    private var characters: Characters?

    // MARK: - Outlets
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CharactersTableViewCell.self,
                           forCellReuseIdentifier: CharactersTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchComics()
    }

    // MARK: - Networking

    private func fetchComics() {
        let url = "https://gateway.marvel.com/v1/public/comics/1332/characters?ts=\(APIConfig.ts)&apikey=\(APIConfig.publicKey)&hash=\(APIConfig.hash)"
        let request = AF.request(url)
        request.responseDecodable(of: Characters.self) { (data) in
            guard let characters = data.value else { return }
            self.characters = characters
            self.title = characters.attributionText
            self.tableView.reloadData()
        }
    }

    // MARK: - Configure

    private func configureView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - DataSource

extension ComicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.data?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.identifier,
                                                       for: indexPath) as? CharactersTableViewCell else {
            return UITableViewCell()
        }
        if let character = self.characters?.data?.results?[indexPath.row] {
            cell.character = character
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

// MARK: - Delegate

extension ComicsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let charController = CharacterViewVontroller()
        if let char = characters?.data?.results?[indexPath.row] {
            charController.title = "Character series \(char.name)"
            charController.resourceURI = char.resourceURI
        }
        navigationController?.pushViewController(charController, animated: true)
    }
}
