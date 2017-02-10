//
//  GameScene.swift
//  Flappy Wade
//
//  Created by Dan Sweetman on 1/14/16.
//  Copyright (c) 2016 Dan Sweetman. All rights reserved.
//

import Foundation
import SpriteKit

struct physicsCatagory {
    static let wade : UInt32 = 0x1 << 1
    static let floor : UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
    static let roof: UInt32 = 0x1 << 4
    static let score: UInt32 = 0x1 << 5
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var highScoreNum = Int()
    
    var roof = SKSpriteNode()
    var floor = SKSpriteNode()
    var wade = SKSpriteNode()
    var wallPair = SKNode()
    var score = Int()
    let scoreLable = SKLabelNode()
    var ded = Bool()
    
    var startScreenz = SKSpriteNode()
    var startBtn = SKSpriteNode()
    
    var gameBtn = SKSpriteNode()
    let gameLable1 = SKLabelNode()
    let gameLable2 = SKLabelNode()
    
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    
    var restartBtn = SKSpriteNode()
    let restartLable = SKLabelNode()
    
    /*
    func startScreen(){
        print("startScene() has been called")
        startScreenz = SKSpriteNode(imageNamed: "startScreen")
        startScreenz.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        startScreenz.zPosition = 1
        
        startBtn = SKSpriteNode(color: SKColor.clearColor(), size: CGSize(width: 150, height: 75))
        startBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - self.frame.height / 2.9)
        startBtn.zPosition = 2
        
        self.addChild(startScreenz)
        self.addChild(startBtn)
    }
    */
    
    func endScreen(){
        
        let HYPE = SKLabelNode()
        
        getHighScore()
        if score > highScoreNum{
            setHighScore()
            HYPE.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2 )
            HYPE.zPosition = 12
            HYPE.fontColor = UIColor.red
            HYPE.fontName = "ChalkboardSE-Regular"
            HYPE.fontSize = 60.0
            HYPE.text = "HYPE!!!:"
            self.addChild(HYPE)
        }
        
        self.removeAllChildren()
        let highScoreLable = SKLabelNode()
        let currentScoreLabel = SKLabelNode()
        let highScore = SKLabelNode()
        let currentScore = SKLabelNode()
        
        highScoreLable.position = CGPoint(x: self.frame.width / 2 - 20, y: self.frame.height / 2 + self.frame.height / 4.4)
        highScoreLable.zPosition = 11
        highScoreLable.fontColor = UIColor.black
        highScoreLable.fontName = "ChalkboardSE-Regular"
        highScoreLable.fontSize = 30.0
        highScoreLable.text = "High Score:"
        self.addChild(highScoreLable)
        
        highScore.position = CGPoint(x: self.frame.width / 2 + 80, y: self.frame.height / 2 + self.frame.height / 4.4)
        highScore.zPosition = 11
        highScore.fontColor = UIColor.black
        highScore.fontName = "ChalkboardSE-Regular"
        highScore.fontSize = 25.0
        getHighScore()
        highScore.text = "\(highScoreNum)"
        self.addChild(highScore)
        
        currentScoreLabel.position = CGPoint(x: self.frame.width / 2 - 20, y: self.frame.height / 2 + self.frame.height / 3.5)
        currentScoreLabel.zPosition = 11
        currentScoreLabel.fontColor = UIColor.black
        currentScoreLabel.fontName = "ChalkboardSE-Regular"
        currentScoreLabel.fontSize = 30.0
        currentScoreLabel.text = "Your Score:"
        self.addChild(currentScoreLabel)
        
        currentScore.position = CGPoint(x: self.frame.width / 2 + 80, y: self.frame.height / 2 + self.frame.height / 3.5)
        currentScore.zPosition = 11
        currentScore.fontColor = UIColor.black
        currentScore.fontName = "ChalkboardSE-Regular"
        currentScore.fontSize = 25.0
        currentScore.text = "\(score)"
        self.addChild(currentScore)
        
