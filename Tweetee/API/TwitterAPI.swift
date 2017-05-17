//
//  TwitterAPI.swift
//  Tweetee
//
//  Created by Vladimir Spasov on 14/5/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
import SwiftyJSON
import Locksmith

import AlamofireObjectMapper

class TwitterAPI{

    static let sharedInstance = TwitterAPI()

    var oAuthSwift: OAuth1Swift?

    let homeTimelineUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    let profileUrl = "https://api.twitter.com/1.1/users/show.json?include_entities=true&user_id="
    let userUrl = "https://userstream.twitter.com/1.1/user.json"
    let homeProfileUrl = "https://api.twitter.com/1.1/account/verify_credentials.json"

    private init() {
        setUpOAuth()
    }

    func setUpOAuth(){
        let tweeterCredentials = TwitterAPI.getTweeterCredentials()

        oAuthSwift = OAuth1Swift(
            consumerKey:    tweeterCredentials["consumerKey"]!,
            consumerSecret: tweeterCredentials["consumerSecret"]!,
            requestTokenUrl: tweeterCredentials["requestTokenUrl"]!,
            authorizeUrl:    tweeterCredentials["authorizeUrl"]!,
            accessTokenUrl:  tweeterCredentials["accessTokenUrl"]!
        )

        let keyChainSecrets = TwitterAPI.getKeyChainSecrets()
        oAuthSwift?.client.credential.oauthToken = (keyChainSecrets?["oauth_token"]!)!
        oAuthSwift?.client.credential.oauthTokenSecret = (keyChainSecrets?["oauth_token_secret"]!)!

    }



    func initWithOauth(oAuth: OAuth1Swift){
        oAuthSwift = oAuth
    }

    func getHomeTimeline(complition: @escaping ([Tweet]) -> Swift.Void){
        let sessionManager = SessionManager.default
        sessionManager.adapter = oAuthSwift?.requestAdapter

        sessionManager.request(homeTimelineUrl).responseArray{ (response: DataResponse<[Tweet]>) in
            if((response.result.value) != nil) {
                let tweetsArray = response.result.value
                complition(tweetsArray!)
            }
        }
    }

    func getHomeProfile(complition: @escaping (User) -> Swift.Void){
        let sessionManager = SessionManager.default
        sessionManager.adapter = oAuthSwift?.requestAdapter

        sessionManager.request(homeProfileUrl).responseObject{ (response: DataResponse<User>) in
            if((response.result.value) != nil) {
                let user = response.result.value
                complition(user!)
            }
            }
    }

    func getProfile(id: String, complition: @escaping (User) -> Swift.Void){
        let sessionManager = SessionManager.default
        sessionManager.adapter = oAuthSwift?.requestAdapter

        sessionManager.request(profileUrl + id).responseObject{ (response: DataResponse<User>) in
            if((response.result.value) != nil) {
                let user = response.result.value
                complition(user!)
            }
            }.responseJSON{ response in
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                }
            }
    }

    class func getKeyChainSecrets() -> [Swift.String: Swift.String]?{
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "twitterData") as? [Swift.String: Swift.String]
            else {

                return nil
        }
        return dictionary
    }

    class func getTweeterCredentials() -> [Swift.String: Swift.String]{
        guard let path = Bundle.main.path(forResource: "oAuthTwitter", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
            let oAuthDictionary = dictionary["VSDTweeter"] as? [Swift.String: Swift.String]
            else {
                fatalError("Please  make sure oAuthTwitter.plist exists and has your credentials")
        }
        return oAuthDictionary
    }

    class func hasTokken() -> Bool{
        return TwitterAPI.getKeyChainSecrets() != nil ? true:false
    }

    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }

}



