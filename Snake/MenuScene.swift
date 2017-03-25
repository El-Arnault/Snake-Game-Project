//
//  MenuScene.swift
//  Snake
//
//  Created by Max Zhuravsky on 3/20/17.
//  Copyright © 2017 Moscow State University. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene {
    
    let background = SKVideoNode(fileNamed: "Gameplay.mov")
    
    override func didMove(to view: SKView) {
        
        setupScene()
        background.run(SKAction.repeatForever(SKAction.sequence([
                                SKAction.rotate(byAngle: CGFloat(2 * M_PI), duration: 8),
                                SKAction.rotate(byAngle: CGFloat(-2 * M_PI), duration: 8)
            ])))
    }
    
    private func setupScene() {
        backgroundColor = SKColor.white
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: 300, y: 300)
        background.size = CGSize(width: 600, height: 600)
        background.play()
        addChild(background)
    }
    
    override func keyDown(with event: NSEvent) {
        
        switch (event.keyCode) {
        case 36:
            leaveScene()

        default:
            print("Unknown key pressed: \(event.keyCode)\n")
        }
        
    }
    
    private func leaveScene() {
        let transition = SKTransition.reveal(with: SKTransitionDirection.up, duration: 1.0)
        let nextScene = GameScene(size: self.size)
        nextScene.scaleMode = SKSceneScaleMode.fill
        
        background.pause()
        background.removeAllChildren()
        
        self.view?.presentScene(nextScene, transition: transition)
    }

}
