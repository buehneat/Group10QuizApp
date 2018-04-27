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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "quiz", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "quiz", discoveryInfo: nil, session: session)
        
        assistant.start()
        session.delegate = self
        browser.delegate = self
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
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    @IBAction func connect(_ sender: UIButton) {
            present(browser, animated: true, completion: nil)
    }
    
}
