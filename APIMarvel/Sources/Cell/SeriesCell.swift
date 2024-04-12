import UIKit
import Alamofire

final class SeriesTableViewCell: UITableViewCell {

    // MARK: - Properties

    var series: Items? {
        didSet {
            guard let series else { return }
            nameSeriesLabel.text =  series.name
            linkLabel.text = "Link: \(series.resourceURI)"
        }
    }

    // MARK: - Outelts

    private lazy var nameSeriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .blue
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initial
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    private func configureView() {
        let indent: CGFloat = 10

        addSubview(nameSeriesLabel)
        NSLayoutConstraint.activate([
            nameSeriesLabel.topAnchor.constraint(equalTo: topAnchor, constant: indent),
            nameSeriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: indent)
        ])

        addSubview(linkLabel)
        NSLayoutConstraint.activate([
            linkLabel.topAnchor.constraint(equalTo: nameSeriesLabel.bottomAnchor, constant: indent),
            linkLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: indent)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        linkLabel.addGestureRecognizer(tapGesture)
    }

    // MARK: - Actions

    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let urlString = series?.resourceURI else { return }
        print("A page would open here at the address: \(urlString)")
    }


    // MARK: - Prepare

    override func prepareForReuse() {
        super.prepareForReuse()
        nameSeriesLabel.text = nil
        linkLabel.text = nil
    }
}
