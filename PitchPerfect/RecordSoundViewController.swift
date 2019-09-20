//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Faisal Babkoor on 9/9/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var startRecordButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    let session = AVAudioSession.sharedInstance()
    let stopRecordingIdentifier = "stopRecording"
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopRecordingButton.isEnabled = false
    }
    
    func startRecording(){

        configUI(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordName = "recordVoice.wav"
        let pathArray = [dirPath, recordName]
        guard let filePath =  URL(string: pathArray.joined(separator: "/")) else {return}

        do{
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioRecorder = AVAudioRecorder(url: filePath, settings: [ : ])

        }catch{
            debugPrint(error.localizedDescription)
        }

        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording(){

        configUI(false)
        audioRecorder.stop()
        do{
            try session.setActive(false)

        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    @IBAction func recordAudio(_ sender: Any) {
        startRecording()
    }
    @IBAction func stopRecording(_ sender: Any) {

        stopRecording()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == stopRecordingIdentifier{
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
    }
    
    func configUI(_ isRecording: Bool){
        recordingLabel.text = isRecording ? "recording in progress" : "Tap to Record"
        stopRecordingButton.isEnabled = isRecording
        startRecordButton.isEnabled = !isRecording
    }
}

