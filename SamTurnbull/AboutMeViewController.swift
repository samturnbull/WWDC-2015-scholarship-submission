//
//  AboutMeViewController.swift
//  SamTurnbull
//
//  Created by Sam Turnbull on 16/04/2015.
//  Copyright (c) 2015 Sam's Software. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var page1Header: UIImageView!
    @IBOutlet weak var page2Header: UIImageView!
    @IBOutlet weak var page3Header: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollArrow1YConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollArrow2YConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var lastPageBeforeRotate: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateScrollArrow()
        
        lastPageBeforeRotate = -1
        
        backgroundImageView.image = UIImage(named: "austria_blurred.png")
        backgroundImageView.contentMode = .ScaleAspectFill

        page1Header.image = UIImage(named: "leicester.jpg")
        page1Header.contentMode = .ScaleAspectFill
        page1Header.clipsToBounds = true
        textView1.backgroundColor = UIColor(white: 0.7, alpha: 0.6)
        textView1.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
        
        page2Header.image = UIImage(named: "desk.jpg")
        page2Header.contentMode = .ScaleAspectFill
        page2Header.clipsToBounds = true
        textView2.backgroundColor = UIColor(white: 0.7, alpha: 0.6)
        textView2.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
        
        page3Header.image = UIImage(named: "katie.jpg")
        page3Header.contentMode = .ScaleAspectFill
        page3Header.clipsToBounds = true
        textView3.backgroundColor = UIColor(white: 0.7, alpha: 0.6)
        textView3.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func animateScrollArrow() {
        UIView.animateWithDuration(0.8, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.scrollArrow1YConstraint.constant = 30
            self.scrollArrow2YConstraint.constant = 30
            self.view.layoutIfNeeded()
            }) { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.scrollArrow1YConstraint.constant = 8
                    self.scrollArrow2YConstraint.constant = 8
                    self.view.layoutIfNeeded()
                    }) { (finished: Bool) -> Void in
                        self.animateScrollArrow()
                }
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        var pageHeight = self.view.frame.height
        var scrolledY = scrollView.contentOffset.y
        lastPageBeforeRotate = 0
        
        if (pageHeight > 0) {
            lastPageBeforeRotate = scrolledY / pageHeight
        }
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (lastPageBeforeRotate != -1) {
            scrollView.contentOffset = CGPointMake(0, scrollView.bounds.size.height * lastPageBeforeRotate);
            lastPageBeforeRotate = -1;
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y <= -100) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
