//
//  ViewController.swift
//  AppBrowser
//
//  Created by Fabio Lindemberg on 20/09/20.
//  Copyright © 2020 Fabio Lindemberg. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var btnFavorite: UIButton!
    
    var favoriteList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tfAddress.delegate = self
        self.webView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.loadFavorite()
        self.goTo(address: "https://github.com/fabiolindemberg")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tfAddress.text = webView.url!.absoluteString
    }
    
    // MARK: Custom Methods
    
    func goTo(address: String) {
        
        self.searchFavorite(stringUrl: address)
        
        let url = URL(string: address)!
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    @IBAction func forward(_ sender: Any) {
        self.webView.goForward()
    }
    
    @IBAction func back(_ sender: Any) {
        self.webView.goBack()
    }
    
    // MARK: Favorite methods
    
    @IBAction func saveFavorite(sender: UIButton) {
        favoriteList.append(self.tfAddress.text!)
        
        UserDefaults.standard.set(self.favoriteList, forKey: "favoriteList")
        UserDefaults.standard.synchronize()
    }
    
    func loadFavorite() {
        
        self.favoriteList = UserDefaults.standard.object(forKey: "favoriteList") as? [String] ?? []
    }
    
    func toogleFavorite(_ toogle: Bool) {
        
        let bookmarkFill = UIImage(named: "bookmark.fill")
        let bookmark = UIImage(named: "bookmark")
        
        self.btnFavorite.setImage(toogle ? bookmarkFill: bookmark, for: .normal)
    }
    
    func searchFavorite(stringUrl: String) {
        
        for favorite in self.favoriteList {
            if favorite.elementsEqual(stringUrl) {
                self.toogleFavorite(true)
                return
            }
        }
    }
    
    @IBAction func showFavoriteList(sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(identifier: "FavoriteListView") as! FavoriteListViewControllerTableViewController
        
        vc.favoriteList = self.favoriteList
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard textField.text != nil else { return false }
        
        if textField.text!.contains("https://") {
            self.goTo(address: textField.text!)
        } else {
            self.goTo(address: "https://" + textField.text!)
        }
        
        return true
    }
}

