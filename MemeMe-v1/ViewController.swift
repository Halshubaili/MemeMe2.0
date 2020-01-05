//
//  ViewController.swift
//  MemeMe-v1
//
//  Created by Work  on 9/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.0,
        
    ]
    

    //IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(tf: topTextField, text: "TOP")
        setupTextField(tf: bottomTextField, text: "BOTTOM")
        
        
    }//End viewDidLoad()
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = memeTextAttributes
        
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
         subscribeToKeyboardNotifications()
        
    }//End viewWillAppear()
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
        
    }//End viewWillDisappear()
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }//End subscribeToKeyboardNotifications()
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }//End unsubscribeFromKeyboardNotifications()
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }//End textFieldShouldReturn()
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }//End keyboardWillShow()
    
    @objc func keyboardWillHide (_ notification:Notification){
        view.frame.origin.y = 0
    }//End keyboardWillHide()
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }//End getKeyboardHeight()
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
    chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }//End pickImageFromAlbum()
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    //Ref: stckoverflow
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }

        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }//End imagePickerController()
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        present(imagePicker, animated: true, completion: nil)
       chooseImageFromCameraOrPhoto(source: .camera)
    }//End pickImageFromCamera()
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }//End save()
    
    @IBAction func canel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }//End cancel()
    
//    struct Meme {
//        let topText: String
//        let bottomText: String
//        let originalImage: UIImage
//        let memedImage: UIImage
//    }//End Meme struct
    
    
    func generateMemedImage() -> UIImage {
        
        //Hiding toolbar
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Showing toolbar
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
        
        
        return memedImage
    }//End generateMemedImage()
    
    @IBAction func share(_ sender: Any) {
        
        if(shareButton.isEnabled){
            let memedImage = generateMemedImage()
            let avc =  UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)
            
            avc.completionWithItemsHandler = {
                (activity, success, items, error) in
                if(success) {
                    self.save()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }//End if block
        
    }//End share()
    
}//End class

