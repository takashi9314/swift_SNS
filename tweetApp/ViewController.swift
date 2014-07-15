//
//  ViewController.swift
//  tweetApp
//
//  Created by 松本隆 on 2014/07/09.
//  Copyright (c) 2014年 松本隆. All rights reserved.
//

import UIKit
import Social

let successTitle = "投稿成功"
let failedTitle = "投稿失敗"
let successText = "メッセージの投稿に成功しました。"
let failedText = "メッセージの投稿に失敗しました。"
let closeBtnTitle = "閉じる"

var imagePicker:UIImagePickerController?
var savedImage:UIImage?

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //////////////////////////////////////////
    //BUTTON ACTIONS//
    //////////////////////////////////////////
    
    //写真を選択する
    @IBAction func choosePicture(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker = UIImagePickerController()
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker!.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            imagePicker = UIImagePickerController()
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker!.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Facebookに投稿
    @IBAction func postToFacebook(sender: AnyObject) {
        createPostView(SLServiceTypeFacebook)
    }
    
    //Twitterに投稿
    @IBAction func postToTwitter(sender: AnyObject) {
        createPostView(SLServiceTypeTwitter)
    }
    
    //////////////////////////////////////////
    //CREATE POST VIEW//
    //////////////////////////////////////////
    
    //SNS投稿画面の表示
    func createPostView(serviceType:NSString) {
        if SLComposeViewController.isAvailableForServiceType(serviceType){
            
            let postViewController:SLComposeViewController = SLComposeViewController(forServiceType: serviceType)
            
            //完了処理
            let handler : SLComposeViewControllerCompletionHandler =
            {result in
                if result == SLComposeViewControllerResult.Done{
                    self.showAlertView(true)
                    savedImage = nil
                }else if result == SLComposeViewControllerResult.Cancelled{
                    self.showAlertView(false)
                }
            }
            
            postViewController.completionHandler = handler
            if savedImage != nil {
                postViewController.addImage(savedImage)
            }
            
            self.presentViewController(postViewController, animated: true, completion: nil)
            
        }
    }
    
    //////////////////////////////////////////
    //ALERT VIEW//
    //////////////////////////////////////////
    
    //アラートビューの表示
    func showAlertView(success:Bool) {
        
        let alertView = UIAlertView()
        alertView.delegate = self
        alertView.addButtonWithTitle(closeBtnTitle)
        
        if success {
            alertView.title = successTitle
            alertView.message = successText
        }else{
            alertView.title = failedTitle
            alertView.message = failedText
        }
        
        alertView.show()
    }
    
    
    //////////////////////////////////////////
    //IMAGE PICKER//
    //////////////////////////////////////////
    
    //イメージピッカーの画像取得完了
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        savedImage = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //イメージピッカーがキャンセルされた
    func imagePickerControllerDidCancel(picker: UIImagePickerController!){
        savedImage = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}