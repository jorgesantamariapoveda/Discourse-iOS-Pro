//
//  WelcomeTopicCell.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 30/05/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class WelcomeTopicCell: UITableViewCell {

    // MARK: - Properties
    static let cellId: String = String(describing: WelcomeTopicCell.self)

    // MARK: - IBOutlets
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

}

// MARK: - Setups
extension WelcomeTopicCell {

    private func setupUI() {
        background.layer.cornerRadius = 8
        welcomeLabel.font = .textStyle4
        descriptionLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }

}
