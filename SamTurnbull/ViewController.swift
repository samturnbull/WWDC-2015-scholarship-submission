//
//  ViewController.swift
//  SamTurnbull
//
//  Created by Sam Turnbull on 15/04/2015.
//  Copyright (c) 2015 Sam's Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {


    @IBOutlet weak var scrollArrowXConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayNameYConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayNameXConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayImageYConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayImageXConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var experienceYConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutMeYConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundOverlayImageView: UIImageView!
    @IBOutlet weak var scrollArrow: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aboutMeButton: UIButton!
    @IBOutlet weak var experienceButton: UIButton!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    var displayImageYConstraintInitialValue: CGFloat!
    var displayNameYConstraintInitialValue: CGFloat!
    var displayImageXConstraintInitialValue: CGFloat!
    var displayNameXConstraintInitialValue: CGFloat!
    var visualEffectView: UIVisualEffectView!
    var lastPageBeforeRotate: CGFloat!
    var currentlyRotating: Bool!
    var viewFirstAppearance: Bool!
    var animator: Animator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = Animator()
        
        viewFirstAppearance = true
        
        lastPageBeforeRotate = -1
        currentlyRotating = false

        backgroundImageView.image = UIImage(named: "austria.jpg")
        backgroundImageView.contentMode = .ScaleAspectFill
        
        displayImage.image = UIImage(named: "sam.jpg")
        displayImage.clipsToBounds = true
        displayImage.layer.cornerRadius = 65
        displayImage.layer.borderColor = UIColor.darkGrayColor().CGColor
        displayImage.layer.borderWidth = 1
        
        aboutMeButton.layer.cornerRadius = 9
        experienceButton.layer.cornerRadius = 9
        
        // visualEffectView UIBlurEffect had performance issues on retina iPad
        backgroundOverlayImageView.image = UIImage(named: "austria_blurred.png")
        backgroundOverlayImageView.contentMode = .ScaleAspectFill
        backgroundOverlayImageView.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if (scrollView.contentOffset.x > 0) {
            scrollView.contentOffset.x = view.frame.width
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (viewFirstAppearance == true) {
            animateDisplayImage()
        }
        viewFirstAppearance = false
    }

    override func viewDidLayoutSubviews() {
        if (displayImageYConstraintInitialValue == nil) {
            displayImageYConstraintInitialValue = displayImageYConstraint.constant
            displayImageXConstraintInitialValue = displayImageXConstraint.constant
            displayNameYConstraintInitialValue = displayNameYConstraint.constant
            displayNameXConstraintInitialValue = displayNameXConstraint.constant
            
            displayNameYConstraint.constant = 1000
            displayImageHeightConstraint.constant = 1000
            displayImageWidthConstraint.constant = 1000
            displayImage.alpha = 0
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        currentlyRotating = true
        var pageWidth = view.frame.width
        var scrolledX = scrollView.contentOffset.x
        lastPageBeforeRotate = 0
        
        if (pageWidth > 0) {
            lastPageBeforeRotate = scrolledX / pageWidth
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        currentlyRotating = false
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (lastPageBeforeRotate != -1) {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width * lastPageBeforeRotate, 0);
            lastPageBeforeRotate = -1;
        }
    }
    
    func animateDisplayImage() {
        UIView.animateWithDuration(0.7, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.displayImage.alpha = 1.0
            self.displayImageHeightConstraint.constant = 130
            self.displayImageWidthConstraint.constant = 130
            self.view.layoutIfNeeded()
        }) { (finished: Bool) -> Void in
            self.animateDisplayName()
        }
    }
    
    func animateDisplayName() {
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.displayNameYConstraint.constant = self.displayNameYConstraintInitialValue
            self.displayNameXConstraint.constant = self.displayNameXConstraintInitialValue
            self.view.layoutIfNeeded()
        }) { (finished: Bool) -> Void in
            self.animateScrollArrow()
        }
    }
    
    func animateScrollArrow() {
        UIView.animateWithDuration(0.8, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.scrollArrowXConstraint.constant = -40
            self.view.layoutIfNeeded()
        }) { (finished: Bool) -> Void in
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.scrollArrowXConstraint.constant = 0
                self.view.layoutIfNeeded()
                }) { (finished: Bool) -> Void in
                    self.animateScrollArrow()
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!currentlyRotating) {
            var offset = scrollView.contentOffset.x
            
            displayImageYConstraint.constant = displayImageYConstraintInitialValue - offset
            displayImageXConstraint.constant = displayImageXConstraintInitialValue + offset
            displayNameYConstraint.constant = displayNameYConstraintInitialValue + offset
            displayNameXConstraint.constant = displayNameXConstraintInitialValue + offset
            
            if (offset > 0) {
                var scale = (view.frame.width - offset) / view.frame.width
                scrollArrow.alpha = scale
                backgroundOverlayImageView.alpha = 1 - scale
            }
            
            aboutMeYConstraint.constant = ((offset - view.frame.width) * (offset - view.frame.width)) / (view.frame.width) + 35
            experienceYConstraint.constant = 0 - ((offset - view.frame.width) * (offset - view.frame.width)) / (view.frame.width) - 35
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as! UIViewController
        toViewController.transitioningDelegate = self
    }
}

