//
//  GameScene.swift
//  juegoITC
//
//  Created by Alejandro on 01/11/17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import CoreMotion
import AudioToolbox
//Nombrar a los cuerpos fisicos para poder ponerle propiedades, y convertilos a UInt32, darle un bit number
struct CuerpoFisico {
    static let miLaser : UInt32 = 0x1 << 0
    static let miEnemigo1 : UInt32 = 0x1 << 1
    static let miNave : UInt32 = 0x1 << 2
    static let miAsteroide : UInt32 = 0x1 << 3
    static let miLaserEnemigo1 : UInt32 = 0x1 << 4
    static let miNaveMedioMuerta : UInt32 = 0x1 << 5
    static let miLaserMedioMuerto : UInt32 = 0x1 << 6
    static let miNaveMuerta : UInt32 = 0x1 << 7
    static let miAsteroideNuevo : UInt32 = 0x1 << 8
    static let miEnemigo1MedioMuerto : UInt32 = 0x1 << 9
    static let miLaserEnemigo1MedioMuerto : UInt32 = 0x1 << 10
    static let miEnemigo2Arriba : UInt32 = 0x1 << 11
    static let miEnemigo2Abajo : UInt32 = 0x1 << 12
    static let miEnemigo2ArribaMedioMuerto : UInt32 = 0x1 << 13
    static let miEnemigo2AbajoMedioMuerto : UInt32 = 0x1 << 14
    static let laserOvniAbajo : UInt32 = 0x1 << 15
    static let laserOvniArriba : UInt32 = 0x1 << 16
    static let miEnemigoGrande : UInt32 = 0x1 << 17
    static let miVida : UInt32 = 0x1 << 18
    static let miMoneda : UInt32 = 0x1 << 19
   // static let laserOvniAbajoMedioMuerto : UInt32 = 0x1 << 17
   // static let laserOvniArribaMedioMuerto : UInt32 = 0x1 << 18
   
}



