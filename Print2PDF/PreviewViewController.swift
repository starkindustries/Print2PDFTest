//
//  PreviewViewController.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import MessageUI


class PreviewViewController: UIViewController, MFMailComposeViewControllerDelegate {

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
        let pdfButton = UIBarButtonItem(title: "PDF", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PreviewViewController.exportToPDF))
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func exportToPDF(_ sender: AnyObject) {
        if let export = exportImmediately, !export {
            print("PDF EXPORTED (DELAYED)")
            data = HTMLComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        }
        showOptionsAlert()
    }
    
    func loadHTMLTemplate() {
        if let invoiceHTML = HTMLComposer.renderHTML(), let path = HTMLComposer.pathToHTMLTemplate {
            if let export = exportImmediately, export {
                print("PDF EXPORTED IMMEDIATELY!")
                data = HTMLComposer.exportHTMLContentToPDF(HTMLContent: invoiceHTML)
            }
            let url = URL(fileURLWithPath: path)
            webPreview.loadHTMLString(invoiceHTML, baseURL: url)
            HTMLContent = invoiceHTML
        }
    }

    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertController.Style.alert)
        
        // Preview button
        let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertAction.Style.default) { (action) in
            if let data = self.data {
                let url = Bundle.main.bundleURL
                self.webPreview.load(data, mimeType: "application/pdf", textEncodingName: "", baseURL: url)
            }
            /*
            if let filename = self.htmlComposer.pdfFilename, let url = URL(string: filename) {
                let request = URLRequest(url: url)
                self.webPreview.loadRequest(request)
            }*/
        }
        // Send email button
        let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertAction.Style.default) { (action) in
            DispatchQueue.main.async {
                self.sendEmail()
            }
        }
        // Nothing button
        let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertAction.Style.default) { (action) in
            // Do nothing
        }
        
        alertController.addAction(actionPreview)
        alertController.addAction(actionEmail)
        alertController.addAction(actionNothing)
        present(alertController, animated: true, completion: nil)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail(), let attachmentData = data {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject("Invoice")
            mailComposeViewController.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: "Invoice")
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    // MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
