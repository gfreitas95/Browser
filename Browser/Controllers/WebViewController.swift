//
//  ViewController.swift
//  Browser
//
//  Created by Gustavo on 31/07/20.
//  Copyright © 2020 Gustavo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {
    
    var urlSaved: Array<Url> = []
    
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet var btnStar: UIButton?
    @IBOutlet var btnBack: UIButton?
    @IBOutlet var btnFoward: UIButton?
    @IBOutlet var btnShare: UIButton?
    @IBOutlet var webView: WKWebView?
    @IBOutlet var txtUrl: UITextField?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorite), name: NSNotification.Name("refreshState"), object: nil)
        
        txtUrl?.keyboardAppearance = .dark
        webView?.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let urlString: String = "https://www.apple.com"
        txtUrl?.text = urlString
        
        let url: URL = URL(string: urlString)!
        let urlRequest: URLRequest = URLRequest(url: url)
        webView?.load(urlRequest)
        
        refreshFavorite()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (txtUrl?.text?.contains("http://"))! || (txtUrl?.text?.contains("https://"))! {
            let urlString: String = txtUrl!.text!
            
            let url: URL = URL(string: urlString)!
            let urlRequest: URLRequest = URLRequest(url: url)
            webView?.load(urlRequest)
        } else {
            let urlString: String = "http://\(txtUrl?.text ?? "")"
            
            let url: URL = URL(string: urlString)!
            let urlRequest: URLRequest = URLRequest(url: url)
            webView?.load(urlRequest)
        }
        
        textField.resignFirstResponder()
        
        self.btnStar?.setImage( #imageLiteral(resourceName: "bookmark"), for: .normal)
        self.btnStar?.isEnabled = false
        
        return true
    }
    
    // MARK: - IBActions
    
    @objc func refreshFavorite() {
        
        if exists(url: txtUrl?.text ?? "") {
            self.btnStar?.setImage( #imageLiteral(resourceName: "bookmark"), for: .normal)
        } else {
            self.btnStar?.setImage( #imageLiteral(resourceName: "bookmark"), for: .normal)
        }
    }
    
    @IBAction func goToFavorites() {
        
        if #available(iOS 13.0, *) {
            let favoriteVC = storyboard?.instantiateViewController(identifier: "SavedUrlView") as! SavedUrlViewController
            self.present(favoriteVC, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "SavedUrlView", bundle: nil)
            let favoriteVC = storyboard.instantiateViewController(withIdentifier: "SavedUrlView")
            self.present(favoriteVC, animated: true)
        }
    }
    
    @IBAction func favorite() {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let dic = ["date": dateString, "url": txtUrl?.text ?? ""]
        
        if var urlDictionary = UserDefaults.standard.value(forKey: "urls") as? Array<Dictionary<String,String>> {
            
            if exists(url: txtUrl?.text ?? "") {
                
                print("removed from favorites")
                urlDictionary.remove(at: indexUrl(url: txtUrl?.text ?? ""))
                UserDefaults.standard.set(urlDictionary, forKey: "urls")
                UserDefaults.standard.synchronize()
                
                btnStar?.setImage( #imageLiteral(resourceName: "bookmark"), for: .normal)
                
            } else {
                urlDictionary.append(dic)
                UserDefaults.standard.set(urlDictionary, forKey: "urls")
                UserDefaults.standard.synchronize()
                btnStar?.setImage( #imageLiteral(resourceName: "bookmark"), for: .normal)
            }
        } else {
            UserDefaults.standard.set([dic], forKey: "urls")
            btnStar?.setImage( #imageLiteral(resourceName: "bookmark"), for: .normal)
        }
    }
    
    func exists(url: String) -> Bool {
        
        if let urlDictionary = UserDefaults.standard.value(forKey: "urls") as? Array<Dictionary<String,String>> {
            
            var counter = 0
            
            for item in urlDictionary {
                
                if item["url"] == url {
                    print("Found \(url) for index \(counter)")
                    return true
                }
                counter += 1
            }
        }
        return false
    }
    
    func indexUrl(url: String) -> Int {
        
            var counter = 0
        
        if let urlDictionary = UserDefaults.standard.value(forKey: "urls") as? Array<Dictionary<String,String>> {
            
            for item in urlDictionary {
                if item["url"] == url {
                    print("Found \(url) for index \(counter)")
                    return counter
                }
                counter += 1
            }
        }
        return counter
    }
    
    @IBAction func share() {
        let activityVC = UIActivityViewController(activityItems: [txtUrl!.text!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func backButton() {
        webView?.goBack()
    }
    
    @IBAction func fowardButton() {
        webView?.goForward()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        txtUrl?.text = webView.url?.absoluteString
        self.btnStar?.isEnabled = true
        refreshFavorite()
    }
}