        createRestartBtn()
    }
    func gameStart(){
        //print("gameStart() has been called")
        gameLable1.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 4)
        gameLable1.zPosition = 11
        gameLable1.fontColor = UIColor.black
        gameLable1.fontName = "ChalkboardSE-Regular"
        gameLable1.fontSize = 40.0
        gameLable1.text = "Flappy Wade"
        self.addChild(gameLable1)
        
        gameLable2.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - self.frame.height / 4)
        gameLable2.zPosition = 11
        gameLable2.fontColor = UIColor.black
        gameLable2.fontName = "ChalkboardSE-Regular"
        gameLable2.fontSize = 40.0
        gameLable2.text = "Tap to Start!"
        self.addChild(gameLable2)

        gameBtn = SKSpriteNode(color: SKColor.clear, size: CGSize(width: self.frame.width, height: self.frame.height))
        gameBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        gameBtn.zPosition = 10
        self.addChild(gameBtn)
    }
    
    func createScene(){
        //print("createScene() has been called")
        
        self.backgroundColor = UIColor.white
        self.physicsWorld.contactDelegate = self

        roof = SKSpriteNode(color: SKColor.clear, size: CGSize(width: self.frame.width , height: 10))
        roof.position = CGPoint(x: self.frame.width / 2, y: 780 - roof.frame.height)
        roof.physicsBody = SKPhysicsBody(rectangleOf: roof.size)
        roof.physicsBody?.categoryBitMask = physicsCatagory.roof
        roof.physicsBody?.collisionBitMask = physicsCatagory.wade
        roof.physicsBody?.contactTestBitMask = physicsCatagory.wade
        roof.physicsBody?.affectedByGravity = false
        roof.physicsBody?.isDynamic = false
        
        roof.zPosition = 3
        
        self.addChild(roof)
        
        floor = SKSpriteNode(imageNamed: "floor")
        floor.setScale(0.55)
        floor.position = CGPoint(x: self.frame.width / 2, y: 0 + floor.frame.height / 2)
        self.addChild(floor)
        
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.categoryBitMask = physicsCatagory.floor
        floor.physicsBody?.collisionBitMask = physicsCatagory.wade
        floor.physicsBody?.contactTestBitMask = physicsCatagory.wade
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.isDynamic = false
        
        floor.zPosition = 3
        
        
        wade = SKSpriteNode(imageNamed: "wade")
        wade.size = CGSize(width: 70, height: 70)
        wade.position = CGPoint(x: self.frame.width / 2 - wade.frame.width, y: self.frame.height / 2)
        
        wade.physicsBody = SKPhysicsBody(circleOfRadius: wade.frame.height / 2.6)
        wade.physicsBody?.categoryBitMask = physicsCatagory.wade
        wade.physicsBody?.collisionBitMask = physicsCatagory.floor | physicsCatagory.wall | physicsCatagory.roof
        wade.physicsBody?.contactTestBitMask = physicsCatagory.floor | physicsCatagory.wall | physicsCatagory.score | physicsCatagory.roof
        wade.physicsBody?.affectedByGravity = false
        wade.physicsBody?.isDynamic = true
        
        wade.zPosition = 2
        
        self.addChild(wade)
    
    }
    
    func createRestartBtn(){
        restartLable.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - self.frame.height / 2.8)
        restartLable.zPosition = 11
        restartLable.fontColor = UIColor.black
        restartLable.fontName = "ChalkboardSE-Regular"
        restartLable.fontSize = 40.0
        restartLable.text = "Restart?"
        self.addChild(restartLable)
        restartBtn = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 150, height: 50))
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - self.frame.height / 2.9)
        restartBtn.zPosition = 5
        self.addChild(restartBtn)
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        ded = false
        gameStarted = false
        score = 0
        gameStart()
        createScene()
    }
    
    override func didMove(to view: SKView) {
        //startScreen()
        gameStart()
        createScene()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == physicsCatagory.score && secondBody.categoryBitMask == physicsCatagory.wade || firstBody.categoryBitMask == physicsCatagory.wade && secondBody.categoryBitMask == physicsCatagory.score{
            score += 1
            scoreLable.text = "\(score)"
        }
        
        if firstBody.categoryBitMask == physicsCatagory.wall && secondBody.categoryBitMask == physicsCatagory.wade || firstBody.categoryBitMask == physicsCatagory.wade && secondBody.categoryBitMask == physicsCatagory.wall{
            ded = true
            self.removeAllActions()
            endScreen()
        }
        
        if firstBody.categoryBitMask == physicsCatagory.floor && secondBody.categoryBitMask == physicsCatagory.wade || firstBody.categoryBitMask == physicsCatagory.wade && secondBody.categoryBitMask == physicsCatagory.floor{
            ded = true
            self.removeAllActions()
            endScreen()
        }
    }
    
    //Before the first touch on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if ded == true{
                if restartBtn.contains(location){
                    restartScene()
                }
            }
            
            if startBtn.contains(location){
                self.removeChildren(in: [startBtn,startScreenz])
                //print("startScreen removed starting the game")
                gameStart()
                createScene()
            }
            
            if gameBtn.contains(location){
                if gameStarted == false{
                    self.removeChildren(in: [gameBtn, gameLable1, gameLable2])
                    //print("startGame removed starting the flapping of wade")
                    gameStarted = true
                    
                    scoreLable.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
                    scoreLable.zPosition = 4
                    scoreLable.fontColor = UIColor.black
                    scoreLable.fontName = "ChalkboardSE-Regular"
                    scoreLable.fontSize = 40.0
                    scoreLable.text = "\(score)"
                    self.addChild(scoreLable)
                    
                    let spawn = SKAction.run({
                        ()in
                        
                        self.createWalls()
                    })
                    let delay = SKAction.wait(forDuration: 2.0)
                    let spawnDelay = SKAction.sequence([spawn, delay])
                    let spawnDelayForever = SKAction.repeatForever(spawnDelay)
                    self.run(spawnDelayForever)
                    
                    let distance = CGFloat(self.frame.width + wallPair.frame.width)
                    let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.01 * distance))
                    let removePipes = SKAction.removeFromParent()
                    
                    moveAndRemove = SKAction.sequence([movePipes, removePipes])
                    wade.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
                    wade.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 58))
                    wade.physicsBody?.affectedByGravity = true
                    
                }else{
                    if ded == true{
                        self.removeAllActions()
                    }else{
                        wade.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
                        wade.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 58))
                    }
                }
            }
        }
    }
    
    func createWalls(){
        
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = physicsCatagory.score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = physicsCatagory.wade
        
        wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "wall")
        let bottomWall = SKSpriteNode(imageNamed: "wall")
        
        topWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 350)
        bottomWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 - 350)
        
        topWall.zRotation = CGFloat(M_PI)
        
        topWall.setScale(0.5)
        bottomWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = physicsCatagory.wall
        topWall.physicsBody?.collisionBitMask = physicsCatagory.wade
        topWall.physicsBody?.contactTestBitMask = physicsCatagory.wade
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = physicsCatagory.wall
        bottomWall.physicsBody?.collisionBitMask = physicsCatagory.wade
        bottomWall.physicsBody?.contactTestBitMask = physicsCatagory.wade
        bottomWall.physicsBody?.affectedByGravity = false
        bottomWall.physicsBody?.isDynamic = false
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        wallPair.addChild(scoreNode)
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
    }
    
    func setHighScore(){
        let highestScore = score
        UserDefaults.standard.set(highestScore, forKey:"HighScore")
        UserDefaults.standard.synchronize()
    }
    
    func getHighScore(){
        if UserDefaults.standard.object(forKey: "HighScore") != nil{
            let savedScore: Int = UserDefaults.standard.object(forKey: "HighScore") as! Int
            print(savedScore)
            highScoreNum = savedScore
        }else{
            highScoreNum = 0
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
