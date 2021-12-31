//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Michael Benton on 2/21/20.
//  Copyright © 2020 mbenton. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Function for clean up and code re-use:
    // the code for enabling/disabling the recording and stop buttons, and setting the recording label text, is called in multiple places? These three lines of code are always called one after the other when the app state changes from passive to recording. Let's group this code into a function so that we can toggle the UI with a single-line function call.
    
    // The 3 lines of code being called multiple places are:
    // 1. recordingLabel.text = ""
    // 2. stopRecordingButton.isEnabled = bool
    // 3. recordButton.isEnabled = bool
   
// The function below is from the Udacity Knowledge Forum:
    
  // func configureUI(_ isRecording:Bool = false) {
    //   recordingLabel.text = isRecording ? "Recording in progress": "Tap to Record"
     //  recordButton.isEnabled = !isRecording
      // stopRecordingButton.isEnabled = isRecording
   
 
    @IBAction func recordAudio(_ sender: Any) {
      recordingLabel.text = "Recording in progress"
        stopRecordingButton.isEnabled = true
           recordButton.isEnabled = false

            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    
    @IBAction func stopRecording(_ sender: Any) {
      recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
         print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}





