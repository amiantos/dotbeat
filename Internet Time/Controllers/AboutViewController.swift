//
//  AboutViewController.swift
//  Internet Time
//
//  Created by Brad Root on 12/7/21.
//

import Cocoa

class AboutViewController: NSViewController {

    @IBAction func aboutURLButton(_ sender: NSButton) {
        let url = URL(string: "https://github.com/amiantos/internet-time")!
        NSWorkspace.shared.open(url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
