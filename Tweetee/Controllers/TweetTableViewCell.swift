//
//  TimelineCell.swift
//  Tweetee
//
//  Created by Vladimir Spasov on 14/5/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit
import AlamofireImage
import Atributika


class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!

    @IBAction func favouritesButtonTapped(_ sender: UIButton) {
        tapAction?(self)
    }
    @IBOutlet var favoritesButton: UIButton!

    var tapAction: ((UITableViewCell) -> Void)?


    private func updateUI()
    {
        //configure the tweet here
        //reset existing tweet info
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil

        if let tweet = self.tweet {
            let tweetText = tweet.text
            let linkType: NSTextCheckingResult.CheckingType = [.link]
            let attributedTweetText = tweetText!
                .styleHashtags(Style.foregroundColor(.blue))
                .styleMentions(Style.foregroundColor(.blue))
                .style(textCheckingTypes: linkType.rawValue, style: Style.foregroundColor(.blue))
                .attributedString

            tweetTextLabel.attributedText = attributedTweetText

            //usernames
            let screenName = tweet.user?.screenName!
            let name = tweet.user?.name!

            tweetScreenNameLabel?.text = "@\(screenName!) (\(name!))"

            if let profileImageURL = tweet.user?.profileImageURL {
                setImage(imageView: tweetProfileImageView, urlString: profileImageURL)
            }

             if let tweetImageURL = tweet.media.first?.mediaUrl {
                setImage(imageView: tweetImageView, urlString: tweetImageURL)
            }
        }
    }

    func setImage(imageView: UIImageView, urlString:String)
    {
        let url = URL(string: urlString)!
        //let placeholderImage = UIImage(named: "placeholder")!

        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: imageView.frame.size,
            radius: 25.0
        )

        imageView.af_setImage(
            withURL: url,
            placeholderImage: nil,
            filter: filter,
            imageTransition: .crossDissolve(0.2)
        )
    }

}
