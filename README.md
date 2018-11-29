# Print2PDF Test

This code tests the difference between choosing to render a PDF immediately versus delaying the action until later. When rendering a PDF immediately, the images are not displayed in the PDF. When delayed, the images properly rendered. On inspecting the html strings that are sent to render, one will notice that the HTML strings are exactly the same.

## Overview 
The MainTableViewController has three options (three cells): 
1) Delay PDF Export (UIWebView)
2) Export PDF Immediately (UIWebView)
3) Test Using WKWebView

When the user clicks either option 1 or 2, the PreviewViewController is pushed. On `viewWillAppear()`, the html template is loaded into a UIWebView.
```swift
// PreviewViewController.swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadHTMLTemplate()
}
```

The `loadHTMLTemplate()` checks if a local boolean `exportImmediately` is set to true. If it is then it calls the pdf export function `HTMLComposer.exportHTMLContentToPDF(HTMLContent:)`. If `exportImmediately` is set to false then the PDF export call below will not run.
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

The navigation bar has a "PDF" button on the right. When pressed, the below function is called. If `exportImmediately` is set to false, then the PDF is exported at this time. Then the PDF is displayed in the UIWebView. 
```swift
// PreviewViewController.swift
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
```

### Option 1: Delay Export, UIWebView Test
Note that the images are properly displayed when the export call is delayed after the webView loads.

### Option 2: Immediate Export, UIWebView Test
When the export function is called immediately, the images are not displayed at all.

### Option 3: WKWebView Test
Option 3 again displays the same HTML template as option 1 and 2. However, this time the template is loaded into a WKWebView. After loading the page, the html is saved to a local variable `HTMLContent` just like in option 1 (delayed export). When the PDF button is pressed, the PDF is exported and displayed. Note that the images are not rendered in the WKWebView.
