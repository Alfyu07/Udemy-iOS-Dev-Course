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
    let softTime = 5
    let mediumTime = 8
    let hardTime = 12
    
    @IBOutlet weak var progressView: UIProgressView!
    var timer: Timer?
    var player: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        progressView.progress = 0.0
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        let hardness = sender.currentTitle!
        if hardness == "Soft"{
            activateTimer(seconds: softTime)
        } else if hardness == "Medium"{
            activateTimer(seconds: mediumTime)
            
        } else if hardness == "Hard"{
            activateTimer(seconds: hardTime)
        }
    }
    
    func activateTimer(seconds: Int){
        var remaining = seconds
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if remaining > 0 {
                self.progressView.progress = 1.0 - Float(remaining - 1) / Float(seconds)
                remaining -= 1
                self.playSound(soundName: "tick")
            } else{
                timer.invalidate()
                self.playSound(soundName: "alarm_sound")
            }
        })
    }
    
    func playSound(soundName: String){
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {return}
        player = try! AVAudioPlayer(contentsOf: url)
        player?.play()
    }
    
}
