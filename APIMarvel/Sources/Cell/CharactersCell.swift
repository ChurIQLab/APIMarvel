import UIKit
import Alamofire

final class CharactersTableViewCell: UITableViewCell {

    // MARK: - Properties

    var character: Character? {
        didSet {
            guard let character, let thumbnail = character.thumbnail else { return }
            nameLabel.text = character.name

            let path = thumbnail.path.replacingOccurrences(of: "http", with: "https")
            let thumbnailExtension = thumbnail.thumbnailExtension
            let imageURL = URL(string: "\(path).\(thumbnailExtension)")

            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL!) {
                    DispatchQueue.main.async {
                        self.characterImage.image = UIImage(data: imageData)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.characterImage.image = UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
                    }
                }
            }
        }
    }

    // MARK: - Outelts

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initial

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    private func configureView() {
        addSubview(characterImage)
        NSLayoutConstraint.activate([
            characterImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            characterImage.heightAnchor.constraint(equalToConstant: 50),
            characterImage.widthAnchor.constraint(equalToConstant: 50)
        ])

        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: characterImage.trailingAnchor, constant: 10),
        ])
    }

    // MARK: - Prepare
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImage.image = nil
        nameLabel.text = nil
    }
}
