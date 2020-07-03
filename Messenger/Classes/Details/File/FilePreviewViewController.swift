//
//  FilePreviewViewController.swift
//  app
//
//  Created by tinhvv-ominext on 7/3/20.
//  Copyright © 2020 KZ. All rights reserved.
//

import UIKit
import WebKit

class FilePreviewViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    lazy var webView: WKWebView = {
       let wv = WKWebView()
        return wv
    }()
    
    var message: RCMessage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.addSubview(webView)
        
        if let rcmessage = message {
            let file = "\(rcmessage.messageId).\(rcmessage.fileExt)"
            let path = Dir.document("media", and: file)
            guard let docDir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                return
            }
            webView.loadFileURL(url, allowingReadAccessTo: docDir)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = contentView.bounds
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
