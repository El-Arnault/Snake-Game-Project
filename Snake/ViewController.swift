//
//  ViewController.swift
//  Snake
//
//  Created by Max Zhuravsky on 3/13/17.
//  Copyright © 2017 Moscow State University. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let scene = GameScene(size: CGSize(width: 600, height: 600))
        let skView = view as! SKView
        skView.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
}

