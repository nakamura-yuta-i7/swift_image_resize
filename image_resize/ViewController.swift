//
//  ViewController.swift
//  image_resize
//
//  Created by 中村祐太 on 2016/10/10.
//  Copyright © 2016年 中村祐太. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func tapSelectImageBtn(_ sender: AnyObject) {
        let ipc:UIImagePickerController = UIImagePickerController()
        ipc.delegate = self
        #if TARGET_IPHONE_SIMULATOR
            ipc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        #else
            // ipc.sourceType = UIImagePickerControllerSourceType.Camera
        #endif
        
        present(ipc, animated:true, completion:nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBAction func tapResizeImageBtn(_ sender: AnyObject) {
        print("imageView.image", imageView.image)
        
        imageView.image = imageView.image?.resize(size: CGSize(width: 200, height: 50))
        showImageSize()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func showImageSize() {
        let imageData = UIImagePNGRepresentation(imageView.image!)! as NSData
        sizeLabel.text = String(ByteCountFormatter.string(
            fromByteCount: Int64(imageData.length),
            countStyle: ByteCountFormatter.CountStyle.file)
        )
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imageView.image = image
            debugPrint(image)
            showImageSize()
        }
        //allowsEditingがtrueの場合 UIImagePickerControllerEditedImage
        //閉じる処理
        dismiss(animated: true, completion: nil);
    }
}

extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    //    // 比率だけ指定する場合
    //    func resize(#ratio: CGFloat) -> UIImage {
    //        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
    //        UIGraphicsBeginImageContext(resizedSize)
    //        drawInRect(CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
    //        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //        return resizedImage
    //    }
}
