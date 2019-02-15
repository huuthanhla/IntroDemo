//
//  ViewController.swift
//  IntroDemo
//
//  Created by Thành Lã on 2/15/19.
//  Copyright © 2019 MonstarLab. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    
    var timer: Timer?
    var currentIndex: Int = 0
    var images = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        images = (1...10).map { _ -> UIImageView in
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.randomDark
            return imageView
        }
        
        pageControl.numberOfPages = images.count
        setupSlideScrollView(slides: images)
    }

    fileprivate func setupViews() {
        scrollView = setupScrollView()
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        pageControl = setupPageControl()
        view.addSubview(pageControl)
        
        setupConstrants()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    fileprivate func setupSlideScrollView(slides : [UIImageView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    fileprivate func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }
    
    fileprivate func setupPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        return pageControl
    }

    fileprivate func setupConstrants() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).inset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}

extension ViewController {
    fileprivate func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in self.nextIntro() })
    }
    
    fileprivate func nextIntro() {
        currentIndex += 1
        let animated = currentIndex != images.count
        
        if currentIndex > images.count - 1 {
            currentIndex = 0
        }
        
        showIntro(atIndex: currentIndex, animated: animated)
    }
    
    fileprivate func showIntro(atIndex index: Int, animated: Bool = true) {
        guard index < images.count else { return }
        scrollView.scrollRectToVisible(CGRect(x: CGFloat(index) * view.frame.width, y: 0, width: view.frame.width, height: view.frame.height),
                                       animated: animated)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        currentIndex = Int(pageIndex)
        pageControl.currentPage = Int(pageIndex)
    }
}

extension UIColor {
    static var randomDark: UIColor {
        let hue = CGFloat.random(in: 0...1)
        let saturation = CGFloat.random(in: 0...1)
        let brightness = CGFloat.random(in: 0.4...0.8)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
