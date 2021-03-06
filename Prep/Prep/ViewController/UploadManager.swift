//
//  UploadManager.swift
//  Prep
//
//  Created by sychung on 11/13/17.
//  Copyright © 2017 Zavier Patrick David Aguila. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import MobileCoreServices
import AssetsLibrary
struct Constants {
    struct Exp {
        // Set folder path in the Firebase storage
        static let userPath = "user/\(Auth.auth().currentUser!.uid)"
    }
}

class UploadManager: NSObject {
    
    // MARK: Helper function
    func uploadImage(_ image: UIImage, path: String, progressBlock: @escaping (_ percentage: Double)-> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        // ReferenceSetup
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        // Path: storage/user/{user id}/{experience id}/image.jpeg
        let imagesReference = storageReference.child(path)
        // Convert to JPG
        if let imageData = UIImageJPEGRepresentation(image, 0.0) {
            let metaData = StorageMetadata()
            metaData.contentType = "images/jpeg"
            
            // Upload to firebase storage
            let uploadTask = imagesReference.putData(imageData, metadata: metaData, completion: { (metaData, error) in
                
                    if let metaData = metaData {
                        completionBlock(metaData.downloadURL(), nil) // Has meta, Return URL
                    } else {
                        completionBlock(nil, error?.localizedDescription)
                    }
                })
            // Observe progress
            uploadTask.observe(.progress, handler: { (snapshot) in
                guard let progress = snapshot.progress else {
                    return
                }
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            })
        }else {
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
    }
    
    func uploadVideo(_ video: NSURL, path: String, progressBlock: @escaping (_ percentage: Double)-> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        
        // storage/user/{user id}/{experience id}/image.jpeg
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let videoReference = storageReference.child(path)
            
        // Start the video storage process
        videoReference.putFile(from: video as URL, metadata: nil, completion: { (metadata, error) in
            if let metaData = metadata {
                completionBlock(metaData.downloadURL(), nil) // Has meta, Return URL
            } else {
                completionBlock(nil, error?.localizedDescription)
            }
            })
        }
    func uploadAudio(_ audio: NSURL, path: String, progressBlock: @escaping (_ percentage: Double)-> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        
        // storage/user/{user id}/{experience id}/image.jpeg
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let videoReference = storageReference.child(path)
        
        // Start the video storage process
        videoReference.putFile(from: audio as URL, metadata: nil, completion: { (metadata, error) in
            if let metaData = metadata {
                completionBlock(metaData.downloadURL(), nil) // Has meta, Return URL
            } else {
                completionBlock(nil, error?.localizedDescription)
            }
        })
    }

    
}
