//
//  ViewController.swift
//  PicPop
//
//  Created by Vingle on 2017. 4. 8
//  Copyright © 2017년 GeekTree. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet var profileImage: UIImageView!
    
    let tapPicture = UITapGestureRecognizer()
    var position: CGPoint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mark : image set
        let profilePicture: UIImage = #imageLiteral(resourceName: "geektree")
        guard let img = profilePicture.cgImage else { return }
        let cropOffsetY: CGFloat = CGFloat((img.height - img.width) / 2 )
        
        let clipPath: CGRect = CGRect(x: 0, y: cropOffsetY, width: CGFloat(img.width), height: CGFloat(img.width))
        let cropedImage: CGImage = profilePicture.cgImage!.cropping(to: clipPath)!
        
        self.profileImage.image = UIImage(cgImage: cropedImage)
        
        // Mark : add Gesture
        tapPicture.delegate = self
        tapPicture.addTarget(self, action: #selector(self.picPopAction(gestureRecognizer:)))
        profileImage.addGestureRecognizer(tapPicture)
        
    }
    
    func picPopAction(gestureRecognizer: UIGestureRecognizer) {
        guard let position = self.position else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.profileImage.alpha = 0.5
            self.profileImage.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.profileImage.alpha = 1
            self.profileImage.transform = .identity
        }, completion: { isFinished in
            if isFinished {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                let picPop = PicPop.loadViewFromNib() as! PicPop
                self.view.addSubview(picPop)
                picPop.targetPosition = position
                picPop.targetImage = self.profileImage.image
                picPop.present()
            }
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouchObject = touches.first else { return }
        self.position = firstTouchObject.location(in: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIView {
    class func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first
        
        return nibView as! UIView
    }
}
