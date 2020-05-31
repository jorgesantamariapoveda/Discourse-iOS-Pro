//
//  TopicsViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 20/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class TopicsViewController: UIViewController {

    // MARK: - Properties
    private var cellViewModels: [CellViewModel] = []

    private let plusTopicButton: UIButton = {
        let plusTopicButton = UIButton(type: .custom)
        plusTopicButton.setImage(UIImage(named: "icoNew"), for: .normal)
        plusTopicButton.addTarget(self, action: #selector(plusTopicButtonTapped), for: .touchUpInside)
        return plusTopicButton
    }()
    private var leadingAnchorPlusTopicButton: NSLayoutConstraint?
    private var trailingAnchorPlusTopicButton: NSLayoutConstraint?

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //! Para evitar esto que siempre se ejecuta, lo suyo es montar una notificación
        //! en el momento de cambiar el settings ¿?. Un delegado no me vale porque no
        //! tengo acceso a ese viewController desde aquí
        setupPositionNewTopicButton()
    }

    @objc private func plusTopicButtonTapped() {
        let createTopicVC = CreateTopicViewController()
        createTopicVC.delegate = self

        let navigationController = UINavigationController(rootViewController: createTopicVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

}

// MARK: - Setups
extension TopicsViewController {

    private func setupUI() {
        self.navigationItem.title = "Temas"

        tableView.registerCell(name: WelcomeTopicCell.cellId)
        tableView.registerCell(name: TopicCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(plusTopicButton)
        self.view.sendSubviewToBack(tableView)

        plusTopicButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusTopicButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
//            plusTopicButton.widthAnchor.constraint(equalToConstant: 64),
//            plusTopicButton.heightAnchor.constraint(equalToConstant: 64)
        ])
        leadingAnchorPlusTopicButton = plusTopicButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        trailingAnchorPlusTopicButton = plusTopicButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)

        setupPositionNewTopicButton()
    }

    private func setupPositionNewTopicButton() {
        if UserDefaults.standard.bool(forKey: "Zurdo") {
            leadingAnchorPlusTopicButton?.isActive = true
            trailingAnchorPlusTopicButton?.isActive = false
        } else {
            leadingAnchorPlusTopicButton?.isActive = false
            trailingAnchorPlusTopicButton?.isActive = true
        }
    }

    private func setupData() {
        getLatestTopics { [weak self] (result) in
            // Al acceder a self dentro de un closure si no se especifica nada lo
            // hará de modo strong generando una referencia fuerte e impidiendo
            // que ARC realice su trabajo. Con [weak self] evitamos dicho comportamiento
            switch result {
            case .failure(let error as CustomTypeError):
                print(error.descripcion)
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let latestTopics):
                self?.cellViewModels = latestTopics.topicList.topics.map({ (topic) -> TopicViewModel in
                    var topicViewModel = TopicViewModel(topic: topic)
                    for user in latestTopics.users {
                        if user.username == topic.lastPosterUsername {
                            topicViewModel.setAvatar(avatar: user.avatarTemplate)
                        }
                    }
                    return topicViewModel
                })
                self?.cellViewModels.insert(WelcomeTopicViewModel(), at: 0)
                self?.tableView.reloadData()
            }
        }
    }

}

// MARK: - API operations
extension TopicsViewController {

    private func getLatestTopics(completion: @escaping (Result<LatestTopicsResponse, Error>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        guard let url = URL(string: "https://mdiscourse.keepcoding.io/latest.json") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(kApiKey, forHTTPHeaderField: "Api-Key")
        request.addValue(kApiUserName, forHTTPHeaderField: "Api-Username")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
            if let resp = response as? HTTPURLResponse, resp.statusCode == 200 {
                if let dataset = data {
                    do {
                        let latestTopicsResponse = try JSONDecoder().decode(LatestTopicsResponse.self, from: dataset)
                        DispatchQueue.main.async {
                            completion(.success(latestTopicsResponse))
                        }
                    } catch let errorDecoding as DecodingError {
                        DispatchQueue.main.async {
                            completion(.failure(errorDecoding))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(CustomTypeError.unknowError))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(CustomTypeError.emptyData))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(CustomTypeError.responseError))
                }
            }
        }
        dataTask.resume()
    }

}

// MARK: - UITableViewDataSource
extension TopicsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WelcomeTopicCell.cellId) as? WelcomeTopicCell,
            let _ = cellViewModels[indexPath.row] as? WelcomeTopicViewModel {
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.cellId) as? TopicCell,
            let topic = cellViewModels[indexPath.row] as? TopicViewModel {
            cell.configure(viewModel: topic)
            return cell
        }

        return UITableViewCell()
    }

}

// MARK: - UITableViewDelegate
extension TopicsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let topic = cellViewModels[indexPath.row] as? TopicViewModel {
            let detailTopicVC = DetailTopicsViewController()
            detailTopicVC.delegate = self
            detailTopicVC.setTopic(viewModel: topic)

            navigationController?.pushViewController(detailTopicVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = cellViewModels[indexPath.row] as? WelcomeTopicViewModel {
            return 151
        } else if let _ = cellViewModels[indexPath.row] as? TopicViewModel {
            return 96
        }
        return 0
    }

}

// MARK: - TopicDelegate
extension TopicsViewController: TopicDelegate {

    func newTopic() {
        setupData()
    }
    
    func deleteTopic() {
        setupData()
    }

}
