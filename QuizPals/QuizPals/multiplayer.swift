//
//  multiplayer.swift
//  QuizPals
//
//  Created by Aaron Buehne on 4/27/18.
//  Copyright © 2018 group10. All rights reserved.
//

import UIKit
import CoreMotion
import MultipeerConnectivity

class multiplayer: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UINavigationControllerDelegate {

    var session: MCSession!
    var peerID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var numQuestions = 0
    var questions = [[String:Any]]()
    var correctAnswer = "F"
    var timer = Timer()
    var time = 20
    var nextTime = -1
    let session1 = URLSession.shared
    let urls = ["http:www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz3.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz4.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz5.json"]
    var Ataps = 0
    var Btaps = 0
    var Ctaps = 0
    var Dtaps = 0
    var grey = UIColor()
    let motionmanager = CMMotionManager()
    var gotSelection = false
    var startPitch = 0.0
    var startYaw = 0.0
    var startRoll = 0.0
    var answerText = " "
    
    @IBOutlet weak var Btn_A: UIButton!
    @IBOutlet weak var Btn_B: UIButton!
    @IBOutlet weak var Btn_C: UIButton!
    @IBOutlet weak var Btn_D: UIButton!
    @IBOutlet weak var Btn_Connect: UIButton!
    @IBOutlet weak var Btn_Restart: UIButton!
    @IBOutlet weak var Lb_Question: UILabel!
    @IBOutlet weak var Lb_Score: UILabel!
    @IBOutlet weak var Lb_Timer: UILabel!
    @IBOutlet weak var Lb_Qnum: UILabel!
    @IBOutlet weak var Lb_Player: UILabel!
    @IBOutlet weak var Lb_LeftPlayer: UILabel!
    @IBOutlet weak var Lb_RightPlayer: UILabel!
    @IBOutlet weak var Lb_TopPlayer: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "quiz", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "quiz", discoveryInfo: nil, session: session)
        
        assistant.start()
        session.delegate = self
        browser.delegate = self

        Btn_A.titleLabel?.adjustsFontSizeToFitWidth = true;
        Btn_B.titleLabel?.adjustsFontSizeToFitWidth = true;
        Btn_C.titleLabel?.adjustsFontSizeToFitWidth = true;
        Btn_D.titleLabel?.adjustsFontSizeToFitWidth = true;

        getJson(urlString: urls[BuehneWork.quiz])
        Ataps = 0
        Btaps = 0
        Ctaps = 0
        Dtaps = 0
    }

    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }

    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

        print("inside didReceiveData")

        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
