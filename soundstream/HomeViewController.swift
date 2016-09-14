//
//  HomeViewController.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate {
    
    private var presenter: HomePresenter!
    
    private var soundList: [SoundResourceEntity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    private var player: AVAudioPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(view: self)
        presenter.onViewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SoundCell
        let soundResourceEntity = soundList[indexPath.row]
        cell.initialize(soundResourceEntity, presenter: presenter)
        return cell
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (flag) {
            presenter.onFinishPlayingSound()
        }
    }
}

extension HomeViewController: HomeViewProtocol {
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setSoundList(soundList: [SoundResourceEntity]) {
        self.soundList.removeAll()
        self.soundList.appendContentsOf(soundList)
        tableView.reloadData()
    }
    
    func playSound(soundResourceEntity: SoundResourceEntity) {
        // 再生中の曲を止める
        if (player != nil) {
            player!.stop()
            player = nil
        }
        
        let soundUrl = NSURL(string: soundResourceEntity.getStreamingSoundUrl())
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(soundUrl!, completionHandler: { (data, resp, err) in
            do {
                self.player = try AVAudioPlayer(data: data!)
                self.player!.delegate = self
                self.player!.play()
            } catch {
                print("Failure sound streaming...")
            }
        })
        task.resume()
    }
}
