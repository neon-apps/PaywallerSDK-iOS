//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 12.05.2024.
//

import Foundation
import UIKit
import NeonSDK
import SDWebImage
import AVFoundation
@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createVideoPlayerSection(fromDict dict: [String: Any]) -> PaywallerPaywallSectionType? {
        if let height = dict["height"] as? CGFloat,
           let videoFileName = dict["videoFileName"] as? String,
           let videoFileExtension = dict["videoFileExtension"] as? String,
           let cornerRadius = dict["cornerRadious"] as? CGFloat,
           let horizontalPadding = dict["horizontalPadding"] as? CGFloat,
           let contentModeRaw = dict["contentMode"] as? String,
           let contentMode = videoGravityFromString(contentModeRaw) {

            return .video(height: height, videoFileName: videoFileName, videoFileExtension: videoFileExtension, cornerRadious: cornerRadius, horizontalPadding: horizontalPadding, contentMode: contentMode)
        }
        return nil
    }

    public static func videoGravityFromString(_ contentModeString: String) -> AVLayerVideoGravity? {
        switch contentModeString {
        case "scaleAspectFit":
            return .resizeAspect
        case "scaleAspectFill":
            return .resizeAspectFill
        default:
            return nil
        }
    }
}
@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createVideoPlayerJSON(from section: PaywallerPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .video(height, videoFileName, videoFileExtension, cornerRadius, horizontalPadding, contentMode) = section else {
            return nil
        }
        
        let contentModeString = videoGravityStringFromEnum(contentMode)
        
        let imageDict: [String: Any] = [
            "index": index,
            "type": "video",
            "data": [
                "height": height,
                "videoFileName": videoFileName,
                "videoFileExtension": videoFileExtension,
                "cornerRadious": cornerRadius,
                "horizontalPadding": horizontalPadding,
                "contentMode": contentModeString
            ]
        ]
        
        return imageDict
    }

    public static func videoGravityStringFromEnum(_ contentMode: AVLayerVideoGravity) -> String {
        switch contentMode {
        case .resizeAspect:
            return "scaleAspectFit"
        case .resizeAspectFill:
            return "scaleAspectFill"
        default:
            return ""
        }
    }
}


/*
 
 
 Example JSON
 
 {
     "data": {
         "height": 200,
         "videoFileName": "video_file_name_here",
         "videoFileExtension": "mp4",
         "cornerRadius": 20,
         "horizontalPadding": 0,
         "contentMode": "scaleAspectFill"
     },
     "index": 3,
     "type": "video"
 }
 
 Options
 
 "contentMode" - "scaleAspectFill", "scaleAspectFit"
 
 */



