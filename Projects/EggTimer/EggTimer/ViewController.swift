//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
     
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    var timer: Timer?
    var secondTimer: Timer?
    var player: AVAudioPlayer?

    let eggTimes: Dictionary<String, Int> = [
        "Soft" : 3,
        "Medium" : 4,
        "Hard" : 7
    ]
    
    override func viewDidLoad() {
        progressView.progress = 0.0
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        progressView.progress = 0.0
        
        player?.stop()
        timer?.invalidate()
        secondTimer?.invalidate()
        
        let hardness = sender.currentTitle!
        self.titleLabel.text = hardness
        activateTimer(seconds: eggTimes[hardness]!)
    }
    
    func activateTimer(seconds: Int){
        var remaining = seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if remaining >= 0 {
                remaining -= 1
                self.progressView.progress = 1.0 - Float(remaining) / Float(seconds)
                self.playSound(soundName: "tick")
            } else{
                timer.invalidate()
                self.playSound(soundName: "alarm_sound")
                self.titleLabel.text = "Done!"
                
                self.secondTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                    self.titleLabel.text = "How do you like your eggs?"
                    self.progressView.progress = 0.0
                }
            }
        })
    }
    
    func playSound(soundName: String){
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {return}
        player = try! AVAudioPlayer(contentsOf: url)
        player?.play()
    }
    
}
