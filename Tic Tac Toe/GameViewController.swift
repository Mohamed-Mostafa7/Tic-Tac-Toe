//
//  GameViewController.swift
//  Tic Tac Toe
//
//  Created by Mohamed Mostafa on 26/04/2023.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerScoreLabel: UILabel!
    @IBOutlet var computerScoreLabel: UILabel!
    
    @IBOutlet var box1: UIImageView!
    @IBOutlet var box2: UIImageView!
    @IBOutlet var box3: UIImageView!
    @IBOutlet var box4: UIImageView!
    @IBOutlet var box5: UIImageView!
    @IBOutlet var box6: UIImageView!
    @IBOutlet var box7: UIImageView!
    @IBOutlet var box8: UIImageView!
    @IBOutlet var box9: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeButtonClicked(_ sender: UIButton) {
        
    }
   

}
