//
//  ShortsTableViewCell.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import UIKit

class ShortsTableViewCell: UITableViewCell {
    
    static let identifier = "ShortsTableViewCell"
    
    struct ViewModel {
        let short: Short
    }
    
    private var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        return stackView
    }()
    private var authorContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private var authorInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    private var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    private var authorTagLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    private var authorAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 47, height: 47))
        imageView.image = UIImage(systemName: "photo")
        imageView.asCircle()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var authorImageTask: Task<Void, Error>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Author
        authorAvatarImageView.setContentHuggingPriority(UILayoutPriority(260), for: .horizontal)
        authorInfoStackView.addArrangedSubview(authorNameLabel)
        authorInfoStackView.addArrangedSubview(authorTagLabel)
        authorContainerStackView.addArrangedSubview(authorAvatarImageView)
        authorContainerStackView.addArrangedSubview(authorInfoStackView)
        
        containerStackView.addArrangedSubview(authorContainerStackView)
        contentView.addSubview(containerStackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            authorAvatarImageView.widthAnchor.constraint(equalToConstant: 47),
            authorAvatarImageView.heightAnchor.constraint(equalToConstant: 47),
            authorContainerStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: containerStackView.bottomAnchor, multiplier: 1),
        ])
        authorContainerStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 52).isActive = true
        containerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        
    }
    
    func configure(with vm: ViewModel) {
        configureAuthorInfo(with: vm.short.author)
    }
    
    private func configureAuthorInfo(with author: Author) {
        authorNameLabel.text = author.username
        authorTagLabel.text = author.tagline ?? ""
        guard let authorAvatarUrl = URL(string: author.avatar) else { return }
        authorImageTask = Task {
            let request = URLRequest(url: authorAvatarUrl)
            let result = try? await URLSession.shared.data(for: request)
            guard let result,
                  let image = UIImage(data: result.0)
            else { return }
            // TODO: Downsampling image before add into view
            authorAvatarImageView.image = image
        }
    }
}
