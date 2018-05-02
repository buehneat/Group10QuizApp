//
//  ViewController.swift
//  QuizPals
//
//  Created by Aaron Buehne on 4/24/18.
//  Copyright © 2018 group10. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var gameType: UISegmentedControl!

    var session: MCSession!
    var peerID: MCPeerID!

    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!

    var receivedValue = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "chat", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: session)

        assistant.start()
        session.delegate = self
        browser.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        startQuizButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        
        navigationItem.rightBarButtonItem?.title = "Connect";
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Connect", style: .plain, target: self, action: #selector(connectPeers))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func connectPeers() {
        present(browser, animated: true, completion: nil)
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

        print("Starting peer")
        receivedValue = true
        //self.Start(self.startQuizButton)
        

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

    
    @IBAction func Start(_ sender: Any) {
        if gameType.selectedSegmentIndex == 0 && self.session.connectedPeers.count == 0{
            let viewController = storyboard?.instantiateViewController(withIdentifier: "single")
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        else {
            if self.session.connectedPeers.count > 0 && self.session.connectedPeers.count < 4 {
                if !receivedValue {
                let dataToSend = NSKeyedArchiver.archivedData(withRootObject: true)
                do{ try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)}
                catch _{
                    print("failed")
                }
                }
                let viewController = storyboard?.instantiateViewController(withIdentifier: "multi")
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
        }
    }
    


}

