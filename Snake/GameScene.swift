//
//  GameScene.swift
//  Snake
//
//  Created by Max Zhuravsky on 3/13/17.
//  Copyright © 2017 Moscow State University. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    /* Global Constants and Types */
    
    private static let fieldSize = 10 // fieldSize * cellSize + 2 * offset == 600
    private static let offset : CGFloat = 50
    private static let cellSize : CGFloat = 50
    private static let snakeTextures = [SKTexture(imageNamed: "#1"),
                                     SKTexture(imageNamed: "#2"),
                                     SKTexture(imageNamed: "#3"),
                                     SKTexture(imageNamed: "#4"),
                                     SKTexture(imageNamed: "#5")]
    private static let foodTexture = SKTexture(imageNamed: "Food")
    
    private struct Object {
        var x : Int
        var y : Int
        var form : SKSpriteNode
        var index : Int
        
        init (x: Int, y: Int, texture: SKTexture, index : Int = 0) {
            self.x = x
            self.y = y
            self.index = index
            
            self.form = SKSpriteNode(texture: texture, size: CGSize(width: cellSize * 0.95,
                                                                    height: cellSize * 0.95))
            self.form.position = CGPoint(x: (CGFloat(x) + 0.5) * cellSize + offset,
                                         y: (CGFloat(y) + 0.5) * cellSize + offset)
        }
    }
    
    private enum Direction : Int {
        case left, right, up, down
    }
    
    /* Main Logic */
    
    /* Properties */
    private var snake = [Object(x: 1, y: 1,
                                texture: GameScene.snakeTextures[0], index: 0)]
    private var food = Object(x: 1, y: 5,
                              texture: GameScene.foodTexture)
    private var grows = false
    private var score = 1
    private var highScore = 1
    private var currentDirection : Direction = .up
    private var scoreLabel = SKLabelNode(text: "High Score: ")
    private var scoreLabelShade = SKLabelNode(text: "High Score: ")
    private var directionChanged = false
    
    /* Update */
    
    private func drawInterface() {
        
        scoreLabelShade.removeFromParent()
        scoreLabelShade = SKLabelNode(text: "High Score: " + String(highScore))
        scoreLabelShade.position = CGPoint(x: self.size.width / 4 + 2, y: GameScene.offset / 3 + 2)
        scoreLabelShade.fontSize = 17
        scoreLabelShade.fontColor = NSColor(white: 0.8, alpha: 0.5)
        scoreLabelShade.fontName = "AppleSDGothicNeo-Medium"
        addChild(scoreLabelShade)
        
        scoreLabel.removeFromParent()
        scoreLabel = SKLabelNode(text: "High Score: " + String(highScore))
        scoreLabel.position = CGPoint(x: self.size.width / 4, y: GameScene.offset / 3)
        scoreLabel.fontSize = 17
        scoreLabel.fontColor = NSColor.black
        scoreLabel.fontName = "AppleSDGothicNeo-Medium"
        addChild(scoreLabel)
        
    }
    
    private func updateScore() {
        if score > highScore {
            highScore = score
            drawInterface()
        }
        
        if score == GameScene.fieldSize * GameScene.fieldSize - 1 {
            print("Congratulations! You win.\n")
            restartSnake()
        }
    }
    
    private func addFood() {
        food.form.removeFromParent()
        repeat {
            food = Object(x: Int(random(min: 0.0, max: CGFloat(GameScene.fieldSize))),
                          y: Int(random(min: 0.0, max: CGFloat(GameScene.fieldSize))),
                          texture: GameScene.foodTexture)
        } while({
                    var result = false
                    for segment in snake {
                        if segment.x == food.x && segment.y == food.y {
                            result = true
                            break
                        }
                    }
                    return result
                }())
        
        addChild(food.form)
    }
    
    private func handleCollisions(_ section: Object) -> Bool {
        if (section.x == food.x && section.y == food.y) {
            grows = true
            score += 1
            addFood()
        }
        if (!isInside(x: section.x, y: section.y)) {
            return true
        }
        for i in 1..<snake.count {
            if (snake[i].x == section.x && snake[i].y == section.y) {
                return true
            }
        }
        
        return false
    }
    
    private func update() {
        
        directionChanged = false
        
        var newSection : Object
        var index = random(min: 0, max: 4)
        
        if index == snake[0].index {
            index = (index + 1) % 5
        }
        
        switch(currentDirection) {
        case .left:
            newSection = Object(x: snake[0].x - 1,
                                y: snake[0].y,
                                texture: GameScene.snakeTextures[index], index: index)
        case .right:
            newSection = Object(x: snake[0].x + 1,
                                y: snake[0].y,
                                texture: GameScene.snakeTextures[index], index: index)
        case .up:
            newSection = Object(x: snake[0].x,
                                y: snake[0].y + 1,
                                texture: GameScene.snakeTextures[index], index: index)
        case .down:
            newSection = Object(x: snake[0].x,
                                y: snake[0].y - 1,
                                texture: GameScene.snakeTextures[index], index: index)
        }
        
        if snake.count > 0 {
            if !handleCollisions(newSection) {
                if !grows {
                    
                    let last = snake.popLast()
                    last?.form.removeFromParent()
                    addChild(newSection.form)
                    snake.insert(newSection, at: 0)
                } else {
                    grows = false
                    addChild(newSection.form)
                    snake.insert(newSection, at: 0)
                }
            } else {
                restartSnake()
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        
        if !directionChanged {
            switch (event.keyCode) {
            case 126, 13:
                if (currentDirection != .down) {
                    currentDirection = .up
                    directionChanged = true
                }
            case 125, 1:
                if (currentDirection != .up) {
                    currentDirection = .down
                    directionChanged = true
                }
            case 123, 0:
                if (currentDirection != .right) {
                    currentDirection = .left
                    directionChanged = true
                }
            case 124, 2:
                if (currentDirection != .left) {
                    currentDirection = .right
                    directionChanged = true
                }
            case 53:
                let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 1.0)
                    
                let nextScene = GameScene(size: self.size) //::ToDo Change to MenuScene
                nextScene.scaleMode = SKSceneScaleMode.fill
                self.view?.presentScene(nextScene, transition: transition)
            default:
                print("Unknown key pressed: \(event.keyCode)\n")
            }
        }
        
    }
    
    /* Init */
    
    override func didMove(to view: SKView) {
        
        drawMap()
        drawInterface()
        addChild(snake[0].form)
        addChild(food.form)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(update),
                SKAction.run(updateScore),
                SKAction.wait(forDuration: 0.5)
                ])
        ))
    }
    
    private func drawMap() {
        backgroundColor = SKColor(calibratedRed: 236, green: 238, blue: 244, alpha: 1)
        let innerFrame = SKShapeNode(rect: NSRect(x: GameScene.offset,
                                             y: GameScene.offset,
                                             width: GameScene.cellSize * CGFloat(GameScene.fieldSize),
                                             height: GameScene.cellSize * CGFloat(GameScene.fieldSize)))
        innerFrame.lineWidth = 2
        innerFrame.strokeColor = NSColor.lightGray
        addChild(innerFrame)
        
        let outerFrame = SKShapeNode(rect: NSRect(x: GameScene.offset * 0.9,
                                             y: GameScene.offset * 0.9,
                                             width: GameScene.cellSize * CGFloat(GameScene.fieldSize) + GameScene.offset * 0.2,
                                             height: GameScene.cellSize * CGFloat(GameScene.fieldSize) + GameScene.offset * 0.2))
        outerFrame.lineWidth = 2
        outerFrame.strokeColor = NSColor.lightGray
        addChild(outerFrame)
    }
    
    private func restartSnake() {
        for section in snake {
            section.form.removeFromParent()
        }
        let index = random(min: 0, max: 4)
        snake = [Object(x: 1, y: 1, texture: GameScene.snakeTextures[index], index: index)]
        addChild(snake[0].form)
        score = 0
        currentDirection = .up
    }
    
    /* Auxiliary Functions */
    
    private func isInside(x: Int, y: Int) -> Bool {
        return (x < GameScene.fieldSize) && (y < GameScene.fieldSize) && (y >= 0) && (x >= 0)
    }
    
    private func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min: CGFloat, max: CGFloat) -> Int {
        return Int(random() * (max - min) + min)
    }
    
}
