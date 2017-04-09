//
//  PicPop.swift
//  PicPop
//
//  Created by Vingle on 2017. 4. 8..
//  Copyright © 2017년 GeekTree. All rights reserved.
//

import UIKit
import SnapKit

class PicPop: UIView, UIGestureRecognizerDelegate{
    
    let dismissTap = UITapGestureRecognizer()
    var imageView: UIImageView? = nil
    var targetImage: UIImage? = nil
    var targetPosition: CGPoint? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.alpha = 0
        self.backgroundColor = .black
        self.frame.offsetBy(dx: 0, dy: 0)
    }
    
    func present() {
        self.snp.remakeConstraints({ make in
            make.height.equalTo(UIScreen.main.bounds.height)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.leading.top.equalToSuperview()
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            self.alpha = 1
        }, completion: { isFinished in
            if isFinished {
                self.dismissTap.addTarget(self, action: #selector(self.dismiss))
                self.addGestureRecognizer(self.dismissTap)
                
                guard let image = self.targetImage else { return }
                guard let pos = self.targetPosition else { return }
                
                self.imageView = UIImageView()
                guard let imageView = self.imageView else { return }
                imageView.image = image
                imageView.alpha = 0
                imageView.frame = CGRect(x: 0, y: 0, width : 200, height: 200)
                imageView.center = pos
                imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                imageView.layer.cornerRadius = imageView.frame.width
                self.addSubview(imageView)
                
                UIView.animate(withDuration: 0.3, animations: {
                    guard let imageView = self.imageView else { return }
                    imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                    imageView.center = CGPoint.Center
                    imageView.layer.cornerRadius = imageView.frame.width
                    imageView.alpha = 1
                }, completion: nil)
            }
        })
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            guard let pos = self.targetPosition else { return }
            guard let imageView = self.imageView else { return }
            
            self.alpha = 0
            imageView.center = pos
            imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: { isFinished in
            if isFinished {
                self.removeFromSuperview()
            }
        })
    }
}

extension PicPop {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let imageView = self.imageView else { return }
        guard let firstTouchObject = touches.first else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            imageView.center = firstTouchObject.location(in: self)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let imageView = self.imageView else { return }
        guard let pos = touches.first?.location(in: self) else { return }
        
        let imageViewWidth = imageView.frame.width
        
        if Int(sqrt(pow(Double(pos.x - CGPoint.Center.x),2) + pow(Double(pos.y - CGPoint.Center.y),2))) > Int(imageViewWidth / 2) {
            self.dismiss()
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                imageView.center = CGPoint.Center
            }, completion: nil)
        }
    }
}

extension CGPoint {
    static var Center: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.maxX/2, y: UIScreen.main.bounds.maxY/2)
    }
}
