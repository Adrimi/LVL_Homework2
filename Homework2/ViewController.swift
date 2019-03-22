//
//  ViewController.swift
//  Homework2
//
//  Created by Adrimi on 20/03/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var moonPos: CGPoint = CGPoint(x: 0, y: 0)
    private var moonOffset: CGPoint = CGPoint(x: 80, y: 80)
    
    private final let moonSize: CGFloat = 100.0
    private final let moonParralaxStrength: CGFloat = 1.06
    
    var scrollView: CityScroller {
        return view as! CityScroller
    }
    var moonView: UIView!
    
    override func loadView() {
        view = CityScroller()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Necessary to make a moon hang in place
        scrollView.delegate = self
        
        moonView =
            UIView(frame:
                CGRect(origin: .zero, size:
                    CGSize(width: moonSize, height: moonSize)))
        moonView.center = CGPoint(x: moonSize / 1.5, y: moonSize / 1.5)
        moonView.backgroundColor = .white
        moonView.layer.cornerRadius = moonSize * 0.5
        
        scrollView.addSubview(moonView)
        scrollView.sendSubviewToBack(moonView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.delegate = self
        moonView.addGestureRecognizer(longPress)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentOffset.y = scrollView.contentSize.height - view.frame.maxY
    }

    @objc func handleLongPress(_ press: UILongPressGestureRecognizer) {
        switch press.state {

        case .began:
            scrollView.bringSubviewToFront(moonView)
            moonPos = CGPoint(
                x: press.location(in: view).x - moonView.center.x,
                y: press.location(in: view).y - moonView.center.y)
            UIView.animate(withDuration: 0.2, animations: {
                self.moonView.alpha = 0.7
                self.moonView.transform = .init(scaleX: 1.2, y: 1.2)
            })
            
        case .changed:
            moonView.center = CGPoint(
                x: press.location(in: view).x - moonPos.x,
                y: press.location(in: view).y - moonPos.y)
            
        case .ended:
            UIView.animate(withDuration: 0.2, animations: {
                self.moonView.alpha = 1
                self.moonView.transform = .identity
            })
            // data for parallax
            moonOffset = CGPoint(
                x: moonView.frame.origin.x - scrollView.contentOffset.x,
                y: moonView.frame.origin.y - scrollView.contentOffset.y)
            scrollView.sendSubviewToBack(moonView)
            
        default:
            print("Unknown state, where is the moon?!")
        }
    }
    
    private func moonPositionFix() {
        moonView.frame.origin.x = scrollView.contentOffset.x + moonOffset.x
        // paralax effect
        moonView.frame.origin.y = scrollView.contentOffset.y * moonParralaxStrength + moonOffset.y
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        moonPositionFix()
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer is UIPanGestureRecognizer
    }
}

