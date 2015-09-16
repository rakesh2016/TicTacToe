//
//  ViewController.swift
//  attempt3
//
//  Created by Michelle Emamdie on 9/12/15.
//  Copyright © 2015 Michelle Emamdie. All rights reserved.
//

import UIKit


//Used to differentiate who is playing
enum Player: Int {
    case ComputerPlayer = 0, UserPlayer = 1, User1 = 2, User2 = 3
}

class ViewController: UIViewController {
    
    //Contains the 9 image blocks
    @IBOutlet var images: [UIImageView]!
    
    @IBOutlet var scoreLink: UIButton!
    
    //Clears the board
    @IBOutlet var resetBtn : UIButton!
    
    //Message to display whose turn it is and when a win has occurred
    @IBOutlet var userMessage : UILabel!
    
    var numberOfImages = 0
    var plays = [Int:Int]()
    //Check to see if the game is done
    var done = false
    //Check to see if the computer is choosing a move
    var aiDeciding = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for imageView in images {
            
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageClicked:"))
        }
        userMessage.text = "\(player1Name) make the first move!"
        userMessage.hidden = false
    }
    
    func checkForWin(){
        var whoWon = [String:Int]()
        if option == 1 {
            whoWon = ["I":0,"\(player1Name)":1]
        }
        else {
             whoWon = ["\(player1Name)": 2, "\(player2Name)": 3]
        }
        for (key,value) in whoWon {
            if ((plays[6] == value && plays[7] == value && plays[8] == value) || //across the bottom
                (plays[3] == value && plays[4] == value && plays[5] == value) || //across the middle
                (plays[0] == value && plays[1] == value && plays[2] == value) || //across the top
                (plays[6] == value && plays[3] == value && plays[0] == value) || //down the left side
                (plays[7] == value && plays[4] == value && plays[1] == value) || //down the middle
                (plays[8] == value && plays[5] == value && plays[2] == value) || //down the right side
                (plays[6] == value && plays[4] == value && plays[2] == value) || //diagonal
                (plays[8] == value && plays[4] == value && plays[0] == value)){//diagonal
                    somebodyWon(key)
            }
        }
    }
    
                    
    func somebodyWon(winner: String) {
        var foundWinner = false
        userMessage.hidden = false
        userMessage.font = userMessage.font.fontWithSize(30)
        userMessage.text = "Looks like \(winner) won!"
        scoreLink.hidden = false
        resetBtn.hidden = false
        done = true;
        var indexPosition = 0
        print(winner)
        while !foundWinner {
            for(key, value) in scores {
                print(key)
                print(value)
                if winner == "I" {
                    scores["Computer"] = scores["Computer"]!+1
                    print("The winner was found to be the computer")
                    foundWinner = true
                }
                else if key == winner {
                    scores[key] = scores[key]!+1
                    print("The winner was found to be \(key) and their score is \(scores[key])")
                    foundWinner = true
                }
                else if indexPosition == scores.count-1{
                    scores[winner] = 1
                    print("The winner was not already on the list so we added \(winner) to the list and their score is now \(scores[winner]) ")
                    foundWinner = true
                    break
                }
                print("\(key) has won \(scores[key]) times.")
                indexPosition++
            }
        }
    }

    
    
    //Gesture Reocgnizer method
    func imageClicked(reco: UITapGestureRecognizer) {
        var imageViewTapped = reco.view as! UIImageView
        //Prevents the system from recognizing a tap in a box that is already filled
        if(plays[imageViewTapped.tag] == nil) {
            if(option == 1) {
                
                print(plays[imageViewTapped.tag])
                print(aiDeciding)
                print(done)
                
                if plays[imageViewTapped.tag] == nil && !aiDeciding && !done {
                    setImageForSpot(imageViewTapped.tag, player:.UserPlayer)
                }
                checkForWin()
                aiTurn()
            }
            else if option == 2 {
                if plays[imageViewTapped.tag] == nil && !done {
                    if whoseTurn == 1 {
                        setImageForSpot(imageViewTapped.tag, player:.User1)
                        numberOfImages++
                        userMessage.text = "\(player2Name) it is your turn."
                        userMessage.hidden = false
                        whoseTurn = 2
                    }
                    else if whoseTurn == 2 {
                        setImageForSpot(imageViewTapped.tag, player:.User2)
                        numberOfImages++
                        userMessage.text = "\(player1Name) it is your turn."
                        userMessage.hidden = false
                        whoseTurn = 1
                    }
                }
                checkForWin()
                checkTie()
            }
        }
    }
    func checkTie() {
        if numberOfImages == 9  && !done {
            userMessage.hidden = false
            userMessage.font = userMessage.font.fontWithSize(30)
            userMessage.text = "Looks like it is a tie!"
            resetBtn.hidden = false;
            done = true;
        }
    }
    @IBAction func refresh(sender: AnyObject) {
        done = false
        resetBtn.hidden = true
        userMessage.hidden = true
        reset()
    }
    
    @IBAction func resetBtnClicked(sender : UIButton) {
        done = false
        resetBtn.hidden = true
        reset()
    }
    
    func reset() {
        plays = [:]
        images[0].image = nil
        images[1].image = nil
        images[2].image = nil
        images[3].image = nil
        images[4].image = nil
        images[5].image = nil
        images[6].image = nil
        images[7].image = nil
        images[8].image = nil
        userMessage.font = userMessage.font.fontWithSize(21)
        userMessage.text = "\(player1Name), start the new game!"
        numberOfImages = 0
        scoreLink.hidden = true
    }
    
    func setImageForSpot(spot:Int, player: Player){
        var playerMark: String
        if player == .UserPlayer || player == .User1 {
            playerMark = "x"
        }
        else {
            playerMark = "o"
        }
        print("setting spot for \(player.rawValue) spot \(spot)")
        plays[spot] = player.rawValue
        
        images[spot].image = UIImage(named: playerMark)
        
    }
    
    func checkBottom(value value:Int) -> [String]{
        return ["bottom",checkFor(value, inList: [6,7,8])]
    }
    
    func checkMiddleAcross(value value:Int) -> [String]{
        return ["middleHorz",checkFor(value, inList: [3,4,5])]
    }
    
    func checkTop(value value:Int) -> [String]{
        return ["top",checkFor(value, inList: [0,1,2])]
    }
    
    func checkLeft(value value:Int) -> [String]{
        return ["left",checkFor(value, inList: [0,3,6])]
    }
    
    func checkMiddleDown(value value:Int) -> [String]{
        return ["middleVert",checkFor(value, inList: [1,4,7])]
    }
    
    func checkRight(value value:Int) ->  [String]{
        return ["right",checkFor(value, inList: [2,5,8])]
    }
    
    func checkDiagLeftRight(value value:Int) ->  [String]{
        return ["diagRightLeft",checkFor(value, inList: [2,4,6])]
    }
    
    func checkDiagRightLeft(value value:Int) ->  [String]{
        return ["diagLeftRight",checkFor(value, inList: [0,4,8])]
    }
    
    func checkFor(value:Int, inList:[Int]) -> String {
        var conclusion = ""
        for cell in inList {
            if plays[cell] == value {
                conclusion += "1"
            }else{
                conclusion += "0"
            }
        }
        return conclusion
    }
    
    func checkThis(value value:Int) -> [String]{
        return ["right","0"]
    }
    
    func rowCheck(value value:Int) -> [String]?{
        let acceptableFinds = ["011","110","101"]
        var findFuncs = [self.checkThis]
        var algorthmResults = findFuncs[0](value: value)
        for algorthm in findFuncs {
            var algorthmResults = algorthm(value: value)
            let findPattern = acceptableFinds.indexOf(algorthmResults[1])
            if findPattern != nil {
                return algorthmResults
            }
        }
        return nil
    }
    
    func isOccupied(spot:Int) -> Bool {
        print("occupied \(spot)")
        if plays[spot] != nil {
            return true
        }
        return false
    }
    
    func whereToPlay(location:String,pattern:String) -> Int {
        let leftPattern = "011"
        let rightPattern = "110"
        var middlePattern = "101"
        switch location {
        case "top":
            if pattern == leftPattern {
                return 0
            }else if pattern == rightPattern{
                return 2
            }else{
                return 1
            }
        case "bottom":
            if pattern == leftPattern {
                return 6
            }else if pattern == rightPattern{
                return 8
            }else{
                return 7
            }
        case "left":
            if pattern == leftPattern {
                return 0
            }else if pattern == rightPattern{
                return 6
            }else{
                return 3
            }
        case "right":
            if pattern == leftPattern {
                return 2
            }else if pattern == rightPattern{
                return 8
            }else{
                return 5
            }
        case "middleVert":
            if pattern == leftPattern {
                return 1
            }else if pattern == rightPattern{
                return 7
            }else{
                return 4
            }
        case "middleHorz":
            if pattern == leftPattern {
                return 3
            }else if pattern == rightPattern{
                return 5
            }else{
                return 4
            }
        case "diagLeftRight":
            if pattern == leftPattern {
                return 0
            }else if pattern == rightPattern{
                return 8
            }else{
                return 4
            }
        case "diagRightLeft":
            if pattern == leftPattern {
                return 2
            }else if pattern == rightPattern{
                return 6
            }else{
                return 4
            }
            
        default:
            return 4
        }
    }
    
    func firstAvailable(isCorner isCorner:Bool) -> Int? {
        let spots = isCorner ? [0,2,6,8] : [1,3,5,7]
        for spot in spots {
            print("checking \(spot)")
            if !isOccupied(spot) {
                print("not occupied \(spot)")
                return spot
            }
        }
        return nil
    }
    
    
    
    func aiTurn() {
        if done {
            return
        }
        aiDeciding = true
        //We (the computer) have two in a row
        if let result = rowCheck(value: 0){
            print("comp has two in a row")
            let whereToPlayResult = whereToPlay(result[0], pattern: result[1])
            if !isOccupied(whereToPlayResult) {
                setImageForSpot(whereToPlayResult, player: .ComputerPlayer)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        //They (the player) have two in a row
        if let result = rowCheck(value: 1) {
            let whereToPlayResult = whereToPlay(result[0], pattern: result[1])
            if !isOccupied(whereToPlayResult) {
                setImageForSpot(whereToPlayResult, player: .ComputerPlayer)
                aiDeciding = false
                checkForWin()
                return
            }
            
            //Is center available?
        }
        if !isOccupied(4) {
            setImageForSpot(4, player: .ComputerPlayer)
            aiDeciding = false
            checkForWin()
            return
        }
        if let cornerAvailable = firstAvailable(isCorner: true){
            setImageForSpot(cornerAvailable, player: .ComputerPlayer)
            aiDeciding = false
            checkForWin()
            return
        }
        if let sideAvailable = firstAvailable(isCorner: false){
            setImageForSpot(sideAvailable, player: .ComputerPlayer)
            aiDeciding = false
            checkForWin()
            return
        }
        
        userMessage.hidden = false
        userMessage.font = userMessage.font.fontWithSize(30)
        userMessage.text = "Looks like it was a tie!"
        
        reset()

        print(rowCheck(value: 0))
        //        They have two in a row
        print(rowCheck(value: 1))
        
        
        //do we have two in a row
        
        //        1) Win: Ifs you have two in a row, play the third to get three in a row.
        //
        //        2) Block: If the opponent has two in a row, play the third to block them.
        //
        //        3) Fork: Create an opportunity where you can win in two ways.
        //
        //        4) Block Opponent's Fork:
        //
        //        Option 1: Create two in a row to force the opponent into defending, as long as it doesn't result in them creating a fork or winning. For example, if "X" has a corner, "O" has the center, and "X" has the opposite corner as well, "O" must not play a corner in order to win. (Playing a corner in this scenario creates a fork for "X" to win.)
        //
        //        Option 2: If there is a configuration where the opponent can fork, block that fork.
        //
        //        5) Center: Play the center.
        //
        //        6) Opposite Corner: If the opponent is in the corner, play the opposite corner.
        //
        //        7) Empty Corner: Play an empty corner.
        //
        //        8) Empty Side: Play an empty side.
        
        aiDeciding = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}