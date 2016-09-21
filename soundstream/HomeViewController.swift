//
//  HomeViewController.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var presenter: HomePresenter!
    
    private var soundList: [SoundPlayStateEntity] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var soundPlayStateView: SoundPlayStateView!
       
    @IBAction func onClickButtonSearch(sender: AnyObject) {
        presenter.onClickButtonSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(view: self)
        presenter.onViewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SoundCell
        let soundPlayStateEntity = soundList[indexPath.row]
        cell.initialize(soundPlayStateEntity, presenter: presenter)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        presenter.onClickButtonPlay(soundList[indexPath.row].soundEntity)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension HomeViewController: HomeViewProtocol {
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setSoundList(soundList: [SoundEntity]) {
        self.soundList.removeAll()
        self.soundList.appendContentsOf(soundList.map { SoundPlayStateEntity(isPlaying: false, soundEntity: $0) })
        tableView.reloadData()
        SoundManager.sharedManager.setSoundList(soundList)
    }
    
    func playSound(soundEntity: SoundEntity) {
        SoundManager.sharedManager.playSound(soundEntity)
    }
    
    func navigateToSearch() {
        let storyboard = UIStoryboard(name: "Search", bundle: NSBundle.mainBundle())
        let searchViewController =  storyboard.instantiateInitialViewController() as! SearchViewController
        self.navigationController!.pushViewController(searchViewController, animated: true)
    }
    
    func onChangePlayingSound(soundEntity: SoundEntity) {
        soundList.forEach {
            if ($0.soundEntity.id == soundEntity.id) {
                $0.isPlaying = true
            } else {
                $0.isPlaying = false
            }
        }
        tableView.reloadData()
        
        soundPlayStateView.prepareSound(soundEntity)
    }
    
    func onStopSound() {
        soundList.forEach {
            $0.isPlaying = false
        }
        tableView.reloadData()
        
        soundPlayStateView.stopSound()
    }
    
    func onPauseSound() {
        soundPlayStateView.pauseSound()
    }
    
    func onResumeSound() {
        soundPlayStateView.resumeSound()
    }
    
    func onSetCurrentTime(currentTime: Int) {
        soundPlayStateView.setCurrentTime(currentTime)
    }
    
    func onSetDuration(duration: Int) {
        soundPlayStateView.setDuration(duration)
        soundPlayStateView.playSound()
    }
    
    func showSoundDetail(soundEntity: SoundEntity) {
        let alertSheet = UIAlertController(title: soundEntity.resourceEntity.title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let actionDelete = UIAlertAction(title: "delete", style: UIAlertActionStyle.Destructive, handler: {
            (action: UIAlertAction!) in
            self.presenter.onClickActionDelete(soundEntity)
        })
        let actionCancel = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertSheet.addAction(actionDelete)
        alertSheet.addAction(actionCancel)
        self.presentViewController(alertSheet, animated: true, completion: nil)
    }
    
    func showNetworkError() {
        let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 0
        SVProgressHUD.setOffsetFromCenter(UIOffsetMake(0, heightNavigationBar))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.showErrorWithStatus("通信に失敗しました")
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            SVProgressHUD.dismiss()
        })
    }
}
