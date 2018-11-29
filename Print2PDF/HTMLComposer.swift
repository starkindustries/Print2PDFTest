//
// 
//  HTMLComposer.swift
// 
//

import UIKit

class HTMLComposer: NSObject {

    static let pathToHTMLTemplate = Bundle.main.path(forResource: "index", ofType: "html")
    static let logoImageURL = "https://i.stack.imgur.com/GKbCl.png"
    
    static func renderHTML() -> String? {
        do {
            // Load the invoice HTML template code into a String variable.
            guard let filePath = HTMLComposer.pathToHTMLTemplate else { return nil }
            var HTMLContent = try String(contentsOfFile: filePath)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
            return HTMLContent
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        return nil
    }
    
    
    static func exportHTMLContentToPDF(HTMLContent: String) -> Data? {
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
        
        return pdfData as Data
        
        // pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice\(invoiceNumber!).pdf"
        // pdfData.write(toFile: pdfFilename, atomically: true)
        // print(pdfFilename)
    }
}
