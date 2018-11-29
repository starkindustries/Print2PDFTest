# Print2PDF Test

This code tests the difference between choosing to render a PDF immediately versus delaying the action until later. When rendering a PDF immediately, the images are not displayed in the PDF. When delayed, the images properly rendered. On inspecting the html strings that are sent to render, one will notice that the HTML strings are exactly the same.

## Overview 
The MainTableViewController has two options (two cells): 
1) Delay PDF Export
2) Export PDF Immediately

When the user clicks either option, the PreviewViewController is pushed. On viewWillAppear, the html template is loaded.
```swift
// PreviewViewController.swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadHTMLTemplate()
}
```

The loadHTMLTemplate() checks if a local boolean `exportImmediately` is set to true. If it is then it calls the pdf export function `HTMLComposer.exportHTMLContentToPDF(HTMLContent:)`. If `exportImmediately` is set to false then the PDF export call below will not run.
```swift
// PreviewViewController.swift
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
```

The navigation bar has a "PDF" button on the right. When pressed, the below function is called. If `exportImmediately` is set to false, then the PDF is exported at this time. The `showOptionsAlert()` function shows option to preview the PDF or email the PDF.
```swift
// PreviewViewController.swift
@objc func didPressPDFButton(_ sender: AnyObject) {
    if let export = exportImmediately, !export {
        print("PDF EXPORTED (DELAYED)")
        data = HTMLComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        print(HTMLContent)
    }
    showOptionsAlert()
}
```
