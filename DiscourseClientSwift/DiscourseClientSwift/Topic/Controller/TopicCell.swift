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
    private var viewModel: TopicViewModel?
    static let cellId: String = String(describing: TopicCell.self)

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
        viewModel = nil

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
        if let model = viewModel {
            titleTopicLabel.text = model.getTitle()
            postCountLabel.text = model.getPostCount()
            numPostersLabel.text = model.getNumPosters()
            lastPostLabel.text = model.getLasPost()

            let sizeImage = avatarImageView.frame.width
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let avatar = self?.viewModel?.getAvatar() else { return }

                //! Mejorar lo del 64
                let avatarWithSize = avatar.replacingOccurrences(of: "{size}", with: "\(sizeImage)")
                let pathAvatar = "https://mdiscourse.keepcoding.io\(avatarWithSize)"
                guard let urlAvatar = URL(string: pathAvatar) else { return }

                // Aquí se produce realmente el proceso costoso
                let data = try? Data.init(contentsOf: urlAvatar)
                DispatchQueue.main.async {
                    if let data = data {
                        self?.avatarImageView.image = UIImage(data: data)
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

    func configure(viewModel: TopicViewModel) {
        self.viewModel = viewModel

        setupData()
    }
}
