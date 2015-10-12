//
//  ViewController.swift
//  saucer
//
//  Created by Sang Lee on 10/10/15.
//  Copyright © 2015 Sang Lee. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GfyTableViewCellDelegate {

    let networkInterface: GfyNetwork = GfyNetwork()
    
    var gfyArray: Array<GfyModel> = []
    var tableView: UITableView = UITableView()
    var playerViewController: AVPlayerViewController!
    
    var imageCache = [String:UIImage]()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // NavigationBar Setup
        self.title = "Discover"
        let navbar = self.navigationController!.navigationBar
        navbar.tintColor = UIColor(red:0.32, green:0.28, blue:0.61, alpha:1.0)
        let searchButton = UIButton(frame: CGRectMake(0, 0, 24, 24))
        searchButton.setImage(UIImage(named: "searchIcon.png"), forState: UIControlState.Normal)
        searchButton.addTarget(self, action: "searchButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let searchButtonInNavbar = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchButtonInNavbar
        
        networkInterface.getTrendingGfys("", completionHandler: updateGfys)
        
        // TableView Setup
        tableView.frame          = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        tableView.delegate       = self
        tableView.dataSource     = self
        tableView.separatorStyle = .None
        tableView.rowHeight      = 260
        tableView.contentInset   = UIEdgeInsetsMake(10, 0, 10, 0)
        tableView.registerClass(GfyTableViewCell.self, forCellReuseIdentifier: "gfycell")
        self.view.addSubview(tableView)
        
        // Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            // let tableView = scrollView as! UITableView
            print("GFY_CURSOR: \(GFY_CURSOR)")
            self.networkInterface.getTrendingGfys(GFY_CURSOR, completionHandler: self.updateGfys)
        }
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        networkInterface.getTrendingGfys("", completionHandler: refreshGfys)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGfys(gfyJSON: Array<GfyModel>) -> Array<GfyModel> {
        // Array of fetched gfys
        self.gfyArray.appendContentsOf(gfyJSON)
        // Update Tableview
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.tableView.finishInfiniteScroll()
        }
        return gfyJSON
    }
    
    func refreshGfys(gfyJSON: Array<GfyModel>) -> Array<GfyModel> {
        // Array of fetched gfys
        self.gfyArray = gfyJSON
        // Update Tableview
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        return gfyJSON
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gfyArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("gfycell", forIndexPath: indexPath) as? GfyTableViewCell else { fatalError("unexpected cell dequeued from tableView") }
        cell.contentView.frame = CGRectMake(0, 0, self.tableView.frame.width, 260)
        cell.gfy = self.gfyArray[indexPath.row]
        
        cell.subtitle.text = cell.gfy.g_name
        cell.views.text = "\(cell.gfy.views) Views"
        if (cell.gfy.title == "") {
            cell.title.text = "Untitled"
        } else {
            cell.title.text = cell.gfy.title
        }
        
        let urlString = self.gfyArray[indexPath.row].thumbUrl
        
        if let url = NSURL(string: urlString) {
            if let gfyImage = imageCache[urlString] {
                cell.imageURL.contentMode = UIViewContentMode.ScaleAspectFill
                cell.imageURL.image = gfyImage
            } else {
                getDataFromUrl(url) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        print("Finished downloading \"\(url.URLByDeletingPathExtension!.lastPathComponent!)\".")
                        let gfyThumb = UIImage(data: data)
                        cell.imageURL.contentMode = UIViewContentMode.ScaleAspectFill
                        cell.imageURL.image = gfyThumb
                        self.imageCache[urlString] = gfyThumb
                    }
                }
            }
        }
        
        cell.setGfyPlayer(NSURL(string: cell.gfy.mp4Url)!)
        cell.thisDelegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? GfyTableViewCell
        cell!.bgView.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.96, alpha:1.0)
        showVideoVC(NSURL(string: self.gfyArray[indexPath.row].mp4Url)!)
        
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            cell!.bgView.backgroundColor = UIColor.whiteColor()
        })
    }
    
    
    func showVideoVC(url: NSURL) {
        let player = AVPlayer(URL: url)
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }
    }
    
    func searchButtonPressed(sender: AnyObject?) {
        print("search tapped")
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func shareGfy(gfyName: String) {
        let gfyUrl: NSURL = NSURL(string: "http://gfycat.com/\(gfyName)")!
        let shareString: String = " via @SaucerApp #gfycat"
        
        let activityViewController = UIActivityViewController(activityItems: [shareString, gfyUrl], applicationActivities: nil)
        navigationController?.presentViewController(activityViewController, animated: true) {
            
        }
    }
}
