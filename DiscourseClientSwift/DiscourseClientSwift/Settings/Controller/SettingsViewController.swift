//
//  SettingsViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 31/05/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Zurdo", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Diestro", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

        if UserDefaultManager.isLeftHand() {
            segmentedControl.selectedSegmentIndex = 0
        } else {
            segmentedControl.selectedSegmentIndex = 1
        }

        return segmentedControl
    }()

    // MARK: - Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Private functions
    private func setupUI() {
        self.navigationItem.title = "Ajustes"
        self.view.backgroundColor = .gray

        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = .white82

        self.view.addSubview(backgroundView)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10

        stackView.addArrangedSubview(segmentedControl)

        backgroundView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    @objc private func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            UserDefaultManager.setHandType(type: .letfHand)
        } else {
            UserDefaultManager.setHandType(type: .rightHand)
        }
    }
}
