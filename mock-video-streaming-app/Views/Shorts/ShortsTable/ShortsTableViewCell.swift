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
        
        var videoUrl: URL? {
            URL(string: short.videoUrl)
        }
    }
    
    private var vm: ViewModel?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 8
        return stackView
    }()
    private var authorContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
    
    private var videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    private var videoThumbnailImageTask: Task<Void, Error>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    override func prepareForReuse() {
        videoThumbnailImageTask?.cancel()
        authorImageTask?.cancel()
        stopVideo()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        debugPrint("Reuse")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout() {
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Author
        authorAvatarImageView.setContentHuggingPriority(UILayoutPriority(260), for: .horizontal)
        authorInfoStackView.addArrangedSubview(authorNameLabel)
        authorInfoStackView.addArrangedSubview(authorTagLabel)
        authorContainerStackView.addArrangedSubview(authorAvatarImageView)
        authorContainerStackView.addArrangedSubview(authorInfoStackView)
        
        containerStackView.addArrangedSubview(authorContainerStackView)
        containerStackView.addArrangedSubview(videoImageView)
        contentView.addSubview(containerStackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            authorAvatarImageView.widthAnchor.constraint(equalToConstant: 47),
            authorAvatarImageView.heightAnchor.constraint(equalToConstant: 47),
            videoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            contentView.bottomAnchor.constraint(equalTo: videoImageView.bottomAnchor),
            containerStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            
        ])
        
        authorContainerStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 52).isActive = true
        containerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.currentSize.height * 0.6).isActive = true
        
    }
    
    func configure(with vm: ViewModel) {
        self.vm = vm
        configureAuthorInfo(with: vm.short.author)
        configureVideoPlayer()
        configureThumbnail(with: URL(string: vm.short.thumbnailUrl)!)
    }
    
    func stopVideo() {
        player?.pause()
        
        /// Optimize AVPlayer in tables once cell not visible
        /// https://developer.apple.com/forums/thread/649810
        playerLayer?.removeFromSuperlayer()
        
        /// Take last snapshot before stop, and set it to videoThumbnailImageView
    }
    
    func playVideo() {
        guard let player, let playerLayer else { return }
        videoImageView.layer.addSublayer(playerLayer)
        player.play()
        
        // TODO: Optimal video quality after some period after playing
        //        player?.observe(<#T##keyPath: KeyPath<AVPlayer, Value>##KeyPath<AVPlayer, Value>#>, changeHandler: <#T##(AVPlayer, NSKeyValueObservedChange<Value>) -> Void#>)
    }
    
    /** https://stackoverflow.com/a/40551073 **/
//    private func getThumbnail(videoUrl url: URL) async -> UIImage? {
//        let player = AVPlayer(url: url)
//        guard let asset = player.currentItem?.asset else {
//            return nil
//        }
//        let imageGenerator = AVAssetImageGenerator(asset: asset)
//        imageGenerator.appliesPreferredTrackTransform = true
//        imageGenerator.requestedTimeToleranceBefore = .zero
//        imageGenerator.requestedTimeToleranceAfter = CMTime(seconds: 3, preferredTimescale: 600)
//        do {
//            let image = try await imageGenerator.image(at: player.currentTime()).image
//            return UIImage(cgImage: image)
//        } catch {
//            debugPrint(String(describing: error))
//            return nil
//        }
//    }
    
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
            
            await MainActor.run {
                authorAvatarImageView.image = image.resize(newSize: authorAvatarImageView.frame.size)
            }
        }
    }
    
    private func configureThumbnail(with thumbnailUrl: URL) {
        authorImageTask = Task {
            let request = URLRequest(url: thumbnailUrl)
            let result = try? await URLSession.shared.data(for: request)
            guard let result,
                  let image = UIImage(data: result.0)
            else { return }
            
            await MainActor.run {
                videoImageView.image = image.resize(
                    newSize: videoImageView.bounds.size
                )
            }
        }
    }
    
    private func configureVideoPlayer() {
        guard player == nil, playerLayer == nil else { return }
        guard let vm, let videoUrl = vm.videoUrl else { return }
        player = AVPlayer(url: videoUrl)
        player?.currentItem?.preferredPeakBitRate = 1400
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = .resizeAspectFill
        playerLayer!.frame = videoImageView.bounds
    }
}
