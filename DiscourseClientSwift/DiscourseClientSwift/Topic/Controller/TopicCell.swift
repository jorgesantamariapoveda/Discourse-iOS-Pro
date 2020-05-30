//
//  TopicCell.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 29/05/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class TopicCell: UITableViewCell {

    // MARK: - Properties
    static let cellId: String = String(describing: TopicCell.self)
    private var topic: Topic?
    private var avatar: String?

    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleTopicLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var numPostersLabel: UILabel!
    @IBOutlet weak var lastPostLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func prepareForReuse() {
        topic = nil
        avatar = nil

        setupData()
    }

}

// MARK: - Setups
extension TopicCell {

    private func setupUI() {
        avatarImageView.layer.cornerRadius = 0.5 * avatarImageView.frame.width
        titleTopicLabel.font = .textStyle5
        postCountLabel.font = .textStyle3
        numPostersLabel.font = .textStyle3
        lastPostLabel.font = .textStyle3
    }

    private func setupData() {
        if let topic = topic, let _ = avatar {
            titleTopicLabel.text = topic.title
            postCountLabel.text = "\(topic.postsCount)"
            numPostersLabel.text = "\(topic.posters.count)"
            lastPostLabel.text = topic.lastPostedAt.convertStringDateToString(
                            inputFormat: "YYYY-MM-dd'T'HH:mm:ss.SSSZ",
                            outputFormat: "MMM d",
                            identifierLocale: "es_ES",
                            secondsFromGMT: 0)

            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let avatar = self?.avatar else { return }

                //! Mejorar lo del 64
                let avatarWithSize = avatar.replacingOccurrences(of: "{size}", with: "64")
                let pathAvatar = "https://mdiscourse.keepcoding.io\(avatarWithSize)"
                guard let urlAvatar = URL(string: pathAvatar) else { return }

                // Aquí se produce realmente el proceso costoso
                let data = try? Data.init(contentsOf: urlAvatar)
                DispatchQueue.main.async {
                    if let data = data {
                        let image = UIImage(data: data)
                        self?.avatarImageView.image = image
                        //cell.setNeedsLayout()
                    }
                }
            }
        } else {
            titleTopicLabel.text = nil
            postCountLabel.text = nil
            numPostersLabel.text = nil
            lastPostLabel.text = nil
            avatarImageView.image = nil
        }
    }

}

// MARK: - Public functions
extension TopicCell {

    func configure(topic: Topic, avatar: String) {
        self.topic = topic
        self.avatar = avatar

        setupData()
    }
}
