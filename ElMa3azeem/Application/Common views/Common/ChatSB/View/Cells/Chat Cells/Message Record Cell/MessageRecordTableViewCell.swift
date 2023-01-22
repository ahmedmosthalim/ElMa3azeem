//
//  MessageRecordTableViewCell.swift
//  Teen
//
//  Created by Yosef Elbosaty on 22/11/2022.
//

import UIKit
import AVFoundation

class MessageRecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var record: UISlider!
    @IBOutlet weak var isSeen: UIImageView!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var cellBackgroundLeading: NSLayoutConstraint!
    @IBOutlet weak var cellBackgroundTrailing: NSLayoutConstraint!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var PlayTimeLabel: UILabel!
    @IBOutlet weak var finalTimeLabel: UILabel!
    @IBOutlet weak var playerView: PlayerViewClass!
    @IBOutlet weak var sliderView: UISlider!
    
    var playAction: (()->())?
    var audioPlayer:AVAudioPlayer?
    var isFinished = false
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        record.value = 0
        PlayTimeLabel.text = "00:00"
    }
    
    override func prepareForReuse() {
        PlayTimeLabel.text = "00:00"
        sliderView.value = 0.0
        playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
        playerView.playerLayer.player = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(message:Message){
        playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
        messageDate.text = message.time
        let recordDuration = (Double(message.duration) ) / 1000.0
        let minutes = Int(recordDuration) / 60 % 60
        let seconds = Int(recordDuration) % 60
        finalTimeLabel.text = String(format: "%02i:%02i", minutes,seconds)
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if playerView.player?.status == .readyToPlay && playerView.player?.rate != 0{
            self.playerView.player?.seek(to: CMTime(seconds: Double(sender.value), preferredTimescale: CMTimeScale.max), completionHandler: { (s) in
            })
        }
    }
    
    func updateSlider(audioPlayer:AVAudioPlayer) {
        record.value = Float(audioPlayer.currentTime)
    }
    
    func updateVideoPlayerSlider() {
        
        let currentTimeInSeconds = CMTimeGetSeconds((playerView.player?.currentTime())!)
       
        
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        PlayTimeLabel.text = "\(minsStr):\(secsStr)"
        record.value = Float(currentTimeInSeconds)
        
      
        if let currentItem = playerView.player?.currentItem {
            let duration = currentItem.duration
           
            if !CMTimeGetSeconds(duration).isNaN{
                let mins = Int(CMTimeGetSeconds(duration)) / 60
                let secs = (CMTimeGetSeconds(duration)).truncatingRemainder(dividingBy: 60)
                let timeformatter = NumberFormatter()
                timeformatter.minimumIntegerDigits = 2
                timeformatter.minimumFractionDigits = 0
                timeformatter.roundingMode = .down
                guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
                    return
                }

                
                self.record.maximumValue = Float(CMTimeGetSeconds(duration))
                //                print(self.slider.maximumValue)
                if (CMTIME_IS_INVALID(duration)) {
                    // Do sth
                    return;
                }
                let currentTime = currentItem.currentTime()
                record.value = Float(CMTimeGetSeconds(currentTime))
              
                
                
                if currentTime == duration || (finalTimeLabel.text == PlayTimeLabel.text){
                    self.isFinished = true
                }
                
            }
        }
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playAction?()
    }
    
}

class PlayerViewClass: UIView {
    
    override static var layerClass: AnyClass{
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    var player : AVPlayer?{
        get{
            return playerLayer.player
        }
        set{
            playerLayer.player = newValue
        }
    }
}
