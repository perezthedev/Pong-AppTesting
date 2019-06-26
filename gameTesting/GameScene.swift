//
//  GameScene.swift
//  gameTesting
//
//  Created by Ryan Aponte on 5/29/19.
//  Copyright © 2019 Ryan Perez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemyPadel = SKSpriteNode()
    var mainPadel = SKSpriteNode()
    
    var topLbl = SKLabelNode()
    var btmLbl = SKLabelNode()
    
    var score = [Int]()
    
    override func didMove(to view: SKView) {
        
        
        
        topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        btmLbl = self.childNode(withName: "btmLabel") as! SKLabelNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        //print(self.view?.bounds.height)
        
        
        enemyPadel = self.childNode(withName: "enemyPadel") as! SKSpriteNode
        enemyPadel.position.y = (self.frame.height / 2) - 50
        
        mainPadel = self.childNode(withName: "mainPadel") as! SKSpriteNode
        mainPadel.position.y = (-self.frame.height / 2) + 50

        ball.physicsBody?.applyImpulse(CGVector(dx: 9, dy: 9)) //controls angle of ball
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
    }
    
    func startGame()
    {
        score = [0,0]
        topLbl.text = "\(score[1])"
        btmLbl.text = "\(score[0])"
        ball.physicsBody?.applyImpulse(CGVector (dx: 9, dy: 9)) //controls start angle of ball
    }
    
    func addScore(playerWhoWon: SKSpriteNode){
        
        let rand_num_x = Int.random(in: 8...9) // used to randomize starting ball angle
        let rand_num_y = Int.random(in: 8...9)
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        if playerWhoWon == mainPadel
        {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector (dx: rand_num_x, dy: rand_num_y))
        }
        else if playerWhoWon == enemyPadel
        {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector (dx: -rand_num_x, dy: -rand_num_y))
        }
        topLbl.text = "\(score[1])"
        btmLbl.text = "\(score[0])"
    }
    
    //controls padel movement when touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                // 0 is center of screen
                if location.y > 0{
                     enemyPadel.run(SKAction.moveTo(x: location.x, duration: 0.0))
                }
                if location.y < 0{
                     mainPadel.run(SKAction.moveTo(x: location.x, duration: 0.0))
                }
            }
            else{
                mainPadel.run(SKAction.moveTo(x: location.x, duration: 0.0))
            }
           
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { //speed of padels
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                // 0 is center of screen
                if location.y > 0{
                    enemyPadel.run(SKAction.moveTo(x: location.x, duration: 0.0))
                }
                if location.y < 0{
                    mainPadel.run(SKAction.moveTo(x: location.x, duration: 0.0))
                }
            }
            else {
                mainPadel.run(SKAction.moveTo(x: location.x, duration: 0.0))
            }
        }
    }
    
    //the more code in here the lower the game quality
    //
    //if ball goes behind padel, point is added
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        switch currentGameType{
       
        //controls speed of padel
        case .easy:
            enemyPadel.run(SKAction.moveTo(x: ball.position.x, duration: 1.5))
            break
        case .medium:
            enemyPadel.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
            break
        case .hard:
            enemyPadel.run(SKAction.moveTo(x: ball.position.x, duration: 0.5))
            break
        case .player2:
            
            break
        }
       // enemyPadel.run(SKAction.moveTo(x: ball.position.x, duration: 0.5)) // controls difficulty
        
        if ball.position.y <= mainPadel.position.y - 20
        {
            addScore(playerWhoWon:  enemyPadel)
        }
        else if ball.position.y >= enemyPadel.position.y + 20
        {
            addScore(playerWhoWon: mainPadel)
        }
        
    }
}
