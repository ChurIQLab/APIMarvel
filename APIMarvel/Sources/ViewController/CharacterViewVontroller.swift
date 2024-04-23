import UIKit
import Alamofire

final class CharacterViewVontroller: UIViewController {

    // MARK: - Properties

    private var character: Character?
    var resourceURI: String?

    // MARK: - Outlets

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SeriesTableViewCell.self, 
                           forCellReuseIdentifier: SeriesTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchCharacter()
    }

    // MARK: - Networking

    private func fetchCharacter() {
        guard let resourceURI else { return }
        let urlReplacing = resourceURI.replacingOccurrences(of: "http", with: "https")
        let url = "\(urlReplacing)?ts=\(APIConfig.ts)&apikey=\(APIConfig.publicKey)&hash=\(APIConfig.hash)"
        let request = AF.request(url)
        request.responseDecodable(of: Characters.self) { (data) in
            guard let char = data.value else { return }
            self.character = char.data?.results?.first
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

extension CharacterViewVontroller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  character?.series?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesTableViewCell.identifier,
                                                       for: indexPath) as? SeriesTableViewCell else {
            return UITableViewCell()
        }
        if let series = character?.series {
            cell.series = series.items?[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

// MARK: - Delegate

extension CharacterViewVontroller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
