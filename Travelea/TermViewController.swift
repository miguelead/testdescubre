//
//  HelpViewController.swift
//  ElCampitoApp
//
//  Created by Momentum Lab 1 on 8/7/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import UIKit
import Kingfisher


class TermViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyLocalization()
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        guard let url = URL(string: kTermWebURL) else {
            self.indicator.stopAnimating()
            return
        }
        let requestObj = URLRequest(url: url)
        webView.loadRequest(requestObj)
    }
    
    /**
     Update the title of the navigation bar
     - returns: void
     */
    func applyLocalization(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "Terminos de condiciones"
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
}

extension TermViewController: UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.indicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.indicator.stopAnimating()
    }
}

extension TermViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0){
            scrollView.contentOffset = CGPoint(x:0,y: scrollView.contentOffset.y)
        }
    }
}
