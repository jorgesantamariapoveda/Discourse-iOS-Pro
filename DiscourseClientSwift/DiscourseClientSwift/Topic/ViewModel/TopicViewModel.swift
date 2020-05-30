//
//  TopicViewModel.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 30/05/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

struct TopicViewModel: CellViewModel {

    private let id: Int
    private let title: String
    private let postCount: String
    private let numPosters: String
    private let lastPost: String
    private var avatar: String?

    init(topic: Topic) {
        id = topic.id
        title = topic.title
        postCount = "\(topic.postsCount)"
        numPosters = "\(topic.posters.count)"
        lastPost = topic.lastPostedAt.convertStringDateToString(
                        inputFormat: "YYYY-MM-dd'T'HH:mm:ss.SSSZ",
                        outputFormat: "MMM d",
                        identifierLocale: "es_ES",
                        secondsFromGMT: 0) ?? ""
    }

    func getId() -> Int {
        return id
    }

    func getTitle() -> String {
        return title
    }

    func getPostCount() -> String {
        return postCount
    }

    func getNumPosters() -> String {
        return numPosters
    }

    func getLasPost() -> String {
        return lastPost
    }

    mutating func setAvatar(avatar: String) {
        self.avatar = avatar
    }

    func getAvatar() -> String? {
        return avatar
    }

}
