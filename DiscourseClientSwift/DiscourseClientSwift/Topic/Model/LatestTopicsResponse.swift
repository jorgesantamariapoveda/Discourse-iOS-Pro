//
//  LatestTopics.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 21/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

// Se modela lo estrictamente necesario

struct LatestTopicsResponse: Decodable {
    let users: [UserTopic]
    let topicList: TopicList

    enum CodingKeys: String, CodingKey {
        case users
        case topicList = "topic_list"
    }
}

struct UserTopic: Decodable {
    let username: String
    let avatarTemplate: String

    enum CodingKeys: String, CodingKey {
        case username
        case avatarTemplate = "avatar_template"
    }
}

struct TopicList: Decodable {
    let topics: [Topic]
}

struct Topic: Decodable {
    let id: Int
    let title: String
    let postsCount: Int
    let lastPostedAt: String
    let lastPosterUsername: String
    let posters: [Poster]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case postsCount = "posts_count"
        case lastPostedAt = "last_posted_at"
        case lastPosterUsername = "last_poster_username"
        case posters
    }
}

struct Poster: Decodable {
}
