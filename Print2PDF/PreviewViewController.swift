//
//  PreviewViewController.swift
//  Print2PDF
//
//

import UIKit
import MessageUI


class PreviewViewController: UIViewController {

    private var webPreview: UIWebView!
    private var HTMLContent: String!
    private var data: Data?
    
    public var exportImmediately: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the webView
        webPreview = UIWebView(frame: UIScreen.main.bounds)
        view = webPreview
        
        // Setup the PDF right barButtonItem
        let pdfButton = UIBarButtonItem(title: "PDF", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PreviewViewController.didPressPDFButton))
        self.navigationItem.setRightBarButtonItems([pdfButton], animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHTMLTemplate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func didPressPDFButton(_ sender: AnyObject) {
        if let export = exportImmediately, !export {
            print("PDF EXPORTED (DELAYED)")
            data = HTMLComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
            print(HTMLContent)
        }
        guard let data = self.data else { return }
        let url = Bundle.main.bundleURL
        self.webPreview.load(data, mimeType: "application/pdf", textEncodingName: "", baseURL: url)
    }
    
    func loadHTMLTemplate() {
        if let invoiceHTML = HTMLComposer.renderHTML(), let path = HTMLComposer.pathToHTMLTemplate {
            if let export = exportImmediately, export {
                print("PDF EXPORTED IMMEDIATELY!")
                data = HTMLComposer.exportHTMLContentToPDF(HTMLContent: invoiceHTML)
                print(invoiceHTML)
            }
            let url = URL(fileURLWithPath: path)
            webPreview.loadHTMLString(invoiceHTML, baseURL: url)
            HTMLContent = invoiceHTML
        }
    }
}
