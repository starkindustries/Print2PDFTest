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

    @IBOutlet weak var webPreview: UIWebView!
    var htmlComposer: HTMLComposer!
    var HTMLContent: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createInvoiceAsHTML()
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

    @IBAction func exportToPDF(_ sender: AnyObject) {
        htmlComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        showOptionsAlert()
    }
    
    func createInvoiceAsHTML() {
        htmlComposer = HTMLComposer()
        if let invoiceHTML = htmlComposer.renderHTML() {
            webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: htmlComposer.pathToHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertController.Style.alert)
        
        // Preview button
        let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertAction.Style.default) { (action) in
            if let data = self.htmlComposer.data {
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
        if MFMailComposeViewController.canSendMail(), let attachmentData = htmlComposer.data {
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
