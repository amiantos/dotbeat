//
//  AboutViewController.swift
//  dotBeat
//
//  Created by Brad Root on 12/7/21.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Cocoa

class AboutViewController: NSViewController {

    @IBAction func aboutURLButton(_ sender: NSButton) {
        let url = URL(string: "https://github.com/amiantos/dotbeat")!
        NSWorkspace.shared.open(url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
