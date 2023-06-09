//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Mohamed Mostafa on 26/04/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        startButton.layer.cornerRadius = 10
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = .zero
    }
    
    
    @IBAction func startButtonClicked(_ sender: Any) {
        guard !nameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            vc.modalTransitionStyle = .flipHorizontal
            vc.modalPresentationStyle = .fullScreen
            vc.playerName = nameTextField.text! + ":"
            present(vc, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
    }

}

