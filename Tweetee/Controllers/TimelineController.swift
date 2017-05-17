//
//  TimelineController.swift
//  Tweetee
//
//  Created by Vladimir Spasov on 14/5/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON
import AlamofireImage

import RealmSwift



class TimelineController: UITableViewController {

    private struct Storyboard {
        static let TweetWithImage = "TweetCellWithImage"
        static let TweetWithoutImage = "TweetCellWithoutImage"
    }


    @IBOutlet var headerView: UIView!
    @IBOutlet var headerBackgroundView: UIImageView!

    @IBOutlet var headerProfileImage: UIImageView!
    @IBOutlet var headerUserNameLabel: UILabel!
    @IBOutlet var headerScreenNameLabel: UILabel!

    var twitterAPI: TwitterAPI? = nil

    var tweets: [Tweet] = []
    var user: User?

    var isFavorites = false

    @IBAction func toggleFavorites(_ sender: UIButton) {
        isFavorites = !isFavorites
        if (!TwitterAPI.isConnectedToInternet()){
            isFavorites = true
        }
        setupData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        twitterAPI = TwitterAPI.sharedInstance

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        if (!TwitterAPI.isConnectedToInternet()){
            isFavorites = true
        }

        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]


        var cell = TweetTableViewCell()
        if tweet.media.first?.mediaUrl != nil {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetWithImage, for: indexPath) as! TweetTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetWithoutImage, for: indexPath) as! TweetTableViewCell
        }
        cell.tweet = tweet
        if (isFavorites){
            cell.favoritesButton.isHidden = true
        }
        cell.tapAction = { (cell) in
            self.saveToFavorites(tweet: tweet)
        }

        return cell

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfile", let destination = segue.destination as? ProfileViewController {
            if let cell = sender as? TweetTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let tweet = tweets[indexPath.row]

                destination.twitterAPI = twitterAPI
                let id = tweet.user?.id
                let userId = "\(id!)"

                destination.userId = userId
            }
        }
    }


    @IBAction func refresh(_ sender: UIRefreshControl) {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        twitterAPI?.getHomeTimeline(complition: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            sender.endRefreshing()
        })
    }

    func setupData(){
        if (isFavorites){
            setUpDataFromRealm()
        }else{
            setUpDataFtomNet()
        }
    }

    func setUpDataFtomNet(){
        twitterAPI?.getHomeProfile(complition: { (user) in
            self.user = user
            self.saveUser(user: user)
            self.setUpHeader()
        })
        twitterAPI?.getHomeTimeline(complition: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }

    func setUpDataFromRealm() {
        let realm = try! Realm()
        let resultsTweet = realm.objects(Tweet.self)
        let resultsUser = realm.objects(User.self)
        tweets = Array(resultsTweet)
        user = Array(resultsUser).first
        setUpHeader()
        self.tableView.reloadData()
    }


    func setUpHeader(){
        let profileBannerUrl = URL(string: (self.user?.profileBannerUrl!)!)!
        headerBackgroundView.af_setImage(withURL: profileBannerUrl)

        let profileImageUrl = URL(string:(self.user?.profileImageURL)!.replacingOccurrences(of: "_normal", with: ""))
        headerProfileImage.af_setImage(withURL: profileImageUrl!)

        headerUserNameLabel.text = user?.name
        headerScreenNameLabel.text = "@" + (user?.screenName)!
    }

    func saveToFavorites(tweet: Tweet){
        let realm = try! Realm()

        let result = realm.objects(Tweet.self)
        print("Before save tweets: ", result.count)
        try! realm.write {
            realm.add(tweet, update: true)
        }
        print("After save: ", result.count)
    }


    func saveUser(user: User){
        let realm = try! Realm()
        let resultsUser = realm.objects(User.self)
        print("Before save User: ",resultsUser.count)
        try! realm.write {
            realm.add(user, update: true)
        }
        let usersArray = Array(resultsUser)
        let loadedUser = usersArray.first
        print("After save: ",resultsUser.count)
        print("Getting angry")
    }
}



@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

