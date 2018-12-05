//
//  GameViewController.swift
//  juegoITC
//
//  Created by Alejandro on 01/11/17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
var playAudio = AVAudioPlayer()
    override func viewDidLoad() {
        do{
            playAudio = try AVAudioPlayer(contentsOf:URL.init(fileURLWithPath: Bundle.main.path(forResource: "Ipsi", ofType: "mp3")!))
            playAudio.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            do{
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch{
                
            }
        } catch
        {
        }
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                
                // Present the scene
                view.presentScene(scene)
                playAudio.play()
                playAudio.numberOfLoops = -1
                playAudio.volume = 0.5
            }
            
        //view.ignoresSiblingOrder = true
        //view.showsFPS = true
        //view.showsNodeCount = true
        //view.showsDrawCount = true
        }
        
        
        
        
        
        
    }

    override var shouldAutorotate: Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @IBAction func play(_ sender: Any) {
        playAudio.play()
    }
    
    @IBAction func pause(_ sender: Any) {
        if(playAudio.isPlaying)
        {
            playAudio.stop()
        }
    }
    
    
    
    
    
}
