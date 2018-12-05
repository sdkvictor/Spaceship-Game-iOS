//
//  PantallaInicial.swift
//  juegoITC
//
//  Created by Alejandro on 01/11/17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

import UIKit


class PantallaInicial: UIViewController {
    
  
    //Se declaran las variables numericas donde se almacenaran el score actual y el mas alto
    var myBestScore = 0
    var myScore = 0
    
    

    
    // Se decalaran las partes de la interfaz gráfica en el controlador de vista para poder manipularlas
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var botonStart: UIButton!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var titulohighscore: UILabel!

    
    
    
    
    //Nombre:viewDidLoad
    //Descripción: En esta función esta todo lo que debe cargarse una vez que se vea la pantalla
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let highScoreDefault = UserDefaults.standard
        if(highScoreDefault.value(forKey: "highScore") != nil)
        {
            myBestScore = highScoreDefault.value(forKey: "highScore") as! NSInteger
            highScore.text = NSString(format: "High Score : %i", myBestScore) as String
        }
     
        
        //La ubicación del titulo del score más alto fuera de la pantalla
        titulohighscore.center.x = self.view.frame.width + 100
        //Animación para que el titulo del score más alto aparezca en el centro de la pantalla, haciendo movimiento en x
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 100, initialSpringVelocity: 5, options: [], animations: ({
            self.titulohighscore.center.x = self.view.frame.width / 2 - 200
        }), completion: nil)
        
    
       
        
             //La ubicación del score mas alto fuera de la pantalla
        highScore.center.x =
            self.view.frame.width + 100
        highScore.text = String(myBestScore)
        //Animación para que el score más alto aparezca en el centro de la pantalla, haciendo movimiento en x
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 100, initialSpringVelocity: 5.0, options: [], animations: ({
            self.highScore.center.x = self.view.frame.width / 2 + 200
        }), completion: nil)
       
        
        
        
        //La ubicación del titulo del juego mas alto fuera de la pantalla
        titulo.center.x = self.view.frame.width + 100
        //Animación para que el titulo del juego aparezca en el centro de la pantalla, haciendo movimiento en x
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 100.0, initialSpringVelocity: 5.0, options: [] , animations: ({
             self.titulo.center.x = self.view.frame.width / 2
        }), completion: nil)
        
        
        
        
        
         //La ubicación boton fuera de la pantalla
        botonStart.center.x = self.view.frame.width + 100
        //Animación para que el boton aparezca en el centro de la pantalla, haciendo movimiento en x
        UIView.animate(withDuration: 1.5, delay: 1.5, usingSpringWithDamping: 100, initialSpringVelocity: 5.0, options: [], animations: ({
        self.botonStart.center.x = self.view.frame.width / 2
        }), completion: nil)
        
        botonStart.layer.cornerRadius = botonStart.frame.height / 2
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    



    

}
