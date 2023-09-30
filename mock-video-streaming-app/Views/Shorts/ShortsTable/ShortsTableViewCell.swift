//
//  ShortsTableViewCell.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import UIKit
import AVFoundation

class ShortsTableViewCell: UITableViewCell {
    
    static let identifier = "ShortsTableViewCell"
    
    struct ViewModel {
        let short: Short
    }
    
    private var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
    
    private var videoThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        videoThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Author
        authorAvatarImageView.setContentHuggingPriority(UILayoutPriority(260), for: .horizontal)
        authorInfoStackView.addArrangedSubview(authorNameLabel)
        authorInfoStackView.addArrangedSubview(authorTagLabel)
        authorContainerStackView.addArrangedSubview(authorAvatarImageView)
        authorContainerStackView.addArrangedSubview(authorInfoStackView)
        
        containerStackView.addArrangedSubview(authorContainerStackView)
        containerStackView.addArrangedSubview(videoThumbnailImageView)
        contentView.addSubview(containerStackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            authorAvatarImageView.widthAnchor.constraint(equalToConstant: 47),
            authorAvatarImageView.heightAnchor.constraint(equalToConstant: 47),
            authorContainerStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            videoThumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            videoThumbnailImageView.topAnchor.constraint(equalTo: authorContainerStackView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: videoThumbnailImageView.bottomAnchor, multiplier: 1),
            containerStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: containerStackView.bottomAnchor, multiplier: 1),
        ])
        authorContainerStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 52).isActive = true
        containerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.currentSize.height * 0.6).isActive = true
        
    }
    
    func configure(with vm: ViewModel) {
        configureAuthorInfo(with: vm.short.author)
        configureVideo(with: URL(string: vm.short.videoUrl)!)
    }
    
    /** https://stackoverflow.com/a/40551073 **/
    private func getThumbnail(videoUrl url: URL) async -> UIImage? {
        let player = AVPlayer(url: url)
        guard let asset = player.currentItem?.asset else {
            return nil
        }
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = CMTime(seconds: 3, preferredTimescale: 600)
        do {
            let image = try await imageGenerator.image(at: player.currentTime()).image
            return UIImage(cgImage: image)
        } catch {
            debugPrint(String(describing: error))
            return nil
        }
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
            authorAvatarImageView.image = image.resize(newSize: authorAvatarImageView.frame.size)
        }
    }
    
    private func configureVideo(with videoUrl: URL) {
        Task(priority: .background) {
            let thumbnail = await getThumbnail(videoUrl: videoUrl)
            guard let thumbnail else { return }
            await MainActor.run {
                videoThumbnailImageView.image = thumbnail.resize(
                    newSize: videoThumbnailImageView.bounds.size
                )
            }
        }
    }
}
