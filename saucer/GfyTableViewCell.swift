//
//  GfyTableViewCell.swift
//  saucer
//
//  Created by Sang Lee on 10/11/15.
//  Copyright © 2015 Sang Lee. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol GfyTableViewCellDelegate {
    func shareGfy(gfyName: String)
}

class GfyTableViewCell: UITableViewCell {
    
    var thisDelegate: GfyTableViewCellDelegate?
    
    let padding: CGFloat = 8
    let screenBounds = UIScreen.mainScreen().bounds
    
    var gfy: GfyModel = GfyModel(title: "", name: "", g_id: "", mp4: "", gif: "", thumbUrl: "", views: 0, nsfw: "", width: 0, height: 0)
    
    var bgView: UIView!
    var imageURL: UIImageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 16, 200))
    var title: UILabel!
    var subtitle: UILabel!
    var views: UILabel!
    var videoPlayer: AVPlayer!
    var videoPlayerItem: AVPlayerItem!
    var videoPlayerLayer: AVPlayerLayer!
    
    var shareButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.whiteColor()
        selectionStyle = .None
        
        bgView = UIView(frame: CGRectMake(padding, 0, screenBounds.size.width - padding*2, 250))
        bgView.layer.cornerRadius = 6
        bgView.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha:0.25).CGColor
        bgView.layer.borderWidth = 0.5
        bgView.clipsToBounds = true
        bgView.backgroundColor = UIColor.whiteColor()
        
        title = UILabel(frame:CGRectMake(10, 210, bgView.frame.width-100, 15))
        title.font = UIFont.boldSystemFontOfSize(12)
        
        subtitle = UILabel(frame:CGRectMake(10, title.frame.maxY + 1, bgView.frame.width-100, 15))
        subtitle.font = UIFont.systemFontOfSize(12)
        subtitle.textColor = UIColor(red:0.32, green:0.28, blue:0.61, alpha:1.0)
        
        views = UILabel(frame: CGRectMake(bgView.frame.width-105, 210, 95, 12))
        views.font = UIFont.systemFontOfSize(12)
        views.textColor = UIColor(red:0.62, green:0.62, blue:0.64, alpha:1.0)
        views.textAlignment = NSTextAlignment.Right
        
        shareButton = UIButton(frame: CGRectMake(bgView.frame.maxX-40, 8, 25, 25))
        shareButton.addTarget(self, action: "share", forControlEvents: UIControlEvents.TouchUpInside)
        shareButton.layer.cornerRadius = 12
        shareButton.clipsToBounds = true
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = shareButton.bounds
        visualEffectView.userInteractionEnabled = false
        shareButton.addSubview(visualEffectView)
        
        let shareIcon = UIImageView(frame: shareButton.bounds)
        shareIcon.image = UIImage(named: "share.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        shareIcon.tintColor = UIColor.whiteColor()
        shareIcon.userInteractionEnabled = false
        shareButton.addSubview(shareIcon)
        
        bgView.addSubview(imageURL)
        bgView.addSubview(shareButton)
        
        bgView.addSubview(title)
        bgView.addSubview(views)
        bgView.addSubview(subtitle)
        
        contentView.addSubview(bgView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title.text = ""
        views.text = ""
        bgView.backgroundColor = UIColor.whiteColor()
        subtitle.text = ""
        imageURL.image = nil
        videoPlayer = nil
        videoPlayerItem = nil
        videoPlayerLayer = nil

    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func share() {
        thisDelegate?.shareGfy(self.gfy.g_name)
    }
    
    func setGfyPlayer(url: NSURL) {
//        print("Adding Video: \(url)")
        
//        videoPlayerItem = AVPlayerItem(URL: url)
//        videoPlayer = AVPlayer(playerItem: videoPlayerItem)
//        videoPlayer.play()
//        
//        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
//        videoPlayerLayer.frame = CGRectMake(0, 0, bgView.frame.width, 200)
//        videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
//        bgView.layer.addSublayer(videoPlayerLayer)
    }

}

//
//        let backgroundView = UIView(frame: CGRectMake(8, 0, cell.contentView.frame.width-16, 250))
//        backgroundView.layer.cornerRadius = 3
//        backgroundView.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha:0.4).CGColor
//        backgroundView.layer.borderWidth = 0.5
//        backgroundView.clipsToBounds = true
//        backgroundView.backgroundColor = UIColor.whiteColor()
//
//        let title = UILabel(frame: CGRectMake(10, 210, backgroundView.frame.width-100, 10))
//        if (self.gfyArray[indexPath.row].title == "") {
//            self.gfyArray[indexPath.row].title = "Untitled"
//        }
//        title.text = self.gfyArray[indexPath.row].title
//        title.font = UIFont.boldSystemFontOfSize(10)
//        backgroundView.addSubview(title)
//
//        let views = UILabel(frame: CGRectMake(cell.contentView.frame.width-120, 210, 95, 10))
//        views.text = String(self.gfyArray[indexPath.row].views)
//        views.font = UIFont.systemFontOfSize(10)
//        views.textColor = UIColor(red:0.62, green:0.62, blue:0.64, alpha:1.0)
//        views.textAlignment = NSTextAlignment.Right
//        backgroundView.addSubview(views)
//
//        let imageURL: UIImageView = UIImageView(frame: CGRectMake(0, 0, backgroundView.frame.width, 200))
//        if let url = NSURL(string: self.gfyArray[indexPath.row].thumbUrl) {
//            if let data = NSData(contentsOfURL: url){
//                imageURL.contentMode = UIViewContentMode.ScaleAspectFill
//                imageURL.image = UIImage(data: data)
//            }
//        }
//
//        cell.contentView.addSubview(backgroundView)
//        backgroundView.addSubview(imageURL)
