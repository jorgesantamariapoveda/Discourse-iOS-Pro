//
//  UserCollectionViewCell.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 29/05/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class UserCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Properties
    static let cellId: String = String(describing: UserCollectionViewCell.self)

    // MARK: - Life cycle functions
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func prepareForReuse() {
        imageView.image = nil
        nameLabel.text = nil
    }

    // MARK: - Private functions
    private func setupUI() {
        imageView.layer.cornerRadius = 0.5 * imageView.frame.width
        nameLabel.font = .textStyle
        nameLabel.textColor = .black
    }

}
