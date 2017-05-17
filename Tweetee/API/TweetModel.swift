//
//  TweetModel.swift
//  Tweetee
//
//  Created by Vladimir Spasov on 14/5/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Tweet: Object, Mappable {
    dynamic var id = 0
    dynamic var text: String?
    dynamic var user: User?
    dynamic var created: String?
    var media = List<MediaItem>()

    override static func primaryKey() -> String? {
        return "id"
    }

    required convenience init?(map: Map) {
        self.init()
    }


    func mapping(map: Map) {
        id <- map["id"]
        text <- map["text"]
        user <-  map["user"]
        created <- map["created_at"]
        media <- map["entities.media"]

    }
}

class User: Object, Mappable{
    dynamic var id = 0
    dynamic var name: String?
    dynamic var screenName: String?
    dynamic var resumee: String?
    dynamic var profileImageURL: String?
    dynamic var profileBannerUrl: String?
    dynamic var location: String?

    var urls = List<urlItem>()

    dynamic var createdAt: String?

    dynamic var followCount = 0
    dynamic var followersCount = 0
    dynamic var likesCount = 0
    dynamic var tweetsCount = 0


    override static func primaryKey() -> String? {
        return "id"
    }

    required convenience init?(map: Map) {
        self.init()
    }


    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        screenName <- map["screen_name"]
        profileImageURL <- map["profile_image_url_https"]
        profileBannerUrl <- map["profile_banner_url"]
        resumee <- map["description"]
        location <- map["location"]

        urls <- map["entities.url.urls"]

        createdAt <- map["created_at"]
        followCount <- map["friends_count"]
        followersCount <- map["followers_count"]
        tweetsCount <- map["statuses_count"]
        likesCount <- map["favourites_count"]
    }
}

class MediaItem: Object, Mappable {
    dynamic var id = 0
    dynamic var mediaUrl: String?

    required convenience init?(map: Map) {
        self.init()
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    func mapping(map: Map) {
        id <- map["id"]
        mediaUrl <- map["media_url"]

    }
}

class urlItem: Object, Mappable {
    dynamic var id = 0
    dynamic var displayUrl: String?

    override static func primaryKey() -> String? {
        return "id"
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        displayUrl <- map["display_url"]
        
    }
    
}
