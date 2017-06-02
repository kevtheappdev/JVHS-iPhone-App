//
//  JVLoadingView.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/9/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class JVLoadingView: UIView
{
    private let loadingView: UIActivityIndicatorView
    private let loadingLabel: UILabel
    private let containerView: UIView
    private let backGroundView: UIView
    
    init(frame: CGRect, loadingMessage: String)
    {
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        loadingLabel = UILabel()
        containerView = UIView()
        backGroundView = UIView(frame: frame)
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        backGroundView.backgroundColor = UIColor.black
        backGroundView.alpha = 0.5
        loadingLabel.textColor = UIColor.white
         containerView.addSubview(loadingLabel)
         containerView.addSubview(loadingView)
         backGroundView.addSubview(containerView)
       
         addSubview(backGroundView)
        loadingLabel.text = loadingMessage
        loadingView.startAnimating()
    
        self.backgroundColor = UIColor.clear
    }
    
    
    override func layoutSubviews()
    {
        containerView.translatesAutoresizingMaskIntoConstraints = false
         let views = ["loadingLabel": loadingLabel, "loadingView": loadingView, "containerView": containerView]
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[containerView]-|", options: [], metrics: nil, views: views)
        backGroundView.addConstraints(constraints)
        
       let centerY = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: backGroundView, attribute: .centerY, multiplier: 1, constant: 0)
        
        backGroundView.addConstraint(centerY)
      
        
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var centerX = NSLayoutConstraint(item: loadingLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        containerView.addConstraint(centerX)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        centerX = NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        containerView.addConstraint(centerX)
        
      
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[loadingLabel]-[loadingView]-|", options: [], metrics: nil, views: views)
        containerView.addConstraints(verticalConstraints)
        
        

     
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
