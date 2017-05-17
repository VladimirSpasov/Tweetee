//
//  ProfileViewController.swift
//  Tweetee
//
//  Created by Vladimir Spasov on 16/5/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//


import UIKit
import OAuthSwift
import SwiftyJSON
import AlamofireImage


class ProfileViewController: UIViewController{
    var twitterAPI: TwitterAPI? = nil
    var userId: String?
    var user: User?

    @IBOutlet var profileBannerImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var webPageLabel: UILabel!
    
    @IBOutlet var tweetsCount: UILabel!
    @IBOutlet var followingCount: UILabel!
    @IBOutlet var followersCount: UILabel!
    @IBOutlet var likesCount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        twitterAPI?.getProfile(id: (userId)!, complition: { (user) in
            self.user = user
            self.updateUI()
        })
    }

    func updateUI(){
        let profileBannerUrl = URL(string: (self.user?.profileBannerUrl!)!)!
        profileBannerImageView.af_setImage(withURL: profileBannerUrl)

        let profileImageUrl = URL(string:(self.user?.profileImageURL)!.replacingOccurrences(of: "_normal", with: ""))
        profileImageView.af_setImage(withURL: profileImageUrl!)

        nameLabel.text = user?.name
        screenNameLabel.text = "@" + (user?.screenName)!
        descriptionLabel.text = user?.resumee
        locationLabel.text = user?.location

        tweetsCount.text = user?.tweetsCount.formatUsingAbbrevation()
        followingCount.text = user?.followCount.formatUsingAbbrevation()
        followersCount.text = user?.followersCount.formatUsingAbbrevation()
        likesCount.text = user?.likesCount.formatUsingAbbrevation()
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension Int {

    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()

        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]

        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()

        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        return numFormatter.string(from: NSNumber (value:value))!
    }

}
