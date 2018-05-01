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

class multiplayer: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    @IBOutlet weak var Btn_A: UIButton!
    @IBOutlet weak var Btn_B: UIButton!
    @IBOutlet weak var Btn_C: UIButton!
    @IBOutlet weak var Btn_D: UIButton!
    @IBOutlet weak var Btn_Connect: UIButton!
    //TODO: Populate this with questions
    @IBOutlet weak var Lb_Question: UILabel!
    // This with current score
    @IBOutlet weak var Lb_Score: UILabel!
    // Labels to show answer choices
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
                //self.testLabel.text = "Question " + String(BuehneWork.questionCount) + "/" + String(self.numQuestions)
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
        //rtask.cancel()
    }

    func doMain() {
        print("Doing main")
        Lb_Score.text = String(BuehneWork.score)
    }

    func sendChoice(_ sender: UIButton) {
//        let choice = //TODO: Add button choice here
//        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg!)
//        do{
//            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
//        }
//        catch let err {
//            //print("Error in sending data \(err)")
//        }
//        updateChatView(newText: msg!, id: peerID)
    }
}
