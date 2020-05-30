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
    private var latestTopics: LatestTopicsResponse?

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    // MARK: - IBActions
    @IBAction func newTopicButtonTapped(_ sender: UIButton) {
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

        tableView.registerCellWithNibName("TopicCell", cellId: TopicCell.cellId)
        tableView.registerCellWithNibName("WelcomeTopicCell", cellId: WelcomeTopicCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
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
                self?.latestTopics = latestTopics
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
        guard let latestTopics = latestTopics else { return 0 }
        return latestTopics.topicList.topics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                                withIdentifier: WelcomeTopicCell.cellId,
                                for: indexPath) as? WelcomeTopicCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                                withIdentifier: TopicCell.cellId,
                                for: indexPath) as? TopicCell else {
                return UITableViewCell()
            }

            //! Mejorar, esto es una chapuza
            if let topic = latestTopics?.topicList.topics[indexPath.row] {
                if let users = latestTopics?.users {
                    for user in users {
                        if user.username == topic.lastPosterUsername {
                            cell.configure(topic: topic, avatar: user.avatarTemplate)
                            return cell
                        }
                    }
                }
            }
        }

        return UITableViewCell()
    }

}

// MARK: - UITableViewDelegate
extension TopicsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //! Chapuza
        if indexPath.row != 0 {
            guard let topic = latestTopics?.topicList.topics[indexPath.row] else { return }

            let detailVC = DetailTopicsViewController()
            detailVC.delegate = self
            detailVC.setTopic(topic)

            navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //! Chapuza
        if indexPath.row == 0 {
            return 151
        } else {
            return 96
        }
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
