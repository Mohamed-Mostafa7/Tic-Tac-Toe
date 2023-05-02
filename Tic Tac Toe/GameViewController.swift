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
    @IBOutlet var resetButton: UIButton!
    
    var playerName: String? = ""
    var lastValue = "o"
    
    var playerChoices: [Box] = []
    var computerChoices: [Box] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playerNameLabel.text = playerName
        resetButton.isEnabled = false
        
        createTap(on: box1, type: .one)
        createTap(on: box2, type: .two)
        createTap(on: box3, type: .three)
        createTap(on: box4, type: .four)
        createTap(on: box5, type: .five)
        createTap(on: box6, type: .six)
        createTap(on: box7, type: .seven)
        createTap(on: box8, type: .eight)
        createTap(on: box9, type: .nine)
    }
    
    @IBAction func resetBoardButtonTaped(_ sender: UIButton) {
        resetGame()
        resetButton.isEnabled = false
    }
    
    
    func createTap (on imageView: UIImageView, type box: Box){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.boxClicked(_:)))
        tap.name = box.rawValue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func boxClicked(_ sender: UITapGestureRecognizer) {
        if let name = sender.name {
            let selectedBox = getBox(from: name)
            guard selectedBox.image == nil else { return }
            makeChoice(selectedBox)
            playerChoices.append(Box(rawValue: name)!)
            checkIfWon()
            if !resetButton.isEnabled {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.computerPlay()
                }
            }
        }
    }
    
    func computerPlay() {
        var availablespaces = [UIImageView]()
        var availableBoxes = [Box]()
        for name in Box.allCases {
            let box = getBox(from: name.rawValue)
            if box.image == nil {
                availablespaces.append(box)
                availableBoxes.append(name)
            }
        }
        let bestMove = checkBestMove(availableBoxes: availableBoxes)
        
//        guard availableBoxes.count > 0 else { return }
        if !availablespaces.isEmpty{
            makeChoice(bestMove.0)
            computerChoices.append(bestMove.1)
            checkIfWon()
        }
        
    }
    
    func checkBestMove(availableBoxes: [Box]) -> (UIImageView, Box) {
        // check for empty boxes
        // check if any of them make it win
        // check if any of them can make it lose
        // if none of them will make it win of lose just go random
        let computerImage = lastValue == "o" ? #imageLiteral(resourceName: "ex"): #imageLiteral(resourceName: "oh")
        let winCases = getWinCases()
        for box in availableBoxes {
            for anyCase in winCases {
                if anyCase.contains(box){
                    // Remove the empty box to check if the other two boxes are marked.
                    let indexToDelete = anyCase.firstIndex(of: box)
                    var index = [0,1,2]
                    index.remove(at: indexToDelete!)
                    let firstBox = getBox(from: anyCase[index[0]].rawValue)
                    let secondBox = getBox(from: anyCase[index[1]].rawValue)
                    // Check the two other boxes if they have been marked or not.
                    if firstBox.image != nil, secondBox.image != nil {
                        // Check if they are both marked with computer mark. if both of them have the computer mark then if the computer mark this box it will win.
                        if firstBox.image?.pngData() == computerImage.pngData(), secondBox.image?.pngData() == computerImage.pngData() {
                            let boxToImgView = getBox(from: box.rawValue)
                            return (boxToImgView, box)
                        }
                    }
                }
            }
        }
        
        for box in availableBoxes {
            for anyCase in winCases {
                if anyCase.contains(box){
                    // Remove the empty box to check the other two boxes.
                    let indexToDelete = anyCase.firstIndex(of: box)
                    var index = [0,1,2]
                    index.remove(at: indexToDelete!)
                    let firstBox = getBox(from: anyCase[index[0]].rawValue)
                    let secondBox = getBox(from: anyCase[index[1]].rawValue)
                    // Check the two other boxes if they have been barked.
                    if firstBox.image != nil, secondBox.image != nil {
                        // make sure the two mark are both the player mark. if they are then the computer must mark this box to avoid player from winning.
                        if secondBox.image?.pngData() == firstBox.image?.pngData() {
                            let boxToImgView = getBox(from: box.rawValue)
                            return (boxToImgView, box)
                        }
                    }
                }
            }
        }
        let randomBox = availableBoxes.randomElement()
        let boxToImgView = getBox(from: randomBox!.rawValue)
        return (boxToImgView, randomBox!)
    }
    
    func makeChoice(_ selectedBox: UIImageView) {
        guard selectedBox.image == nil else { return }
        
        if lastValue == "x" {
            selectedBox.image = #imageLiteral(resourceName: "oh")
            lastValue = "o"
        } else {
            selectedBox.image = #imageLiteral(resourceName: "ex")
            lastValue = "x"
        }
    }
    
    func checkIfWon() {
        let correct = getWinCases()
        
        for valid in correct {
            let userMatch = playerChoices.filter{(valid.contains($0))}.count
            let computerMatch = computerChoices.filter{(valid.contains($0))}.count
            
            if userMatch == valid.count {
                playerScoreLabel.text = String((Int(playerScoreLabel.text ?? "0") ?? 0) + 1)
                resetButton.isEnabled = true
                disableAllBoxes()
                break
            } else if computerMatch == valid.count {
                computerScoreLabel.text = String((Int(computerScoreLabel.text ?? "0") ?? 0) + 1)
                resetButton.isEnabled = true
                disableAllBoxes()
                break
            }
        }
        if computerChoices.count + playerChoices.count == 9 {
            resetButton.isEnabled = true
            disableAllBoxes()
        }
        
    }
    
    func getWinCases() -> [[Box]] {
        var correct = [[Box]]()
        let firstRow: [Box] = [.one, .two, .three]
        let secondRow: [Box] = [.four, .five, .six]
        let thirdRow: [Box] = [.seven, .eight, .nine]
        
        let firstCol: [Box] = [.one, .four, .seven]
        let secondCol: [Box] = [.two, .five, .eight]
        let thirdCol: [Box] = [.three, .six, .nine]
        
        let backwordSlash: [Box] = [.one, .five, .nine]
        let forwardSlash: [Box] = [.three, .five, .seven]
        
        correct.append(firstRow)
        correct.append(secondRow)
        correct.append(thirdRow)
        correct.append(firstCol)
        correct.append(secondCol)
        correct.append(thirdCol)
        correct.append(backwordSlash)
        correct.append(forwardSlash)
        
        return correct
    }
    
    func disableAllBoxes() {
        var allBoxesArray = [box1, box2, box3, box4, box5, box6, box7, box8, box9]
        for box in allBoxesArray {
            box?.layer.opacity = 0.5
            box?.isUserInteractionEnabled = false
        }
    }
    
    func enableAllBoxes() {
        var allBoxesArray = [box1, box2, box3, box4, box5, box6, box7, box8, box9]
        for box in allBoxesArray {
            box?.layer.opacity = 1
            box?.isUserInteractionEnabled = true
        }
    }
    
    
    func resetGame() {
        for name in Box.allCases {
            let box = getBox(from: name.rawValue)
            box.image = nil
        }
        lastValue = "o"
        playerChoices = []
        computerChoices = []
        enableAllBoxes()
    }
    
    func getBox(from name: String) -> UIImageView {
        let box = Box(rawValue: name) ?? .one
        switch box {
        case .one:
            return box1
        case .two:
            return box2
        case .three:
            return box3
        case .four:
            return box4
        case .five:
            return box5
        case .six:
            return box6
        case .seven:
            return box7
        case .eight:
            return box8
        case .nine:
            return box9
        }
    }

    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

enum Box: String, CaseIterable {
    case one, two, three, four, five, six, seven, eight, nine
}
