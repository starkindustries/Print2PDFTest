//
//  InvoiceComposer.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class HTMLComposer: NSObject {

    let pathToHTMLTemplate = Bundle.main.path(forResource: "index", ofType: "html")
    let logoImageURL = "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png"
    var data: Data? = nil
    
    override init() {
        super.init()
    }
    
    func renderHTML() -> String? {
        do {
            // Load the invoice HTML template code into a String variable.
            guard let filePath = pathToHTMLTemplate else { return nil }
            var HTMLContent = try String(contentsOfFile: filePath)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
            return HTMLContent
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        return nil
    }
    
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        // Specify the frame of the A4 page.
        let A4PageWidth: CGFloat = 595.2
        let A4PageHeight: CGFloat = 841.8
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
        
        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 10.0)), forKey: "printableRect")
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        
        data = pdfData as Data
        
        // pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice\(invoiceNumber!).pdf"
        // pdfData.write(toFile: pdfFilename, atomically: true)
        // print(pdfFilename)
    }
}