class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    
    
    //Declaracion del booleano de vida
    
        var lapsoEnQueSeCreanLosAsteroides : Double = 0.8
    
    var muerto = Bool()
    var gameStarted = false

  
    //Se declara el Node que va a estar de fondo de pantalla
    var estrellas : SKEmitterNode!
    var sparkNave : SKEmitterNode!
    
    
    //Se declara el manager que controlara el girsocopio
    let managerDeCoreMotion = CMMotionManager()
    var yAcceleracion:CGFloat = 0
    //Se declara la etiqueta que tendra el score
    var etiquetaConScore : SKLabelNode!
    var etiquetaWinner : SKLabelNode!
    var tittleInstructions : SKLabelNode!
    var instructions : SKLabelNode!
    var instructions2 : SKLabelNode!
    //se cambia el numero del score
    var iConteo : Int = 0
    var iConteoArriba : Int = 0
     var iConteoAbajo : Int = 0
    var iConteoEnemigoGrande : Int = 0
    var iNumeroDeVidas : Int = 0
    var iNumeroDeVidasOvni : Int = 0
    var score : Int = 0
    {
        didSet {
            etiquetaConScore.text = "Score: \(score)"
        }
    }

    
    
    //Se declaran los sprites que estaran en el juego
    var miNave = SKSpriteNode()
    var miEnemigo1 = SKSpriteNode()
    var miEnemigo1MedioMuerto = SKSpriteNode()
    var laser = SKSpriteNode()
    var laserOvni = SKSpriteNode()
    var laserOvniNuevo = SKSpriteNode()
    var laserOvniArriba = SKSpriteNode()
    var laserOvniAbajo = SKSpriteNode()
    var laserOvniArribaMedioMuerto = SKSpriteNode()
    var laserOvniAbajoMedioMuerto = SKSpriteNode()
    var miNave2 = SKSpriteNode()
    var miNave3 = SKSpriteNode()
    var miEnemigo2Arriba = SKSpriteNode()
    var miEnemigo2Abajo = SKSpriteNode()
    var miEnemigo2ArribaMedioMuerto = SKSpriteNode()
    var miEnemigo2AbajoMedioMuerto = SKSpriteNode()
    var miEnemigoGrande = SKSpriteNode()
    var miLaserEnemigoGrande = SKSpriteNode()
    var barraArriba = SKSpriteNode()
    var barraAbajo = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var coin = SKSpriteNode()
    var laserMuerto = SKSpriteNode()
    var laserMedioMuerto = SKSpriteNode()
    var vida = SKSpriteNode()
    var bNuevosAsteoroides : Bool = false
    var highScore : Int = 0
    var contadorDeGolpesAAsteroide : Int = 0
    //Nombre: laserHaColapsadoConAsteroide
    // Descrpcion: va a craer un efecto y remover los sprites de la escena
    //Parametros: (laser: SKSpriteNode, miAsteroide: SKSpriteNode)
    func laserHaColapsadoConAsteroide(laser: SKSpriteNode, miAsteroide: SKSpriteNode)
    {
        contadorDeGolpesAAsteroide += 1
        let explosion = SKEmitterNode(fileNamed: "Spark")!
        
        explosion.position = CGPoint(x: miAsteroide.position.x, y: miAsteroide.position.y)
       
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        laser.removeFromParent()
        
        if (contadorDeGolpesAAsteroide % 4 == 0)
        {
            miAsteroide.removeFromParent()
            contadorDeGolpesAAsteroide = 0
        }
        self.run(SKAction.wait(forDuration: 0.3))
        {
        explosion.removeFromParent()
        }
        
        
        
    }
    
    //Nombre: vidaNueva
    // Descrpcion: Va a darle una vida nueva a la nave
    // Parametros : (miNaveSalvada: SKSpriteNode, miVida: SKSpriteNode)
    func vidaNueva(miNaveSalvada: SKSpriteNode, miVida: SKSpriteNode)
    {
        
       self.run(SKAction.playSoundFileNamed("RecojeVida.mp3", waitForCompletion: false))
        vida.removeFromParent()
        if(iNumeroDeVidas == 1)
        {
        miNave2.removeFromParent()
        createNave()
        miNave.position = CGPoint(x: miNave2.position.x, y: miNave2.position.y)
        iNumeroDeVidas -= 1
        }
        else if(iNumeroDeVidas == 2)
        {
        miNave3.removeFromParent()
        createNave2()
        miNave2.position = CGPoint(x: miNave3.position.x, y: miNave3.position.y)
        iNumeroDeVidas -= 1
        }
        
        
    }
    //Nombre: monedaNueva
    // Descrpcion: Va a atrapar monedas y desaparecerlas
    //Paramteros: (miNaveTocando: SKSpriteNode, moneda: SKSpriteNode)
    func monedaNueva(miNaveTocando: SKSpriteNode, moneda: SKSpriteNode)
    {

     self.run(SKAction.playSoundFileNamed("Mario-coin-sound.mp3", waitForCompletion: false))
       coin.removeFromParent()
       score += 5
       
    }

    
    //Nombre: laserHaColapsadoConAsteroide
    // Descrpcion: va a craer un efecto y remover los sprites de la escena
    // Parametros: (nave: SKSpriteNode, Objeto: SKSpriteNode)
    func objetoEnemigoHaColapsadoConNave(nave: SKSpriteNode, Objeto: SKSpriteNode)
    {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        iNumeroDeVidas += 1
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        Objeto.removeFromParent()
        
       
            nave.removeFromParent()
            let explosion = SKEmitterNode(fileNamed: "Humo")!
            explosion.position = CGPoint(x: Objeto.position.x, y: Objeto.position.y )
            self.addChild(explosion)
            self.run(SKAction.wait(forDuration: 2.0))
            {
                explosion.removeFromParent()

            }
        
      
        //El juego restart para colocar la nueva nave
       
    }
    
    //Nombre: colapsoLaserConLaser
    //Descripción: Cuando dos lasers colisionan entre si, se muestra una animacion llamada "explosion" y desaparecen ambos lasers.
    // Parametros: (miLaserEnemigo1:SKSpriteNode, miLaser: SKSpriteNode)
    func colapsoLaserConLaser (miLaserEnemigo1:SKSpriteNode, miLaser: SKSpriteNode)
    {
        let explosion = SKEmitterNode(fileNamed: "Magic")!
        explosion.position = CGPoint(x: miLaserEnemigo1.position.x , y: miLaserEnemigo1.position.y)
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        miLaserEnemigo1.removeFromParent()
        miLaser.removeFromParent()
        self.run(SKAction.wait(forDuration: 0.30))
        {
            explosion.removeFromParent()
            
        }
        
    }
    
    //Nombre: laserHaColapsadoConEnemigo
    // Descripcion: va a crear un efecto llamada "explosion" y remover los sprites de la escena. El contador indica cuando debe cambiarse de ovni a ovniMediomuerto
    //Parametros: (miEnemigo: SKSpriteNode, miLaser: SKSpriteNode)
    func laserHaColapsadoConEnemigo(miEnemigo: SKSpriteNode, miLaser: SKSpriteNode)
    {
        
        iConteo += 1
        laser.removeFromParent()
        laserMedioMuerto.removeFromParent()
        laserMuerto.removeFromParent()
       
        if(iConteo == 5)
        {
            iNumeroDeVidasOvni += 1
            let explosion = SKEmitterNode(fileNamed: "Fire")!
            explosion.position = CGPoint(x: miEnemigo.position.x, y: miEnemigo.position.y )
            miEnemigo1.removeFromParent()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            laserOvni.removeFromParent()
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            score += 15
            self.run(SKAction.wait(forDuration: 2.55))
            {
                explosion.removeFromParent()
            }
            removeAction(forKey: "laserOvni")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
               self.createEnemigoMedioMuerto()
           
                let spawnOvniLaserMedioMuerto = SKAction.run({
                    ()
                    in self.createLaserOvniMedioMuerto()
                })
                let delayLaserOvniMedioMuerto = SKAction.wait(forDuration: 1.5)
                let spawnDelayLaserOvniMedioMuerto = SKAction.sequence([spawnOvniLaserMedioMuerto, delayLaserOvniMedioMuerto])
                let spawnDelayForeverOvniMedioMuerto = SKAction.repeatForever(spawnDelayLaserOvniMedioMuerto)
                self.run(spawnDelayForeverOvniMedioMuerto, withKey: "laserOvniMedioMuerto")
                 })
        }
            
        else if(iConteo == 10)
        {
           
            iNumeroDeVidasOvni += 1
            let explosion = SKEmitterNode(fileNamed: "Fire")!
            explosion.position = CGPoint(x: miEnemigo.position.x, y: miEnemigo.position.y )
            miEnemigo1MedioMuerto.removeFromParent()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            laserOvni.removeFromParent()
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            score += 20
            self.run(SKAction.wait(forDuration: 2.55))
            {
                explosion.removeFromParent()
               
            }
            removeAction(forKey: "laserOvniMedioMuerto")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7), execute: {
                self.createEnemigo2Abajo()
                self.createEnemigo2Arriba()
                
                let spawnOvniLaserArriba = SKAction.run({
                    ()
                    in self.createLaserOvniArriba()
                })
                let delayLaserOvniArriba = SKAction.wait(forDuration: 1.5)
                let spawnDelayLaserOvniArriba = SKAction.sequence([spawnOvniLaserArriba, delayLaserOvniArriba])
                let spawnDelayForeverOvniArriba = SKAction.repeatForever(spawnDelayLaserOvniArriba)
                self.run(spawnDelayForeverOvniArriba, withKey: "laserOvniArriba")
                
                let spawnOvniLaserAbajo = SKAction.run({
                    ()
                    in self.createLaserOvniAbajo()
                })
                let delayLaserOvniAbajo = SKAction.wait(forDuration: 1.5)
                let spawnDelayLaserOvniAbajo = SKAction.sequence([spawnOvniLaserAbajo, delayLaserOvniAbajo])
                let spawnDelayForeverOvniAbajo = SKAction.repeatForever(spawnDelayLaserOvniAbajo)
                self.run(spawnDelayForeverOvniAbajo, withKey: "laserOvniAbajo")
            })
                
            
        }
        
       if(iConteoArriba == 5)
        {
            iConteoArriba += 1
            iNumeroDeVidasOvni += 1
            let explosion = SKEmitterNode(fileNamed: "Fire")!
            explosion.position = CGPoint(x: miEnemigo2Arriba.position.x, y: miEnemigo2Arriba.position.y )
            miEnemigo2Arriba.removeFromParent()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            laserOvni.removeFromParent()
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            score += 10
            self.run(SKAction.wait(forDuration: 2.75))
            {
                explosion.removeFromParent()
                
            }
            
            removeAction(forKey: "laserOvniArriba")
            
        }
       else if(iConteoArriba == 11)
       {
        iConteoArriba += 1
        iNumeroDeVidasOvni += 1
        let explosion = SKEmitterNode(fileNamed: "Fire")!
        explosion.position = CGPoint(x: miEnemigo2ArribaMedioMuerto.position.x, y: miEnemigo2ArribaMedioMuerto.position.y )
        miEnemigo2ArribaMedioMuerto.removeFromParent()
        laserOvni.removeFromParent()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        score += 20
        self.run(SKAction.wait(forDuration: 2.75))
        {
            explosion.removeFromParent()
            
        }
        
        removeAction(forKey: "laserOvniArribaMedioMuerto")
        
        }
       
        
        if(iConteoAbajo == 5)
        {
            iConteoAbajo += 1
            iNumeroDeVidasOvni += 1
            let explosion = SKEmitterNode(fileNamed: "Fire")!
            explosion.position = CGPoint(x: miEnemigo2Abajo.position.x, y: miEnemigo2Abajo.position.y )
            miEnemigo2Abajo.removeFromParent()
            laserOvni.removeFromParent()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            score += 20
            self.run(SKAction.wait(forDuration: 2.75))
            {
                explosion.removeFromParent()
                
            }
            removeAction(forKey: "laserOvniAbajo")
            
        }
        else if(iConteoAbajo == 11)
        {
            iConteoAbajo += 1
            iNumeroDeVidasOvni += 1
            let explosion = SKEmitterNode(fileNamed: "Fire")!
            explosion.position = CGPoint(x: miEnemigo2AbajoMedioMuerto.position.x, y: miEnemigo2AbajoMedioMuerto.position.y )
            miEnemigo2AbajoMedioMuerto.removeFromParent()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            laserOvni.removeFromParent()
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            score += 20
            self.run(SKAction.wait(forDuration: 2.75))
            {
                explosion.removeFromParent()
                
            }
            
            removeAction(forKey: "laserOvniAbajoMedioMuerto")
            
        }
        
        if (iConteoArriba == 6 && iConteoAbajo == 6)
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7), execute: {
                self.createEnemigo2AbajoMedioMuerto()
                self.createEnemigo2ArribaMedioMuerto()
                
                let spawnOvniLaserArribaMedioMuerto = SKAction.run({
                    ()
                    in self.createLaserOvniArribaMedioMuerto()
                })
                let delayLaserOvniArribaMedioMuerto = SKAction.wait(forDuration: 1.4)
                let spawnDelayLaserOvniArribaMedioMuerto = SKAction.sequence([spawnOvniLaserArribaMedioMuerto, delayLaserOvniArribaMedioMuerto])
                let spawnDelayForeverOvniArribaMedioMuerto = SKAction.repeatForever(spawnDelayLaserOvniArribaMedioMuerto)
                self.run(spawnDelayForeverOvniArribaMedioMuerto, withKey: "laserOvniArribaMedioMuerto")
                
                let spawnOvniLaserAbajoMedioMuerto = SKAction.run({
                    ()
                    in self.createLaserOvniAbajoMedioMuerto()
                })
                let delayLaserOvniAbajoMedioMuerto = SKAction.wait(forDuration: 1.4)
                let spawnDelayLaserOvniAbajoMedioMuerto = SKAction.sequence([spawnOvniLaserAbajoMedioMuerto, delayLaserOvniAbajoMedioMuerto])
                let spawnDelayForeverOvniAbajoMedioMuerto = SKAction.repeatForever(spawnDelayLaserOvniAbajoMedioMuerto)
                self.run(spawnDelayForeverOvniAbajoMedioMuerto, withKey: "laserOvniAbajoMedioMuerto")
            })
        }
        else if (iConteoArriba == 12 && iConteoAbajo == 12)
        {
            iConteoArriba += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                self.createEnemigoGrande()
                
                let spawnOvniLaserGrande = SKAction.run({
                    ()
                    in self.createLaserOvniGrande()
                })
                let delayLaserOvniGrande = SKAction.wait(forDuration: 1.2)
                let spawnDelayLaserOvniGrande = SKAction.sequence([spawnOvniLaserGrande, delayLaserOvniGrande])
                let spawnDelayForeverOvniGrande = SKAction.repeatForever(spawnDelayLaserOvniGrande)
                self.run(spawnDelayForeverOvniGrande, withKey: "laserOvniGrande")
            })
        }
        
        if(iConteoEnemigoGrande == 15)
        {
         
            removeAction(forKey: "laserOvniGrande")
            score += 50
            let explosion = SKEmitterNode(fileNamed: "Fire")!
            explosion.position = CGPoint(x: miEnemigoGrande.position.x, y: miEnemigoGrande.position.y )
            miEnemigoGrande.removeFromParent()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            laserOvni.removeFromParent()
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            self.run(SKAction.wait(forDuration: 3.75))
            {
                explosion.removeFromParent()
                
            }
            self.muerto = true
            removeAllActions()
            createRestartButton()
           crearEtiquetaWinner()
        }
        
        
    }
    /*Nombre:createNave
     Descripción: Se crea la nave, su tamño,posicion innicial, cuerpo fisico,se le asigna bitMask de miNave, afectado por la gravedad, y que se pueda mover y se mencionan los objetos con los que puede colisionar. */
    
   func createNave()
   {
    miNave = SKSpriteNode(imageNamed: "nave")
    miNave.position = CGPoint(x: self.frame.midX - 270, y: self.frame.midY)
    miNave.setScale(0.09)
    miNave.physicsBody = SKPhysicsBody(rectangleOf: miNave.size)
    miNave.physicsBody?.categoryBitMask = CuerpoFisico.miNave
    miNave.physicsBody?.collisionBitMask = CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo
    |  CuerpoFisico.miLaserEnemigo1MedioMuerto | CuerpoFisico.laserOvniAbajo | CuerpoFisico.laserOvniArriba
    miNave.physicsBody?.contactTestBitMask = CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo |  CuerpoFisico.miLaserEnemigo1MedioMuerto | CuerpoFisico.laserOvniAbajo | CuerpoFisico.laserOvniArriba
    miNave.physicsBody?.isDynamic = true 
    miNave.physicsBody?.affectedByGravity = true
    self.addChild(miNave)
 
    }
    
    /*Nombre:createEnemigo
     Descripción: Se crea el ovni, su tamño,posicion innicial, cuerpo fisico,se le asigna bitMask, NO afectado por la gravedad, NO es dinamico y se mencionan los objetos con los que puede colisionar. */

    func createEnemigo(){
        miEnemigo1 = SKSpriteNode(imageNamed: "ovnivivo")
       
        miEnemigo1.position = CGPoint(x: self.frame.midX + 270, y: -20)
        
        miEnemigo1.setScale(0.16)
        miEnemigo1.physicsBody = SKPhysicsBody(rectangleOf: miEnemigo1.size)
        miEnemigo1.physicsBody?.categoryBitMask = CuerpoFisico.miEnemigo1
        miEnemigo1.physicsBody?.collisionBitMask = CuerpoFisico.miLaser
        miEnemigo1.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser
        miEnemigo1.physicsBody?.affectedByGravity = false
        miEnemigo1.physicsBody?.isDynamic = false
        miEnemigo1.physicsBody?.pinned = false
        self.addChild(miEnemigo1)
        
    }
    
    /*Nombre:createEnemigoMedioMuerto
     Descripción: Se crea el ovni mediomuerto, su tamño,posicion innicial, cuerpo fisico,se le asigna bitMask, NO afectado por la gravedad, NO es dinamico y se mencionan los objetos con los que puede colisionar. */
    func createEnemigoMedioMuerto(){
        miEnemigo1MedioMuerto = SKSpriteNode(imageNamed: "ovnimediomuertoverde")
        
        miEnemigo1MedioMuerto.position = CGPoint(x: self.miEnemigo1.position.x, y: self.miEnemigo1.position.y)
        
        miEnemigo1MedioMuerto.setScale(0.8)
        miEnemigo1MedioMuerto.physicsBody = SKPhysicsBody(rectangleOf: miEnemigo1MedioMuerto.size)

        miEnemigo1MedioMuerto.physicsBody?.categoryBitMask = CuerpoFisico.miEnemigo1MedioMuerto
        miEnemigo1MedioMuerto.physicsBody?.collisionBitMask = CuerpoFisico.miLaser
        miEnemigo1MedioMuerto.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser
        miEnemigo1MedioMuerto.physicsBody?.affectedByGravity = false
        miEnemigo1MedioMuerto.physicsBody?.isDynamic = false
        miEnemigo1MedioMuerto.physicsBody?.pinned = false
        self.addChild(miEnemigo1MedioMuerto)
        
    }
    
    
    
    
    /*Nombre: createEnemigo2Arriba
     Descripción: Se crea el ovni 2 de Arriba, su tamño,posicion innicial, cuerpo fisico,se le asigna bitMask, NO afectado por la gravedad, NO es dinamico y se mencionan los objetos con los que puede colisionar. */
    func createEnemigo2Arriba(){
        miEnemigo2Arriba = SKSpriteNode(imageNamed: "ovniamarillovivo")
        
        miEnemigo2Arriba.position = CGPoint(x: self.miEnemigo1MedioMuerto.position.x, y:  100)
        
        miEnemigo2Arriba.setScale(0.7)
        miEnemigo2Arriba.physicsBody = SKPhysicsBody(rectangleOf: miEnemigo2Arriba.size)
  
        miEnemigo2Arriba.physicsBody?.categoryBitMask = CuerpoFisico.miEnemigo2Arriba
        miEnemigo2Arriba.physicsBody?.collisionBitMask = CuerpoFisico.miLaser
        miEnemigo2Arriba.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser
        miEnemigo2Arriba.physicsBody?.affectedByGravity = false
        miEnemigo2Arriba.physicsBody?.isDynamic = false
        miEnemigo2Arriba.physicsBody?.pinned = false
        self.addChild(miEnemigo2Arriba)
        
    }
    /*Nombre: createEnemigo2Abajo
     Descripción: Se crea el ovni 2 de abajo, su tamño,posicion innicial, cuerpo fisico,se le asigna bitMask, NO afectado por la gravedad, NO es dinamico y se mencionan los objetos con los que puede colisionar. */

    func createEnemigo2Abajo(){
        miEnemigo2Abajo = SKSpriteNode(imageNamed: "ovnivivorosa")
        
        miEnemigo2Abajo.position = CGPoint(x: self.miEnemigo1MedioMuerto.position.x, y:  -100)
        
        miEnemigo2Abajo.setScale(0.7)
        miEnemigo2Abajo.physicsBody = SKPhysicsBody(rectangleOf: miEnemigo2Abajo.size)

        miEnemigo2Abajo.physicsBody?.categoryBitMask = CuerpoFisico.miEnemigo2Abajo
        miEnemigo2Abajo.physicsBody?.collisionBitMask = CuerpoFisico.miLaser
        miEnemigo2Abajo.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser
        miEnemigo2Abajo.physicsBody?.affectedByGravity = false
        miEnemigo2Abajo.physicsBody?.isDynamic = false
        miEnemigo2Abajo.physicsBody?.pinned = false
        self.addChild(miEnemigo2Abajo)
        
    }
    
    /*Nombre: createEnemigo2ArribaMedioMuerto
     Descripción: Se crea el ovni mediomuerto 2 de arriba, su tamño,posicion innicial, cuerpo fisico,se le asigna bitMask, NO afectado por la gravedad, NO es dinamico y se mencionan los objetos con los que puede colisionar. */
    func createEnemigo2ArribaMedioMuerto()
    {
      
        miEnemigo2ArribaMedioMuerto = SKSpriteNode(imageNamed: "ovnimediomuertoamarillo")
        
        miEnemigo2ArribaMedioMuerto.position = CGPoint(x: self.miEnemigo2Arriba.position.x, y:  self.miEnemigo2Arriba.position.y)
        
        miEnemigo2ArribaMedioMuerto.setScale(0.7)
        miEnemigo2ArribaMedioMuerto.physicsBody = SKPhysicsBody(rectangleOf: miEnemigo2ArribaMedioMuerto.size)
 
        miEnemigo2ArribaMedioMuerto.physicsBody?.categoryBitMask = CuerpoFisico.miEnemigo2ArribaMedioMuerto
        miEnemigo2ArribaMedioMuerto.physicsBody?.collisionBitMask = CuerpoFisico.miLaser
        miEnemigo2ArribaMedioMuerto.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser
        miEnemigo2ArribaMedioMuerto.physicsBody?.affectedByGravity = false
        miEnemigo2ArribaMedioMuerto.physicsBody?.isDynamic = false
        miEnemigo2ArribaMedioMuerto.physicsBody?.pinned = false
        self.addChild(miEnemigo2ArribaMedioMuerto)
    }
    
    
    /*Nombre: createEnemigo2AbajoMedioMuerto
     Descripción: Se crea el ovni mediomuerto 2 de abajo, su tamño,posicion inicial, cuerpo físico,se le asigna bitMask, NO afectado por la gravedad, NO es dinámico y se mencionan los objetos con los que puede colisionar. */
    func createEnemigo2AbajoMedioMuerto()
    {
        
        miEnemigo2AbajoMedioMuerto = SKSpriteNode(imageNamed: "ovnimediomuertorosa")
        
        miEnemigo2AbajoMedioMuerto.position = CGPoint(x: self.miEnemigo2Abajo.position.x, y:  self.miEnemigo2Abajo.position.y)
        
        miEnemigo2AbajoMedioMuerto.setScale(0.7)
        miEnemigo2AbajoMedioMuerto.physicsBody = SKPhysicsBody(rectangleOf: miEnemigo2AbajoMedioMuerto.size)
        
        miEnemigo2AbajoMedioMuerto.physicsBody?.categoryBitMask = CuerpoFisico.miEnemigo2AbajoMedioMuerto
        miEnemigo2AbajoMedioMuerto.physicsBody?.collisionBitMask = CuerpoFisico.miLaser
        miEnemigo2AbajoMedioMuerto.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser
        miEnemigo2AbajoMedioMuerto.physicsBody?.affectedByGravity = false
        miEnemigo2AbajoMedioMuerto.physicsBody?.isDynamic = false
        miEnemigo2AbajoMedioMuerto.physicsBody?.pinned = false
        self.addChild(miEnemigo2AbajoMedioMuerto)
    }
    
    
    /*Nombre: createEnemigoGrande
     Descripción: Se crea el ovni Grande,su tamño,posición inicial, cuerpo físico,se le asigna bitMask, NO afectado por la gravedad, NO es dinámico y se mencionan los objetos con los que puede colisionar, y aparece depsués de 10 seg. */
    func createEnemigoGrande()
    {
  
        miEnemigoGrande = SKSpriteNode(imageNamed: "ovniblancovivo")
        
        miEnemigoGrande.position = CGPoint(x: self.miEnemigo1.position.x, y:  self.miEnemigo1.position.y)
        
        miEnemigoGrande.setScale(1.3)
        miEnemigoGrande.physicsBody = SKPhysicsBody(rectangleOf: miEnemigoGrande.size)

        miEnemigoGrande.physicsBody?.categoryBitMask = CuerpoFisico.miEnemigoGrande
        miEnemigoGrande.physicsBody?.collisionBitMask = CuerpoFisico.miLaser
        miEnemigoGrande.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser
        miEnemigoGrande.physicsBody?.affectedByGravity = false
        miEnemigoGrande.physicsBody?.isDynamic = false
        miEnemigoGrande.physicsBody?.pinned = false
        self.addChild(miEnemigoGrande)
    }
    
    /*Nombre: crearEtiqueta
     Descripción:Se crea el score como Label, con valor inicial de 0, se coloca en una posición fija y se modifican sus propiedades del texto. */
    func crearEtiqueta(){
        
        etiquetaConScore = SKLabelNode(text: "Score: 0")
        etiquetaConScore.position = CGPoint(x: 250, y: 120)
        etiquetaConScore.fontSize = 25
        etiquetaConScore.fontName = "HelveticaNeue"
        etiquetaConScore.fontColor = UIColor.white
        score = 0
        self.addChild(etiquetaConScore)
    }
    
    func crearEtiquetaWinner(){
        
        etiquetaWinner = SKLabelNode(text: "Winner")
        etiquetaWinner.position = CGPoint(x: 0, y: 120)
        etiquetaWinner.fontSize = 35
        etiquetaWinner.fontName = "HelveticaNeue"
        etiquetaWinner.fontColor = UIColor.white
        self.addChild(etiquetaWinner)
    }
    
    /*Nombre: crearAnimacionDeAsteroides
     Descripción:Se crea los dos tipos de asteroides en intervalos de tiempo y tambien de las moendas y las vidas*/
    
    func crearAnimacionDeAsteroides()
    {
        

     
        
        let spawnVida = SKAction.run({
            ()
            in self.crearVida()
        })
        let delayVida = SKAction.wait(forDuration: 18)
        let spawnDelayVida = SKAction.sequence([spawnVida, delayVida])
        let spawnDelayForeverVida = SKAction.repeatForever(spawnDelayVida)
        self.run(spawnDelayForeverVida, withKey: "Vida")
        
        let spawnMoneda = SKAction.run({
            ()
            in self.crearMonedas()
        })
        let delayMoneda = SKAction.wait(forDuration: 5)
        let spawnDelayMoneda = SKAction.sequence([spawnMoneda, delayMoneda])
        let spawnDelayForeverMoneda = SKAction.repeatForever(spawnDelayMoneda)
        self.run(spawnDelayForeverMoneda, withKey: "Moneda")
        
        
        
    }
    
    
    /*Nombre: crearScene
     Descripción:Se crea el escenario y se llaman todas las funciones que crean los spriteNodes iniciales*/
    func createScene()
    {
        paredAbajo()
        paredArriba()
        createNave()
        createEnemigo()
        
        //Agregar etiqueta
        crearEtiqueta()
        crearAnimacionDeAsteroides()
        backgroundColor = (UIColor.black)
        
        self.physicsWorld.contactDelegate = self
        
        //LLamamos a la función crear estrellas
        crearFondoEstrellas()
        // Se pone el giroscopio con el manager anteriormente declarado, con updates de 0.1s
        managerDeCoreMotion.startGyroUpdates()
        managerDeCoreMotion.gyroUpdateInterval = 0.1
        managerDeCoreMotion.startGyroUpdates(to: OperationQueue.current!){
            (data : CMGyroData?, error : Error?) in
            if let giroscopio = data {
                let aceleracion = giroscopio.rotationRate.y
                self.physicsWorld.gravity = CGVector(dx: 0, dy: CGFloat((aceleracion)) * 5)
            }
            
        }
        
      if(iNumeroDeVidasOvni == 0)
        {
            let spawnOvniLaser = SKAction.run({
                ()
                in self.createLaserOvni()
            })
            let delayLaserOvni = SKAction.wait(forDuration: 1.7)
            let spawnDelayLaserOvni = SKAction.sequence([spawnOvniLaser, delayLaserOvni])
            let spawnDelayForeverOvni = SKAction.repeatForever(spawnDelayLaserOvni)
            self.run(spawnDelayForeverOvni, withKey: "laserOvni")
        }
       
        
        let spawn = SKAction.run({
            ()
            in self.createAsteroids()
            self.createNuevosAsteroides()
        })
        let delayAsteroids = SKAction.wait(forDuration: 0.85)
        let spawnDelay = SKAction.sequence([spawn, delayAsteroids])
        let spawnDelayForeverAsteroids = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForeverAsteroids, withKey: "asteroids")
        
       
    }
   
    
    /*Nombre:createNave2
     Descripción:  Se crea la nave 2,su tamño,posición inicial, cuerpo físico,se le asigna bitMask,afectado por la gravedad, es dinámico y se mencionan los objetos con los que puede colisionar, y aparece depsués de 10 seg.*/
    func createNave2()
    {
        miNave2 = SKSpriteNode(imageNamed: "navemediomuerta")
        miNave2.position = CGPoint(x: self.miNave.position.x, y: self.miNave.position.y)
        miNave2.setScale(0.09)
        miNave2.physicsBody = SKPhysicsBody(rectangleOf: miNave2.size)
        miNave2.physicsBody?.categoryBitMask = CuerpoFisico.miNaveMedioMuerta
        miNave2.physicsBody?.collisionBitMask = CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 |  CuerpoFisico.miLaserEnemigo1MedioMuerto | CuerpoFisico.laserOvniAbajo | CuerpoFisico.laserOvniArriba | CuerpoFisico.miVida
        miNave2.physicsBody?.contactTestBitMask = CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo |  CuerpoFisico.miLaserEnemigo1MedioMuerto | CuerpoFisico.laserOvniAbajo | CuerpoFisico.laserOvniArriba | CuerpoFisico.miVida | CuerpoFisico.miMoneda
        miNave2.physicsBody?.isDynamic = true
        miNave2.physicsBody?.affectedByGravity = true
        self.addChild(miNave2)
    }
    
    
    /*Nombre:createNave3
     Descripción:  Se crea la nave 2,su tamaño,posición inicial, cuerpo físico,se le asigna bitMask,afectado por la gravedad, es dinámico y se mencionan los objetos con los que puede colisionar, y aparece depsués de 10 seg.*/
    func createNave3()
    {
        miNave3 = SKSpriteNode(imageNamed: "navemuerta")
        miNave3.position = CGPoint(x: self.miNave2.position.x, y: self.miNave2.position.y)
        miNave3.setScale(0.09)
        miNave3.physicsBody = SKPhysicsBody(rectangleOf: miNave3.size)
        miNave3.physicsBody?.categoryBitMask = CuerpoFisico.miNaveMuerta
        miNave3.physicsBody?.collisionBitMask = CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 |  CuerpoFisico.miLaserEnemigo1MedioMuerto | CuerpoFisico.laserOvniAbajo | CuerpoFisico.laserOvniArriba | CuerpoFisico.miVida
        miNave3.physicsBody?.contactTestBitMask = CuerpoFisico.miAsteroideNuevo  | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 |  CuerpoFisico.miLaserEnemigo1MedioMuerto | CuerpoFisico.laserOvniAbajo | CuerpoFisico.laserOvniArriba | CuerpoFisico.miVida
        miNave3.physicsBody?.isDynamic = true
        miNave3.physicsBody?.affectedByGravity = true
        self.addChild(miNave3)
    }
    
  
   
    /*Nombre:createNuevoLaser
     Descripción: Crea nuevo laser de miNave y sus propiedades*/
    func createLaser()
    {
       
        laser = SKSpriteNode(imageNamed: "laserRojo")
        laser.setScale(0.09)
        laser.position = CGPoint(x: miNave.position.x + 70, y: miNave.position.y )
       
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        self.addChild(laser)
        
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.usesPreciseCollisionDetection = true

        laser.physicsBody?.categoryBitMask = CuerpoFisico.miLaser
        laser.physicsBody?.collisionBitMask = CuerpoFisico.miEnemigo1 | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miEnemigo1MedioMuerto |  CuerpoFisico.miLaserEnemigo1MedioMuerto | CuerpoFisico.miEnemigo2Abajo | CuerpoFisico.miEnemigo2Arriba
        laser.physicsBody?.contactTestBitMask = CuerpoFisico.miEnemigo1 | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miEnemigo1MedioMuerto
        |  CuerpoFisico.miLaserEnemigo1MedioMuerto | CuerpoFisico.miEnemigo2Abajo | CuerpoFisico.miEnemigo2Arriba
        
        
        let vectorLaser = CGVector(dx: 5, dy: 0)
        laser.physicsBody?.applyImpulse(vectorLaser)
        let animacionDeLaser = 0.95
        var arrayDeLaser = [SKAction]()
        arrayDeLaser.append(SKAction.move(by: vectorLaser, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaser.append(SKAction.removeFromParent())
        laser.run(SKAction.sequence(arrayDeLaser))
        
    }
    
    /*Nombre: createNuevoLaserForNaveMuerta
     Descripción: Crea laser para miNave muerta*/
      func createNuevoLaser()
    {
        
        laserMedioMuerto = SKSpriteNode(imageNamed: "laserRojo")
        laserMedioMuerto.setScale(0.09)
        laserMedioMuerto.position = CGPoint(x: miNave2.position.x + 70, y: miNave2.position.y )
        
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        self.addChild(laserMedioMuerto)
        
        laserMedioMuerto.physicsBody = SKPhysicsBody(rectangleOf: laserMedioMuerto.size)
        laserMedioMuerto.physicsBody?.affectedByGravity = false
        laserMedioMuerto.physicsBody?.isDynamic = true
        laserMedioMuerto.physicsBody?.usesPreciseCollisionDetection = true
        laserMedioMuerto.physicsBody?.categoryBitMask = CuerpoFisico.miLaser
        laserMedioMuerto.physicsBody?.collisionBitMask = CuerpoFisico.miEnemigo1 | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miEnemigo1MedioMuerto |  CuerpoFisico.miLaserEnemigo1MedioMuerto |  CuerpoFisico.miEnemigo2Arriba |  CuerpoFisico.miEnemigo2Abajo
        laserMedioMuerto.physicsBody?.contactTestBitMask = CuerpoFisico.miEnemigo1 | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miEnemigo1MedioMuerto |  CuerpoFisico.miLaserEnemigo1MedioMuerto |  CuerpoFisico.miEnemigo2Arriba |  CuerpoFisico.miEnemigo2Abajo
        
        let vectorLaser = CGVector(dx: 5, dy: 0)
        laserMedioMuerto.physicsBody?.applyImpulse(vectorLaser)
        let animacionDeLaser = 0.95
        var arrayDeLaser = [SKAction]()
        arrayDeLaser.append(SKAction.move(by: vectorLaser, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaser.append(SKAction.removeFromParent())
        laserMedioMuerto.run(SKAction.sequence(arrayDeLaser))
    }
 
    /*Nombre: createNuevoLaserForNaveMuerta
     Descripción: Crea laser para miNave muerta*/
    func createNuevoLaserForNaveMuerta()
    {
        laserMuerto = SKSpriteNode(imageNamed: "laserRojo")
        laserMuerto.setScale(0.09)
        laserMuerto.position = CGPoint(x: miNave3.position.x + 70, y: miNave3.position.y )
        
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        self.addChild(laserMuerto)
        
        laserMuerto.physicsBody = SKPhysicsBody(rectangleOf: laserMuerto.size)
        laserMuerto.physicsBody?.affectedByGravity = false
        laserMuerto.physicsBody?.isDynamic = true
        laserMuerto.physicsBody?.usesPreciseCollisionDetection = true
        laserMuerto.physicsBody?.categoryBitMask = CuerpoFisico.miLaser
        laserMuerto.physicsBody?.collisionBitMask = CuerpoFisico.miEnemigo1 | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miEnemigo1MedioMuerto |  CuerpoFisico.miLaserEnemigo1MedioMuerto |  CuerpoFisico.miEnemigo2Arriba |  CuerpoFisico.miEnemigo2Abajo
        laserMuerto.physicsBody?.contactTestBitMask = CuerpoFisico.miEnemigo1 | CuerpoFisico.miAsteroide | CuerpoFisico.miLaserEnemigo1 | CuerpoFisico.miAsteroideNuevo | CuerpoFisico.miEnemigo1MedioMuerto |  CuerpoFisico.miLaserEnemigo1MedioMuerto |  CuerpoFisico.miEnemigo2Arriba |  CuerpoFisico.miEnemigo2Abajo
        
        let vectorLaser = CGVector(dx: 5, dy: 0)
        laserMuerto.physicsBody?.applyImpulse(vectorLaser)
        let animacionDeLaser = 0.95
        var arrayDeLaser = [SKAction]()
        arrayDeLaser.append(SKAction.move(by: vectorLaser, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaser.append(SKAction.removeFromParent())
        laserMuerto.run(SKAction.sequence(arrayDeLaser))
    }
    /*Nombre:createLaserOvni
     Descripción: Funcion objective c que crea nuevo laser de ovni y sus propiedades*/
    @objc func createLaserOvni()
    {
        laserOvni = SKSpriteNode(imageNamed: "laserRojo")
        laserOvni.setScale(0.09)
        laserOvni.position = CGPoint(x: miEnemigo1.position.x - 30, y: miEnemigo1.position.y - 12 )
        self.addChild(laserOvni)
        laserOvni.physicsBody = SKPhysicsBody(rectangleOf: laserOvni.size)
        laserOvni.physicsBody?.affectedByGravity = false
        laserOvni.physicsBody?.isDynamic = true

        laserOvni.physicsBody?.categoryBitMask = CuerpoFisico.miLaserEnemigo1
        laserOvni.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        laserOvni.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        let vectorLaserOvni = CGVector(dx: -5.5, dy: 0)
        laserOvni.physicsBody?.applyImpulse(vectorLaserOvni)
        let animacionDeLaser = 3
        var arrayDeLaserOvni = [SKAction]()
        arrayDeLaserOvni.append(SKAction.move(by: vectorLaserOvni, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaserOvni.append(SKAction.removeFromParent())
        laserOvni.run(SKAction.sequence(arrayDeLaserOvni))
    }
    
    /*Nombre:createLaserOvniMedioMuerto
     Descripción: funcion objective c que crea los laser y sus propiedades.*/
    @objc func createLaserOvniMedioMuerto()
    {
        laserOvniNuevo = SKSpriteNode(imageNamed: "laserRojo")
        laserOvniNuevo.setScale(0.09)
        laserOvniNuevo.position = CGPoint(x: miEnemigo1MedioMuerto.position.x - 30, y: miEnemigo1MedioMuerto.position.y - 12 )
        self.addChild(laserOvniNuevo)
        laserOvniNuevo.physicsBody = SKPhysicsBody(rectangleOf: laserOvniNuevo.size)
        laserOvniNuevo.physicsBody?.affectedByGravity = false
        laserOvniNuevo.physicsBody?.isDynamic = true
       
        laserOvniNuevo.physicsBody?.categoryBitMask = CuerpoFisico.miLaserEnemigo1MedioMuerto
        laserOvniNuevo.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        laserOvniNuevo.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        
        let vectorLaserOvni = CGVector(dx: -6, dy: 0)
        laserOvniNuevo.physicsBody?.applyImpulse(vectorLaserOvni)
        let animacionDeLaser = 3
        var arrayDeLaserOvni = [SKAction]()
        arrayDeLaserOvni.append(SKAction.move(by: vectorLaserOvni, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaserOvni.append(SKAction.removeFromParent())
        laserOvniNuevo.run(SKAction.sequence(arrayDeLaserOvni))
    }
    
    /*Nombre: createLaserOvniArriba
     Descripción: Crea nuevo laser de OvniArriba y sus propiedades */

    @objc func createLaserOvniArriba()
    {
        laserOvniArriba = SKSpriteNode(imageNamed: "laserRojo")
        laserOvniArriba.setScale(0.09)
        laserOvniArriba.position = CGPoint(x: miEnemigo2Arriba.position.x - 30, y: miEnemigo2Arriba.position.y - 12 )
        self.addChild(laserOvniArriba)
        laserOvniArriba.physicsBody = SKPhysicsBody(rectangleOf: laserOvniArriba.size)
        laserOvniArriba.physicsBody?.affectedByGravity = false
        laserOvniArriba.physicsBody?.isDynamic = true

        laserOvniArriba.physicsBody?.categoryBitMask = CuerpoFisico.laserOvniArriba
        laserOvniArriba.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        laserOvniArriba.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        
        let vectorLaserOvni = CGVector(dx: -7, dy: 0)
        laserOvniArriba.physicsBody?.applyImpulse(vectorLaserOvni)
        let animacionDeLaser = 3
        var arrayDeLaserOvni = [SKAction]()
        arrayDeLaserOvni.append(SKAction.move(by: vectorLaserOvni, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaserOvni.append(SKAction.removeFromParent())
         laserOvniArriba.run(SKAction.sequence(arrayDeLaserOvni))
    }
    /*Nombre: createLaserOvniAbajo
     Descripción: Crea nuevo laser de OvniAbajo y sus propiedades */

    @objc func createLaserOvniAbajo()
    {
        laserOvniAbajo = SKSpriteNode(imageNamed: "laserRojo")
        laserOvniAbajo.setScale(0.09)
        laserOvniAbajo.position = CGPoint(x: miEnemigo2Abajo.position.x - 30, y: miEnemigo2Abajo.position.y - 12 )
        self.addChild(laserOvniAbajo)
        laserOvniAbajo.physicsBody = SKPhysicsBody(rectangleOf:  laserOvniAbajo.size)
        laserOvniAbajo.physicsBody?.affectedByGravity = false
        laserOvniAbajo.physicsBody?.isDynamic = true

        laserOvniAbajo.physicsBody?.categoryBitMask = CuerpoFisico.laserOvniAbajo
        laserOvniAbajo.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        laserOvniAbajo.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        
        let vectorLaserOvni = CGVector(dx: -7, dy: 0)
        laserOvniAbajo.physicsBody?.applyImpulse(vectorLaserOvni)
        let animacionDeLaser = 3
        var arrayDeLaserOvni = [SKAction]()
        arrayDeLaserOvni.append(SKAction.move(by: vectorLaserOvni, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaserOvni.append(SKAction.removeFromParent())
        laserOvniAbajo.run(SKAction.sequence(arrayDeLaserOvni))
    }
    
    
    /*Nombre: createLaserOvniArriba
     Descripción: Crea nuevo laser de OvniArriba y sus propiedades */
    @objc func createLaserOvniArribaMedioMuerto()
    {
        laserOvniArribaMedioMuerto = SKSpriteNode(imageNamed: "laserRojo")
        laserOvniArribaMedioMuerto.setScale(0.09)
        laserOvniArribaMedioMuerto.position = CGPoint(x: miEnemigo2ArribaMedioMuerto.position.x - 30, y: miEnemigo2ArribaMedioMuerto.position.y - 12 )
        self.addChild(laserOvniArribaMedioMuerto)
        laserOvniArribaMedioMuerto.physicsBody = SKPhysicsBody(rectangleOf: laserOvniArribaMedioMuerto.size)
        laserOvniArribaMedioMuerto.physicsBody?.affectedByGravity = false
        laserOvniArribaMedioMuerto.physicsBody?.isDynamic = true

        laserOvniArribaMedioMuerto.physicsBody?.categoryBitMask = CuerpoFisico.laserOvniArriba
        laserOvniArribaMedioMuerto.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        laserOvniArribaMedioMuerto.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        
        let vectorLaserOvni = CGVector(dx: -7.5, dy: 0)
        laserOvniArribaMedioMuerto.physicsBody?.applyImpulse(vectorLaserOvni)
        let animacionDeLaser = 3
        var arrayDeLaserOvni = [SKAction]()
        arrayDeLaserOvni.append(SKAction.move(by: vectorLaserOvni, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaserOvni.append(SKAction.removeFromParent())
        laserOvniArribaMedioMuerto.run(SKAction.sequence(arrayDeLaserOvni))
    }
    
    
    /*Nombre: createLaserOvniAbajoMedioMuerto
     Descripción: Crea nuevo laser de Ovni abajo medio muerto y sus propiedades */
    @objc func createLaserOvniAbajoMedioMuerto()
    {
        laserOvniAbajoMedioMuerto = SKSpriteNode(imageNamed: "laserRojo")
        laserOvniAbajoMedioMuerto.setScale(0.09)
        laserOvniAbajoMedioMuerto.position = CGPoint(x: miEnemigo2AbajoMedioMuerto.position.x - 30, y: miEnemigo2AbajoMedioMuerto.position.y - 12 )
        self.addChild(laserOvniAbajoMedioMuerto)
        laserOvniAbajoMedioMuerto.physicsBody = SKPhysicsBody(rectangleOf:  laserOvniAbajoMedioMuerto.size)
        laserOvniAbajoMedioMuerto.physicsBody?.affectedByGravity = false
        laserOvniAbajoMedioMuerto.physicsBody?.isDynamic = true
  
        laserOvniAbajoMedioMuerto.physicsBody?.categoryBitMask = CuerpoFisico.laserOvniAbajo
        laserOvniAbajoMedioMuerto.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        laserOvniAbajoMedioMuerto.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        
        let vectorLaserOvni = CGVector(dx: -7.5, dy: 0)
        laserOvniAbajoMedioMuerto.physicsBody?.applyImpulse(vectorLaserOvni)
        let animacionDeLaser = 3
        var arrayDeLaserOvni = [SKAction]()
        arrayDeLaserOvni.append(SKAction.move(by: vectorLaserOvni, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaserOvni.append(SKAction.removeFromParent())
         laserOvniAbajoMedioMuerto.run(SKAction.sequence(arrayDeLaserOvni))
    }
    
    /*Nombre: createLaserOvniGrande
     Descripción: Crea nuevo laser de Ovni Grande y sus propiedades */
    @objc func createLaserOvniGrande()
    {
        miLaserEnemigoGrande = SKSpriteNode(imageNamed: "laserRojo")
        miLaserEnemigoGrande.setScale(0.10)
        miLaserEnemigoGrande.position = CGPoint(x: miEnemigoGrande.position.x - 40, y: miEnemigoGrande.position.y - 22 )
        self.addChild(miLaserEnemigoGrande)
        miLaserEnemigoGrande.physicsBody = SKPhysicsBody(rectangleOf:  miLaserEnemigoGrande.size)
        miLaserEnemigoGrande.physicsBody?.affectedByGravity = false
        miLaserEnemigoGrande.physicsBody?.isDynamic = true
        miLaserEnemigoGrande.physicsBody?.categoryBitMask = CuerpoFisico.miLaserEnemigo1MedioMuerto
        miLaserEnemigoGrande.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        miLaserEnemigoGrande.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta  | CuerpoFisico.miNaveMedioMuerta
        
        let vectorLaserOvni = CGVector(dx: -15, dy: 0)
        miLaserEnemigoGrande.physicsBody?.applyImpulse(vectorLaserOvni)
        let animacionDeLaser = 3
        var arrayDeLaserOvni = [SKAction]()
        arrayDeLaserOvni.append(SKAction.move(by: vectorLaserOvni, duration: TimeInterval( animacionDeLaser)))
        arrayDeLaserOvni.append(SKAction.removeFromParent())
        miLaserEnemigoGrande.run(SKAction.sequence(arrayDeLaserOvni))
    }
    
    //Nombre: createAsteorids
    // Descripcion: Crea asteroides en forma de sprite, y los coloca de forma aleatroia
    @objc func createAsteroids()
    {
        var miAsteroide = SKSpriteNode()
        miAsteroide = SKSpriteNode(imageNamed: "asteroide-1")
        let miAsteroideRandomPosicion = GKRandomDistribution(lowestValue: -180, highestValue: 180)
        let posicionDeAsteroide  = CGFloat(miAsteroideRandomPosicion.nextInt())
        miAsteroide.position = CGPoint(x: self.frame.size.width + 20, y: posicionDeAsteroide)
        miAsteroide.setScale(0.5)
        
        miAsteroide.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        miAsteroide.physicsBody?.categoryBitMask = CuerpoFisico.miAsteroide
        miAsteroide.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta | CuerpoFisico.miNaveMedioMuerta
        miAsteroide.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta | CuerpoFisico.miNaveMedioMuerta
        miAsteroide.physicsBody?.affectedByGravity = false
        miAsteroide.physicsBody?.isDynamic = true
        miAsteroide.zPosition = 0
        self.addChild(miAsteroide)
    
        
        let animacionDeAteoride = 4
        
        var arrayDeAcciones = [SKAction]()
        
        arrayDeAcciones.append(SKAction.move(to: CGPoint(x: -miAsteroide.size.width - 450, y: posicionDeAsteroide), duration: TimeInterval(animacionDeAteoride)))
        
        arrayDeAcciones.append(SKAction.removeFromParent())
        
        miAsteroide.run(SKAction.sequence(arrayDeAcciones))
        
        
    }
    
    /*Nombre: createNuevosAsteroides
     Descripción: Crea otro asteroide en forma de sprite, y los coloca de forma aleatroia */
    @objc func createNuevosAsteroides()
    {
        var miAsteroideNuevo = SKSpriteNode()
        miAsteroideNuevo = SKSpriteNode(imageNamed: "asteroide1")
        let miAsteroideNuevoRandomPosicion = GKRandomDistribution(lowestValue: -180, highestValue: 180)
        let posicionDeNuevoAsteroide  = CGFloat(miAsteroideNuevoRandomPosicion.nextInt())
        miAsteroideNuevo.position = CGPoint(x: self.frame.size.width + 20, y: posicionDeNuevoAsteroide)
        miAsteroideNuevo.setScale(0.8)
        
        miAsteroideNuevo.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        miAsteroideNuevo.physicsBody?.categoryBitMask = CuerpoFisico.miAsteroideNuevo
        miAsteroideNuevo.physicsBody?.collisionBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta | CuerpoFisico.miNaveMedioMuerta
        miAsteroideNuevo.physicsBody?.contactTestBitMask = CuerpoFisico.miLaser | CuerpoFisico.miNave | CuerpoFisico.miNaveMuerta | CuerpoFisico.miNaveMedioMuerta
        miAsteroideNuevo.physicsBody?.affectedByGravity = false
        miAsteroideNuevo.physicsBody?.isDynamic = true
        
        self.addChild(miAsteroideNuevo)
        
        
        let animacionDeAteoride = 4
        
        var arrayDeAccionesParaNuevoAsteroide = [SKAction]()
        
        arrayDeAccionesParaNuevoAsteroide.append(SKAction.move(to: CGPoint(x: -miAsteroideNuevo.size.width - 450, y: posicionDeNuevoAsteroide), duration: TimeInterval(animacionDeAteoride)))
        arrayDeAccionesParaNuevoAsteroide.append(SKAction.removeFromParent())
        miAsteroideNuevo.run(SKAction.sequence(arrayDeAccionesParaNuevoAsteroide))
        
        
    }
    //Nombre: ParedArriba
    //Descripcion: Crea una pared arriba de la pantalla para que la nave no se vaya
    func paredArriba()
    {
        let arribaPared = SKSpriteNode()
        arribaPared.size = CGSize(width: 600, height: 5)
        arribaPared.position = CGPoint(x: 0, y: 190)
        arribaPared.physicsBody = SKPhysicsBody(rectangleOf: arribaPared.size)
        arribaPared.physicsBody?.isDynamic = false
        arribaPared.physicsBody?.affectedByGravity = false
        self.addChild(arribaPared)
    }
    //Nombre: ParedAbajo
    //Descripcion: Crea una pared abajo de la pantalla para que la nave no se vaya
    func paredAbajo()
    {
        let abajoPared = SKSpriteNode()
        abajoPared.size = CGSize(width: 600, height: 5)
        abajoPared.position = CGPoint(x: 0, y: -190)
        abajoPared.physicsBody = SKPhysicsBody(rectangleOf: abajoPared.size)
        abajoPared.physicsBody?.isDynamic = false
        abajoPared.physicsBody?.affectedByGravity = false
        self.addChild(abajoPared)
    }
    
    //Nombre: crearFondoEstrellas
    //Crea un fondo donde se pueden ver estrellas pasando
    func crearFondoEstrellas()
    {
        // Se pone a las estrellas como fondo de pantalla
        estrellas = SKEmitterNode(fileNamed: "Stars")
        estrellas.position = CGPoint(x: 300, y: 0)
        estrellas.advanceSimulationTime(10)
        self.addChild(estrellas)
        //se pone en la posicion mas debajo del juego para que se vuelva el fondo
        estrellas.zPosition = -1

        
    }
    //Nombre: createRestartButton
    // Descripción: Hace un boton para volver a jugar el juego
    func createRestartButton()
    {
        restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.setScale(0.9)
        restartButton.position = CGPoint(x: 0, y: 0)
        self.addChild(restartButton)
    }
    
    
    /*Nombre: update
     Descripción: Actualiza el juego modificando los tiempos en que se crean los asteroides, y hace que el ovni persiga a miNave */
    override func update(_ currentTime: TimeInterval) {
      
        if(score > highScore)
        {
            highScore = score
        }
        let highScoreDefault = UserDefaults.standard
        highScoreDefault.setValue(score, forKey: "highScore")
        highScoreDefault.synchronize()
        
        if(iNumeroDeVidas == 0)
        {
        miEnemigo1MedioMuerto.run(SKAction.moveTo(y: miNave.position.y, duration: 0.55))
        }
        else if(iNumeroDeVidas == 1)
        {
            miEnemigo1MedioMuerto.run(SKAction.moveTo(y: miNave2.position.y, duration: 0.55))
        }
        else if(iNumeroDeVidas == 2)
        {
            miEnemigo1MedioMuerto.run(SKAction.moveTo(y: miNave3.position.y, duration: 0.55))
        }
    
        if(iNumeroDeVidas == 0 && miNave.position.y > 0)
        {
            miEnemigo2ArribaMedioMuerto.run(SKAction.moveTo(y: miNave.position.y, duration: 0.55))
        }
        else if(iNumeroDeVidas == 1  && miNave2.position.y > 0)
        {
            miEnemigo2ArribaMedioMuerto.run(SKAction.moveTo(y: miNave2.position.y, duration: 0.55))
        }
        else if(iNumeroDeVidas == 2  && miNave3.position.y > 0)
        {
            miEnemigo2ArribaMedioMuerto.run(SKAction.moveTo(y: miNave3.position.y, duration: 0.55))
        }
        if(iNumeroDeVidas == 0  && miNave.position.y < 0)
        {
            miEnemigo2AbajoMedioMuerto.run(SKAction.moveTo(y: miNave.position.y, duration: 0.55))
        }
        else if(iNumeroDeVidas == 1  && miNave2.position.y < 0)
        {
            miEnemigo2AbajoMedioMuerto.run(SKAction.moveTo(y: miNave2.position.y, duration: 0.55))
        }
        else if(iNumeroDeVidas == 2  && miNave3.position.y < 0 )
        {
            miEnemigo2AbajoMedioMuerto.run(SKAction.moveTo(y: miNave3.position.y, duration: 0.55))
        }
        if(iNumeroDeVidas == 0)
        {
            miEnemigoGrande.run(SKAction.moveTo(y: miNave.position.y, duration: 0.4))
        }
        else if(iNumeroDeVidas == 1)
        {
            miEnemigoGrande.run(SKAction.moveTo(y: miNave2.position.y, duration: 0.4))
        }
        else if(iNumeroDeVidas == 2)
        {
            miEnemigoGrande.run(SKAction.moveTo(y: miNave3.position.y, duration: 0.4))
        }
        
        
    }
    
    @objc func crearVida()
    {
        vida = SKSpriteNode(imageNamed: "surprise")
        
        let miEstrellaRandomPosition = GKRandomDistribution(lowestValue: -150, highestValue: 150)
        let posicionYMiEstrella  = CGFloat(miEstrellaRandomPosition.nextInt())
        vida.position = CGPoint(x: self.frame.size.width + 20, y: posicionYMiEstrella)
        
        vida.size = CGSize(width: 40, height: 40)
        
        vida.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
        
        vida.physicsBody?.categoryBitMask = CuerpoFisico.miVida
        vida.physicsBody?.collisionBitMask =  CuerpoFisico.miNave | CuerpoFisico.miNaveMedioMuerta | CuerpoFisico.miNaveMuerta
        vida.physicsBody?.contactTestBitMask = CuerpoFisico.miNave | CuerpoFisico.miNaveMedioMuerta | CuerpoFisico.miNaveMuerta
        vida.physicsBody?.affectedByGravity = false
        vida.physicsBody?.isDynamic = true
        self.addChild(vida)
        
        
        let animacionDeVida = 5
        
        var arrayDeAcciones = [SKAction]()
        
        arrayDeAcciones.append(SKAction.move(to: CGPoint(x: -vida.size.width - 450, y: posicionYMiEstrella), duration: TimeInterval(animacionDeVida)))
        
        arrayDeAcciones.append(SKAction.removeFromParent())
        
        vida.run(SKAction.sequence(arrayDeAcciones))
    }
    
    @objc func crearMonedas()
    {
        coin = SKSpriteNode(imageNamed: "coin")
        let miCoinRandomPosition = GKRandomDistribution(lowestValue: -150, highestValue: 150)
        let posicionYCoin  = CGFloat(miCoinRandomPosition.nextInt())
        coin.position = CGPoint(x: self.frame.size.width + 20, y: posicionYCoin)
        coin.size = CGSize(width: 60, height: 80)
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 17)
        coin.physicsBody?.categoryBitMask = CuerpoFisico.miMoneda
        coin.physicsBody?.collisionBitMask =  CuerpoFisico.miNave | CuerpoFisico.miNaveMedioMuerta | CuerpoFisico.miNaveMuerta
        coin.physicsBody?.contactTestBitMask = CuerpoFisico.miNave | CuerpoFisico.miNaveMedioMuerta | CuerpoFisico.miNaveMuerta
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = true
        self.addChild(coin)
        
        
        let animacionDeCoin = 5
        
        var arrayDeAcciones = [SKAction]()
        
        arrayDeAcciones.append(SKAction.move(to: CGPoint(x: -coin.size.width - 450, y: posicionYCoin), duration: TimeInterval(animacionDeCoin)))
        
        arrayDeAcciones.append(SKAction.removeFromParent())
        
        coin.run(SKAction.sequence(arrayDeAcciones))
        
    }
    
    
    
    //IMPORTANTES
    
    //ESTE CREA TODO EN LA PANTALLA
    
    override func didMove(to view: SKView) {
       
       backgroundColor = (UIColor.black)
        tittleInstructions = SKLabelNode(text: "Instructions")
        tittleInstructions.position = CGPoint(x: 0, y: 90)
        tittleInstructions.fontSize = 40
        tittleInstructions.fontName = "HelveticaNeue-Bold"
        tittleInstructions.fontColor = UIColor.white
        self.addChild(tittleInstructions)

        instructions = SKLabelNode(text: "Tilt the phone to move the spaceship")
        instructions.position = CGPoint(x: 0, y: 0)
        instructions.fontSize = 30
        instructions.fontName = "HelveticaNeue"
        instructions.fontColor = UIColor.white
        self.addChild(instructions)
        
        instructions2 = SKLabelNode(text: "Get coins, get lifes and avoid the enemies")
        instructions2.position = CGPoint(x: 0, y: -70)
        instructions2.fontSize = 28
        instructions2.fontName = "HelveticaNeue-UltraLight"
        instructions2.fontColor = UIColor.white
        self.addChild(instructions2)
       
    }
    
    
    func restartScene()
    {
       
        
        self.removeAllChildren()
        self.removeAllActions()
        muerto = false
        lapsoEnQueSeCreanLosAsteroides = 0.80
        iConteo = 0
        iConteoArriba  = 0
        iConteoAbajo  = 0
        iConteoEnemigoGrande  = 0
        iNumeroDeVidas  = 0
        iNumeroDeVidasOvni = 0
        score = 0
        createScene()
        
    }
    
    // ESTE HACE ACCIONES PARA CADA TOQUE
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if gameStarted == false{
            gameStarted = true
            tittleInstructions.removeFromParent()
            instructions.removeFromParent()
            instructions2.removeFromParent()
            createScene()
            
          
            
                if(self.iNumeroDeVidas == 0)
                {
                    let delayInSeconds = 0.5
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                        self.createLaser()
                    }
                }
                else if (self.iNumeroDeVidas == 1)
                {
                    let delayInSeconds = 0.5
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                        self.createNuevoLaser()
                    }
                }
                else if (self.iNumeroDeVidas == 2)
                {
                    let delayInSeconds = 0.5
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                        self.createNuevoLaserForNaveMuerta()
                    }
                }
            
    }
        else
        {
            if (muerto == true)
            {
                restartScene()
                iConteo = 0
                iConteoArriba  = 0
                iConteoAbajo  = 0
                iConteoEnemigoGrande  = 0
                iNumeroDeVidas  = 0
                iNumeroDeVidasOvni = 0
            }
            else
            {
          
                if(self.iNumeroDeVidas == 0)
                {
                    let delayInSeconds = 0.2
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                        self.createLaser()
                    }
                }
                else if (self.iNumeroDeVidas == 1)
                {
                    let delayInSeconds = 0.2
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                        self.createNuevoLaser()
                    }
                }
                else if (self.iNumeroDeVidas == 2)
                {
                    let delayInSeconds = 0.2
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                        self.createNuevoLaserForNaveMuerta()
                    }
                }
                
            }
        }
        for touch in touches  {
            let location = touch.location(in: self)
            if muerto == true
            {
                
                if restartButton.contains(location)
                {
                    self.removeAllChildren()
                    self.removeAllActions()
                    iConteo = 0
                    iConteoArriba  = 0
                    iConteoAbajo  = 0
                    iConteoEnemigoGrande  = 0
                    iNumeroDeVidas  = 0
                    iNumeroDeVidasOvni = 0
                    restartScene()
                    
                }
            }
           
        }
    }
    
    
   
    // TIENE LA INFORMACION DE CADA CONTACTO
     //Toda la informacion que pasara cuando dos objetos colapsan
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        
        if firstBody.categoryBitMask == CuerpoFisico.miAsteroide && secondBody.categoryBitMask == CuerpoFisico.miNave ||
            firstBody.categoryBitMask == CuerpoFisico.miNave && secondBody.categoryBitMask == CuerpoFisico.miAsteroide
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave2()
        }
            
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miAsteroide || firstBody.categoryBitMask == CuerpoFisico.miAsteroide && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            
            laserHaColapsadoConAsteroide(laser: firstBody.node as! SKSpriteNode, miAsteroide: secondBody.node as! SKSpriteNode)
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miEnemigo1 ||
            firstBody.categoryBitMask == CuerpoFisico.miEnemigo1 && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
          
            laserHaColapsadoConEnemigo(miEnemigo: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1 && secondBody.categoryBitMask == CuerpoFisico.miNave ||
            firstBody.categoryBitMask == CuerpoFisico.miNave && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave2()
            
        }
            
            
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1 && secondBody.categoryBitMask == CuerpoFisico.miLaser ||
            firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1
        {
            colapsoLaserConLaser(miLaserEnemigo1: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
        }
            
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1 && secondBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave3()
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miAsteroide && secondBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta && secondBody.categoryBitMask == CuerpoFisico.miAsteroide
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave3()
        }
            
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1 && secondBody.categoryBitMask == CuerpoFisico.miNaveMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMuerta && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            self.muerto = true
            //restartScene()
            createRestartButton()
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miNaveMuerta && secondBody.categoryBitMask == CuerpoFisico.miAsteroide ||
            firstBody.categoryBitMask == CuerpoFisico.miAsteroide && secondBody.categoryBitMask == CuerpoFisico.miNaveMuerta
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            self.muerto = true
            createRestartButton()
           // restartScene()
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miAsteroideNuevo && secondBody.categoryBitMask == CuerpoFisico.miNave ||
            firstBody.categoryBitMask == CuerpoFisico.miNave && secondBody.categoryBitMask == CuerpoFisico.miAsteroideNuevo
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave2()
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miAsteroideNuevo || firstBody.categoryBitMask == CuerpoFisico.miAsteroideNuevo && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            
            laserHaColapsadoConAsteroide(laser: firstBody.node as! SKSpriteNode, miAsteroide: secondBody.node as! SKSpriteNode)
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miAsteroideNuevo && secondBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta && secondBody.categoryBitMask == CuerpoFisico.miAsteroideNuevo
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave3()
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miNaveMuerta && secondBody.categoryBitMask == CuerpoFisico.miAsteroideNuevo ||
            firstBody.categoryBitMask == CuerpoFisico.miAsteroideNuevo && secondBody.categoryBitMask == CuerpoFisico.miNaveMuerta
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            self.muerto = true
            createRestartButton()
            //restartScene()
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miEnemigo1MedioMuerto ||
            firstBody.categoryBitMask == CuerpoFisico.miEnemigo1MedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            
            laserHaColapsadoConEnemigo(miEnemigo: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
            
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miNave ||
            firstBody.categoryBitMask == CuerpoFisico.miNave && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave2()
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miLaser ||
            firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto
        {
            colapsoLaserConLaser(miLaserEnemigo1: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
            
            
        }
            
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave3()
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miNaveMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMuerta && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            self.muerto = true
            createRestartButton()
           // restartScene()
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miLaser ||
            firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miLaserEnemigo1MedioMuerto
        {
            colapsoLaserConLaser(miLaserEnemigo1: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miEnemigo2Arriba ||
            firstBody.categoryBitMask == CuerpoFisico.miEnemigo2Arriba && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            iConteoArriba += 1
            
            laserHaColapsadoConEnemigo(miEnemigo: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miEnemigo2Abajo ||
            firstBody.categoryBitMask == CuerpoFisico.miEnemigo2Abajo && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            iConteoAbajo += 1
            laserHaColapsadoConEnemigo(miEnemigo: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miEnemigo1MedioMuerto ||
            firstBody.categoryBitMask == CuerpoFisico.miEnemigo1MedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            
            laserHaColapsadoConEnemigo(miEnemigo: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
            
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.laserOvniAbajo && secondBody.categoryBitMask == CuerpoFisico.miNave ||
            firstBody.categoryBitMask == CuerpoFisico.miNave && secondBody.categoryBitMask == CuerpoFisico.laserOvniAbajo
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave2()
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.laserOvniAbajo && secondBody.categoryBitMask == CuerpoFisico.miLaser ||
            firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.laserOvniAbajo
        {
            colapsoLaserConLaser(miLaserEnemigo1: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
            
            
        }
            
        else if firstBody.categoryBitMask == CuerpoFisico.laserOvniAbajo && secondBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta && secondBody.categoryBitMask == CuerpoFisico.laserOvniAbajo
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave3()
        }
        else if firstBody.categoryBitMask == CuerpoFisico.laserOvniAbajo && secondBody.categoryBitMask == CuerpoFisico.miNaveMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMuerta && secondBody.categoryBitMask == CuerpoFisico.laserOvniAbajo
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            self.muerto = true
            createRestartButton()
            //restartScene()
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.laserOvniArriba && secondBody.categoryBitMask == CuerpoFisico.miNave ||
            firstBody.categoryBitMask == CuerpoFisico.miNave && secondBody.categoryBitMask == CuerpoFisico.laserOvniArriba
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave2()
            
        }
        else if firstBody.categoryBitMask == CuerpoFisico.laserOvniArriba && secondBody.categoryBitMask == CuerpoFisico.miLaser ||
            firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.laserOvniArriba
        {
            colapsoLaserConLaser(miLaserEnemigo1: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
            
            
        }
            
        else if firstBody.categoryBitMask == CuerpoFisico.laserOvniArriba && secondBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta && secondBody.categoryBitMask == CuerpoFisico.laserOvniArriba
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            createNave3()
        }
        else if firstBody.categoryBitMask == CuerpoFisico.laserOvniArriba && secondBody.categoryBitMask == CuerpoFisico.miNaveMuerta ||
            firstBody.categoryBitMask == CuerpoFisico.miNaveMuerta && secondBody.categoryBitMask == CuerpoFisico.laserOvniArriba
        {
            objetoEnemigoHaColapsadoConNave(nave: firstBody.node as! SKSpriteNode, Objeto: secondBody.node as! SKSpriteNode)
            self.muerto = true
            createRestartButton()
           // restartScene()
            
        }
            
            ////////////
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miEnemigo2ArribaMedioMuerto ||
            firstBody.categoryBitMask == CuerpoFisico.miEnemigo2ArribaMedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            iConteoArriba += 1
            
            laserHaColapsadoConEnemigo(miEnemigo: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miEnemigo2AbajoMedioMuerto ||
            firstBody.categoryBitMask == CuerpoFisico.miEnemigo2AbajoMedioMuerto && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            iConteoAbajo += 1
            laserHaColapsadoConEnemigo(miEnemigo: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miLaser && secondBody.categoryBitMask == CuerpoFisico.miEnemigoGrande ||
            firstBody.categoryBitMask == CuerpoFisico.miEnemigoGrande && secondBody.categoryBitMask == CuerpoFisico.miLaser
        {
            iConteoEnemigoGrande += 1
            laserHaColapsadoConEnemigo(miEnemigo: firstBody.node as! SKSpriteNode, miLaser: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miNave && secondBody.categoryBitMask == CuerpoFisico.miVida ||
            firstBody.categoryBitMask == CuerpoFisico.miVida && secondBody.categoryBitMask == CuerpoFisico.miNave
        {
             vidaNueva(miNaveSalvada: firstBody.node  as! SKSpriteNode, miVida: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta && secondBody.categoryBitMask == CuerpoFisico.miVida ||
            firstBody.categoryBitMask == CuerpoFisico.miVida && secondBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta
        {
             vidaNueva(miNaveSalvada: firstBody.node  as! SKSpriteNode, miVida: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miNaveMuerta && secondBody.categoryBitMask == CuerpoFisico.miVida ||
            firstBody.categoryBitMask == CuerpoFisico.miVida && secondBody.categoryBitMask == CuerpoFisico.miNaveMuerta
        {
            vidaNueva(miNaveSalvada: firstBody.node  as! SKSpriteNode, miVida: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miNave && secondBody.categoryBitMask == CuerpoFisico.miMoneda ||
            firstBody.categoryBitMask == CuerpoFisico.miMoneda && secondBody.categoryBitMask == CuerpoFisico.miNave
        {
        
            monedaNueva(miNaveTocando: firstBody.node  as! SKSpriteNode, moneda: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta && secondBody.categoryBitMask == CuerpoFisico.miMoneda ||
            firstBody.categoryBitMask == CuerpoFisico.miMoneda && secondBody.categoryBitMask == CuerpoFisico.miNaveMedioMuerta
        {
           
            monedaNueva(miNaveTocando: firstBody.node  as! SKSpriteNode, moneda: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == CuerpoFisico.miNaveMuerta && secondBody.categoryBitMask == CuerpoFisico.miMoneda ||
            firstBody.categoryBitMask == CuerpoFisico.miMoneda && secondBody.categoryBitMask == CuerpoFisico.miNaveMuerta
        {
      
            monedaNueva(miNaveTocando: firstBody.node  as! SKSpriteNode, moneda: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    
    
}
