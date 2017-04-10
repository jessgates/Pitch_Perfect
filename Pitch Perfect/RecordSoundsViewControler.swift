//
//  RecordSoundsViewControler.swift
//  Pitch Perfect
//
//  Created by Jess Gates on 1/30/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var Recordinglabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewWillAppear(_ animated: Bool) {
        stopRecordingButton.isEnabled = false
    }
    
    func prepareUIForAction(_ ifRecording: Bool) {
        if(ifRecording) {
            Recordinglabel.text = "Recording in progress"
        }
        else{
            Recordinglabel.text = "Tap to record"
        }
        
        recordButton.isEnabled = !ifRecording
        stopRecordingButton.isEnabled = ifRecording
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AvAudioRecorder ended recording")
        if(flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Saving of recording failed.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    @IBAction func RecordAudio(_ sender: AnyObject) {
        prepareUIForAction(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(fileURLWithPath: dirPath)
        let fileURL = filePath.appendingPathComponent(recordingName)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: fileURL, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func StopRecording(_ sender: AnyObject) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        prepareUIForAction(false)
        
    }
    
}
