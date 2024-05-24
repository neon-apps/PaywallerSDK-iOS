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
public class PaywallerPaywallVideoPlayerView : BasePaywallerPaywallSectionView{
    
    let videoPlayerView = NeonVideoPlayerView()
    let gradientView = UIView()
    let gradientLayer = CAGradientLayer()
    
    
    public override func configureSection(type: PaywallerPaywallSectionType) {
        
        configureView()
        setConstraint()
        
        switch type {
        case .video(let height, let videoFileName, let videoFileExtension, let cornerRadious, let horizontalPadding, let contentMode, let shouldBlendWithBackground):
            
            
            if Bundle.main.bundleIdentifier == "com.neonapps.paywaller" {
              //  videoPlayerView.configure(with: "placeholder_video", fileExtension: "mov")
            } else {
                videoPlayerView.configure(with: videoFileName, fileExtension: videoFileExtension)
            }
            
            
            videoPlayerView.shouldPlayForever = true
            videoPlayerView.playerViewController.view.layer.cornerRadius = cornerRadious
            videoPlayerView.playerViewController.view.layer.masksToBounds = true
            videoPlayerView.playerViewController.videoGravity = contentMode
    
            videoPlayerView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(height)
                make.left.right.equalToSuperview().inset(horizontalPadding)
            }
            self.layer.cornerRadius = cornerRadious
            self.layer.masksToBounds = true


            if shouldBlendWithBackground{
                
                addSubview(gradientView)
                gradientView.frame = CGRect(x: 0, y: height - 100, width: UIScreen.main.bounds.width, height: 200)
                gradientLayer.frame = gradientView.bounds
                gradientLayer.colors = [manager.constants.backgroundColor.withAlphaComponent(0).cgColor, manager.constants.backgroundColor.cgColor]
                gradientLayer.locations = [0, 0.5]
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
                gradientView.layer.insertSublayer(gradientLayer, at: 0)
            }

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
    
    

    func deinitPlayer(){
        videoPlayerView.deinitPlayer()
    }
    
}

