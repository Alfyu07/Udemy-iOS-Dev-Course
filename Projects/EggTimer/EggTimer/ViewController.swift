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
    var player: AVAudioPlayer?

    let eggTimes: Dictionary<String, Int> = [
        "Soft" : 300,
        "Medium" : 420,
        "Hard" : 720
    ]
    
    
    override func viewDidLoad() {
        setupProgressView()
        setupStopTimerButton()
    }
    
    
    // MARK: - UI Setup
    
    private func setupStopTimerButton(){
        let attributedString = NSMutableAttributedString(string: "Stop!!")
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: NSRange(location: 0, length: attributedString.length))
        
        stopTimerButton.setAttributedTitle(attributedString, for: .normal)
        stopTimerButton.isHidden = true
    }
    
    private func setupProgressView(){
        progressView.layer.cornerRadius = 12
        progressView.progress = 0.0
    }
    
    
    
    //MARK: - Button Action
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        resetTimer()
        let hardness = sender.currentTitle!
        titleLabel.text = "\(hardness) Boiled Egg is Cooking..."
        startTimer(seconds: eggTimes[hardness]!)
    }
    
    @IBAction func stopTimer(_ sender: UIButton) {
        player?.stop()
        timer?.invalidate()
        titleLabel.text = "How do you like your eggs?"
        progressView.setProgress(0.0, animated: true)
        stopTimerButton.isHidden = true
        countdownTimerLabel.isHidden = false
    }
    
    //MARK: - Timer Logic
    private func resetTimer(){
        progressView.setProgress(0.0, animated: true)
        player?.stop()
        timer?.invalidate()
        countdownTimerLabel.isHidden = false
        stopTimerButton.isHidden = true
    }
    
    private func updateTimerLabel(seconds: Int){
        let formattedTime = formatTime(seconds: seconds)
        countdownTimerLabel.text = formattedTime
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    func startTimer(seconds: Int){
        var remaining = seconds
        updateTimerLabel(seconds: remaining)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            
            guard let self = self else {return}
            if remaining > 0 {
                remaining -= 1
                self.updateTimerLabel(seconds: remaining)
                self.progressView.setProgress( 1.0 - Float(remaining) / Float(seconds), animated: true)
                self.playSound(soundName: "tick")
            } else{
                timer.invalidate()
                self.playSound(soundName: "alarm_sound", numberOfLoops: -1)
                self.titleLabel.text = "Done!"
                
                self.countdownTimerLabel.isHidden = true
                self.stopTimerButton.isHidden = false
            }
        })
    }
    
    //MARK: - Sound
    func playSound(soundName: String, numberOfLoops : Int = 1){
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {return}
        player = try! AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = numberOfLoops
        player?.play()
    }
    
}
