//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 12.05.2024.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class PaywallerPaywallVideoPlayerView : BasePaywallerPaywallSectionView{
    
    let videoPlayerView = NeonVideoPlayerView()
    
    override func configureSection(type: PaywallerPaywallSectionType) {
        
        configureView()
        setConstraint()
        
        switch type {
        case .video(let height, let videoFileName, let videoFileExtension, let cornerRadious, let horizontalPadding, let contentMode):
            
            videoPlayerView.configure(with: videoFileName, fileExtension: videoFileExtension)
            videoPlayerView.shouldPlayForever = true
            videoPlayerView.playerViewController.view.layer.cornerRadius = cornerRadious
            videoPlayerView.playerViewController.view.layer.masksToBounds = true
            videoPlayerView.playerViewController.videoGravity = contentMode
    
            videoPlayerView.snp.makeConstraints { make in
                make.height.equalTo(height)
                make.left.right.equalToSuperview().inset(horizontalPadding)
            }
            self.layer.cornerRadius = cornerRadious
            self.layer.masksToBounds = true


            

        default:
            fatalError("Something went wrong with PaywallerPaywall. Please consult to manager.")
        }
    }
    
    func configureView(){
    
        self.addSubview(videoPlayerView)
    }
    
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(videoPlayerView.snp.bottom)
        }
    }
    
}

