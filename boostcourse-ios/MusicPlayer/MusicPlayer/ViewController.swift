//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 조기현 on 2020/07/05.
//  Copyright © 2020 gicho. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

	// MARK:- Variables -
	var player: AVAudioPlayer!
	var timer: Timer!
	
	// MARK: IBOutlet
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var progressBar: UISlider!
	
	// MARK:- Methods -
	func initAudioPlayer() {
		guard let soundAsset = NSDataAsset(name: "sound") else {
			print("data error")
			return
		}
		
		do {
			try player = AVAudioPlayer(data: soundAsset.data)
			player.delegate = self
		} catch let error as NSError {
			print("\(error.localizedDescription)")
		}
		
		progressBar.minimumValue = 0
		progressBar.maximumValue = Float(self.player.duration)
		progressBar.value = 0.0
	}
	
	func updateTimeLabel(_ time: TimeInterval) {
		let minute = Int(time / 60)
		let second = Int(time.truncatingRemainder(dividingBy: 60))
		let milisecond = Int(time.truncatingRemainder(dividingBy: 1) * 100)
		timeLabel.text = String(format: "%02d:%02d:%02d", minute, second, milisecond)
	}
	
	func fireTimer() {
		timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {
			[unowned self] timer in
			if self.progressBar.isTracking {
				return
			}
			self.updateTimeLabel(self.player.currentTime)
			self.progressBar.value = Float(self.player.currentTime)
		}
		timer.fire()
	}
	
	func stopTimer() {
		timer.invalidate()
	}
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		initAudioPlayer()
	}
	
	// MARK: IBAction
	@IBAction func play(_ sender: UIButton) {
		if player == nil {
			return
		}
		
		playButton.isSelected.toggle()
		if player.isPlaying {
			player.stop()
			stopTimer()
		} else {
			player.play()
			fireTimer()
		}
	}
	
	@IBAction func move(_ sender: UISlider) {
		if progressBar.isTracking {
			return
		}
        self.player.currentTime = TimeInterval(sender.value)
	}
	
	// MARK: AudioPlayerDelegate
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		playButton.isSelected = false
		progressBar.value = 0
		updateTimeLabel(0)
		timer.invalidate()
	}
}

