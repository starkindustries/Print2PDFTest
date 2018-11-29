//
//  WebKitViewController.swift
//  Print2PDF
//
//  Created by Zion Perez on 11/29/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import Foundation
import WebKit

class WebKitViewController: UIViewController, WKUIDelegate {
    
    var wkWebView: WKWebView!
    var HTMLContent: String?
    
    // This function sets up the WKWebView
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        wkWebView.uiDelegate = self
        view = wkWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the PDF right barButtonItem
        let pdfButton = UIBarButtonItem(title: "PDF", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PreviewViewController.didPressPDFButton))
        self.navigationItem.setRightBarButtonItems([pdfButton], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load the HTML template
        if let invoiceHTML = HTMLComposer.renderHTML(), let path = HTMLComposer.pathToHTMLTemplate {
            let url = URL(fileURLWithPath: path)
            wkWebView.loadHTMLString(invoiceHTML, baseURL: url)
            HTMLContent = invoiceHTML
        }
    }
    
    @objc func didPressPDFButton(_ sender: AnyObject) {
        guard let html = HTMLContent else { return }
        guard let data = HTMLComposer.exportHTMLContentToPDF(HTMLContent: html) else { return }
        let url = Bundle.main.bundleURL
        wkWebView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: url)
    }
}
