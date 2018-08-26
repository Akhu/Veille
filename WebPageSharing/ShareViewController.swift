//
//  ShareViewController.swift
//  WebPageSharing
//
//  Created by Anthony Da Cruz on 10/05/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Firebase

class ShareViewController: SLComposeServiceViewController {
    
    private var gatheredDictionnary: NSDictionary?

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didLoad")
        
        //self.view.backgroundColor = UIColor(red: 61/255, green: 81/255, blue: 156/255, alpha: 0.7)
        
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else { return }
        
        for extensionItem in extensionItems {
            guard let itemProviders = extensionItem.attachments as? [NSItemProvider] else { return }
            for itemProvider in itemProviders {
                if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
                    itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil) { (propertyListCorrespondingToJavascriptResults, error) in
                        guard let jsDictionary = propertyListCorrespondingToJavascriptResults as? NSDictionary else { return }
                        if let valueContent = jsDictionary.value(forKey: NSExtensionJavaScriptPreprocessingResultsKey) as? NSDictionary {
                            self.gatheredDictionnary = valueContent
                            _ = self.isContentValid()
                        }
                    }
                }
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(self.view.subviews)
    }
    
    override func didSelectPost() {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-share", ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!) else { assert(false, "Coulnd't load config file") }
        FirebaseApp.configure(options: fileopts
        )
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        guard let gatheredData = self.gatheredDictionnary else { return }
        if gatheredData.count > 0 {
            print(gatheredData)
            if let url = gatheredData.value(forKey: "url") as? String, let title = gatheredData.value(forKey: "title") as? String {
                if let articleToSave = Article(url: url) {
                    articleToSave.title = title
                    do {
                        try articleToSave.save()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
