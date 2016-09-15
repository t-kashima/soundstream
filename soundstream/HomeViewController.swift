//
//  HomeViewController.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var presenter: HomePresenter!
    
    private var soundList: [SoundResourceEntity] = []
    
    @IBOutlet weak var tableView: UITableView!
       
    @IBAction func onClickButtonSearch(sender: AnyObject) {
        presenter.onClickButtonSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(view: self)
        presenter.onViewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        presenter.onViewWillAppear()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SoundCell
        let soundResourceEntity = soundList[indexPath.row]
        cell.initialize(soundResourceEntity)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        presenter.onClickButtonPlay(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        SoundManager.sharedManager.setSoundList(soundList)
    }
    
    func playSound(index: Int) {
        SoundManager.sharedManager.playSound(index)
    }
    
    func navigateToSearch() {
        let storyboard = UIStoryboard(name: "Search", bundle: NSBundle.mainBundle())
        let searchViewController =  storyboard.instantiateInitialViewController() as! SearchViewController
        self.navigationController!.pushViewController(searchViewController, animated: true)
    }
}