//            if let receivedChoice = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
//                //TODO: Update the opponents choice in here
//            }
        })
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // Called when a connected peer changes state (for example, goes offline)
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    @IBAction func connect(_ sender: UIButton) {
            present(browser, animated: true, completion: nil)
    }

    func getJson(urlString: String) {
        var quizurl = URL(string: urlString)

        var task = session1.dataTask(with: quizurl!, completionHandler: { (data, response, error) -> Void in

            do {
                print("Reading JSON data")
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                self.numQuestions = json["numberOfQuestions"] as! Int
                self.questions = json["questions"] as! [[String : Any]]
                self.navigationItem.title = json["topic"] as! String
                let question = self.questions[BuehneWork.questionCount - 1]
                let questionSentence = question["questionSentence"]
                self.Lb_Question.text = questionSentence as! String
                let options = question["options"] as! [String:String]
                self.Btn_A.setTitle("A)" + options["A"]!, for: .normal)
                self.Btn_B.setTitle("B)" + options["B"]!, for: .normal)
                self.Btn_C.setTitle("C)" + options["C"]!, for: .normal)
                self.Btn_D.setTitle("D)" + options["D"]!, for: .normal)
                self.Lb_Qnum.text = "Question " + String(BuehneWork.questionCount) + "/" + String(self.numQuestions)
                self.correctAnswer = question["correctOption"] as! String

                OperationQueue.main.addOperation {
                    self.doMain()
                }
            }
            catch _{
                print("Failed")
                BuehneWork.quiz = 0
                self.getJson(urlString: self.urls[BuehneWork.quiz])
            }
        })
        task.resume()
    }

    func doMain() {
        print("Doing main")
        Lb_Score.text = String(BuehneWork.score)

        self.motionmanager.deviceMotionUpdateInterval = 1.0/60.0
        self.motionmanager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)

        time = 20
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        //Lb_Timer = Timer.scheduledTimer(timeInterval: 0.05, target: self,   selector: (#selector(updateDeviceMotion)), userInfo: nil, repeats: true)
        Btn_Restart.titleLabel?.adjustsFontSizeToFitWidth = true
        Btn_Restart.isHidden = true
        Lb_Score.text = String(BuehneWork.score)
    }

    @IBAction func clickedA(_ sender: Any) {
        setGrey()
        Btaps = 0
        Ctaps = 0
        Dtaps = 0
        Ataps = Ataps + 1
        if Ataps == 1 {
            Btn_A.backgroundColor = UIColor.green
        }
        if Ataps == 2{
            nextTime = 3
            Btn_A.backgroundColor = UIColor.blue
            answerText = "A"
            sendChoice()
        }
        if self.correctAnswer == "A" && Ataps == 2{
            BuehneWork.score = BuehneWork.score + 1
            Lb_Score.text = String(BuehneWork.score)
        }
    }
    @IBAction func clickedB(_ sender: Any) {
        setGrey()
        Ataps = 0
        Ctaps = 0
        Dtaps = 0
        Btaps = Btaps + 1
        if Btaps == 1 {
            Btn_B.backgroundColor = UIColor.green
        }
        if Btaps == 2{
            nextTime = 3
            Btn_B.backgroundColor = UIColor.blue
            answerText="B"
            sendChoice()
        }
        if self.correctAnswer == "B" && Btaps == 2{
            BuehneWork.score = BuehneWork.score + 1
            Lb_Score.text = String(BuehneWork.score)
        }
    }
    @IBAction func clickedC(_ sender: Any) {
        setGrey()
        Btaps = 0
        Ataps = 0
        Dtaps = 0
        Ctaps = Ctaps + 1
        if Ctaps == 1 {
            Btn_C.backgroundColor = UIColor.green
        }
        if Ctaps == 2{
            nextTime = 3
            Btn_C.backgroundColor = UIColor.blue
            answerText="C"
            sendChoice()
        }
        if self.correctAnswer == "C" && Ctaps == 2{
            BuehneWork.score = BuehneWork.score + 1
            Lb_Score.text = String(BuehneWork.score)
        }
    }
    @IBAction func clickedD(_ sender: Any) {
        setGrey()
        Btaps = 0
        Ctaps = 0
        Ataps = 0
        Dtaps = Dtaps + 1
        if Dtaps == 1 {
            Btn_D.backgroundColor = UIColor.green
        }
        if Dtaps == 2{
            nextTime = 3
            Btn_D.backgroundColor = UIColor.blue
            answerText="D"
            sendChoice()
        }
        if self.correctAnswer == "D" && Dtaps == 2{
            BuehneWork.score = BuehneWork.score + 1
            Lb_Score.text = String(BuehneWork.score)
        }
    }

    func setGrey(){
        Btn_A.backgroundColor = grey
        Btn_B.backgroundColor = grey
        Btn_C.backgroundColor = grey
        Btn_D.backgroundColor = grey
    }

    func nextQuestion() {
        if BuehneWork.questionCount < numQuestions {
            BuehneWork.questionCount = BuehneWork.questionCount + 1
            self.loadView()
            self.viewDidLoad()
        }
        else {
            Lb_Score.text = "You Win!"
            Btn_Restart.isHidden = false
            timer.invalidate()
        }
    }

    @objc func updateTimer() {
        if time == 120 {
            if let motionData = self.motionmanager.deviceMotion {
                let attitude = motionData.attitude

                startYaw = attitude.yaw
                startRoll = attitude.roll
                startPitch = attitude.pitch
                print(startYaw)
            }
        }
        time = time - 1
        if time >= 0 && nextTime < 0{
            Lb_Timer.text = String(time)
        }

        if nextTime > 0 {
            nextTime = nextTime - 1
            Lb_Question.text = "The correct answer was: " + correctAnswer
            Btn_A.isUserInteractionEnabled = false
            Btn_B.isUserInteractionEnabled = false
            Btn_C.isUserInteractionEnabled = false
            Btn_D.isUserInteractionEnabled = false
        }
        else if nextTime == 0 {
            nextTime = -1
            nextQuestion()
        }

        if time == 0 {
            nextTime = 3
        }

    }

    @IBAction func nextQuiz(_ sender: Any) {
        BuehneWork.quiz = BuehneWork.quiz + 1
        BuehneWork.questionCount = 1
        self.loadView()
        self.viewDidLoad()
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shaked")
            if self.nextTime < 0
            {
                while (!gotSelection)
                {
                    var selection = Int(arc4random()) % 4
                    if selection == 0 && Ataps == 0 {
                        gotSelection = true
                        self.clickedA(self.Btn_A)
                    }
                    if selection == 1 && Btaps == 0 {
                        gotSelection = true
                        self.clickedB(self.Btn_B)
                    }
                    if selection == 2 && Ctaps == 0 {
                        gotSelection = true
                        self.clickedC(self.Btn_C)
                    }
                    if selection == 3 && Dtaps == 0 {
                        gotSelection = true
                        self.clickedD(self.Btn_D)
                    }
                }
                gotSelection = false
            }

        }
    }

    @objc func updateDeviceMotion() {
        if let motionData = self.motionmanager.deviceMotion {
            let attitude = motionData.attitude

            let gravity = motionData.gravity
            let rotation = motionData.rotationRate


            if Ataps == 1 || Btaps == 1 || Ctaps == 1 || Dtaps == 1 {
                if (attitude.roll) >= 1.0{
                    if Ataps == 1 {
                        self.clickedB(self.Btn_B)
                        print("Rolled Right from A")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Ctaps == 1 {
                        self.clickedD(self.Btn_D)
                        print("Rolled Right from C")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
                if (attitude.roll) <= -1.0{
                    if Btaps == 1 {
                        self.clickedA(self.Btn_A)
                        print("Rolled left from B")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Dtaps == 1 {
                        self.clickedC(self.Btn_C)
                        print("Rolled left from D")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
                if (attitude.pitch) >= 1.0{
                    if Ataps == 1 {
                        self.clickedC(self.Btn_C)
                        print("Pitch down from A")
                        print(startPitch)
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Btaps == 1 {
                        self.clickedD(self.Btn_D)
                        print("Pitched down from B")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
                if (attitude.pitch) <= -1.0{
                    if Ctaps == 1 {
                        self.clickedA(self.Btn_A)
                        print("Pitched up from C")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Dtaps == 1 {
                        self.clickedB(self.Btn_B)
                        print("Pitched up from D")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
                if (attitude.yaw - startYaw) >= 1.0 || (attitude.yaw - startYaw) <= -1.0 {
                    print(attitude.yaw - startYaw)
                    if Ataps == 1 {
                        self.clickedA(self.Btn_A)
                        answerText = "A"
                        sendChoice()
                        print("A: Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Btaps == 1 {
                        self.clickedB(self.Btn_B)
                        answerText = "B"
                        sendChoice()
                        print("B: Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Ctaps == 1 {
                        self.clickedC(self.Btn_C)
                        answerText = "C"
                        sendChoice()
                        print("C: Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Dtaps == 1 {
                        self.clickedD(self.Btn_D)
                        answerText = "D"
                        sendChoice()
                        print("D: Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
            }

        }
    }

    // Multiplayer portion for sending info
    func sendChoice() {
        let choice = answerText
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: answerText)
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        updateView(newText: answerText, id: peerID)
    }

    func updateView(newText: String, id: MCPeerID){
        Lb_Player.text = newText
    }
}
