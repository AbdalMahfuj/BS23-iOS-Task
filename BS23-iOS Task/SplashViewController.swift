//
//  SplashViewController.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit

class SplashViewController: UIViewController {

    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.text = ""
        printStringWithDelay(string: "⚡️Hey! Welcome to Brain Station 23 Ltd.\niOS Practical Test")
    }
   
    private func printStringWithDelay(string: String) {
        var index = string.startIndex
      
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (timer) in
            self.welcomeLabel.text?.append(string[index])

            index = string.index(after: index)
            
            if index == string.endIndex {
                timer.invalidate()
                self.gotoLanding()
            }
        }
    }
    
    private func gotoLanding() {
        let vc = DashboardViewController.initVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
