//
//  ViewController.swift
//  Tweetee
//
//  Created by Vladimir Spasov on 14/5/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit
import OAuthSwift
import Locksmith
import RealmSwift

class ViewController: OAuthViewController {

    var oAuthSwift: OAuth1Swift?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var logInButton: UIButton!
    @IBOutlet var logOutButton: UIButton!

    @IBAction func doOAuthTwitter(_ sender: UIButton) {
        let tweeterCredentials = TwitterAPI.getTweeterCredentials()
        oAuthSwift = OAuth1Swift(
            consumerKey: tweeterCredentials["consumerKey"]!,
            consumerSecret: tweeterCredentials["consumerSecret"]!,
            requestTokenUrl: tweeterCredentials["requestTokenUrl"]!,
            authorizeUrl: tweeterCredentials["authorizeUrl"]!,
            accessTokenUrl: tweeterCredentials["accessTokenUrl"]!
        )


        oAuthSwift?.authorizeURLHandler =  OAuthSwiftOpenURLExternally.sharedInstance
        let _ = oAuthSwift?.authorize(
            withCallbackURL: URL(string: "tweetee://oauth-callback/twitter")!,
            success: { credential, response, parameters in

                try! Locksmith.updateData(data: ["oauth_token": credential.oauthToken, "oauth_token_secret": credential.oauthTokenSecret], forUserAccount: "twitterData")
                self.tabBarController?.tabBar.items?[0].isEnabled = true
                self.tabBarController?.selectedIndex = 0;
        },
            failure: { error in
                print(error.description)
        }
        )
    }

    @IBAction func doLogin(_ sender: UIButton) {
        try! Locksmith.deleteDataForUserAccount(userAccount: "twitterData")
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        logInButton.isUserInteractionEnabled = true
        logOutButton.isUserInteractionEnabled = false

    }



}


