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
     
    @IBOutlet weak var countdownTimerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stopTimerButton: UIButton!
    var timer: Timer?
    var secondTimer: Timer?
    var player: AVAudioPlayer?

    let eggTimes: Dictionary<String, Int> = [
        "Soft" : 3,
        "Medium" : 4,
        "Hard" : 7
    ]
    
    override func viewDidLoad() {
        progressView.layer.cornerRadius = 12
        progressView.progress = 0.0
        
        
        
        let attributedString = NSMutableAttributedString(string: "Stop!!")
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: NSRange(location: 0, length: attributedString.length))
        
        stopTimerButton.setAttributedTitle(attributedString, for: .normal)
        
        stopTimerButton.isHidden = true
        
        
        countdownTimerLabel.isHidden = false
        
        
    }
    
    
    
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        progressView.setProgress(0.0, animated: true)
        
        player?.stop()
        timer?.invalidate()
        secondTimer?.invalidate()
        
        let hardness = sender.currentTitle!
        self.titleLabel.text = "\(hardness) Boiled Egg is Cooking..."
        activateTimer(seconds: eggTimes[hardness]!)
    }
    
    
    @IBAction func stopTimer(_ sender: UIButton) {
        player?.stop()
        timer?.invalidate()
        
        self.titleLabel.text = "How do you like your eggs?"
        self.progressView.progress = 0.0
        self.stopTimerButton.isHidden = true
    }
    
    
    func activateTimer(seconds: Int){
        var remaining = seconds
        
        var min = remaining/60
        var sec = remaining % 60
        var minLabel = min < 10 ? "0\(min)" : "\(min)"
        var secLabel = sec < 10 ? "0\(sec)" : "\(sec)"
        
        countdownTimerLabel.text = "\(minLabel):\(secLabel)"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if remaining > 0 {
                remaining -= 1
                sec -= 1
                
                if sec < 0 && min > 0 {
                    min -= 1
                    sec = 59
                }
                
                 minLabel = min < 10 ? "0\(min)" : "\(min)"
                 secLabel = sec < 10 ? "0\(sec)" : "\(sec)"
                
                self.countdownTimerLabel.text = "\(minLabel):\(secLabel)"
                self.progressView.setProgress( 1.0 - Float(remaining) / Float(seconds), animated: true)
                self.playSound(soundName: "tick")
            } else{
                timer.invalidate()
                self.playSound(soundName: "alarm_sound", numberOfLoops: -1)
                self.titleLabel.text = "Done!"
                
                self.countdownTimerLabel.isHidden = true
                self.stopTimerButton.isHidden = false
//
//                self.secondTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
//                    self.titleLabel.text = "How do you like your eggs?"
//                    self.progressView.progress = 0.0
//                }
            }
        })
    }
    
    
    
    
    func playSound(soundName: String, numberOfLoops : Int = 1){
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {return}
        player = try! AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = numberOfLoops
        player?.play()
    }
    
}
