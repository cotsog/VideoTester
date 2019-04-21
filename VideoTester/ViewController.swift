//
//  ViewController.swift
//  VideoTester
//
//  Created by Mac on 4/7/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SwiftVideoGenerator
import AVFoundation
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let fileUrl = Bundle.main.url(forResource: "qqq", withExtension: "mp4")!
      
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
         let videoOutputURL = URL(fileURLWithPath: documentsPath).appendingPathComponent("fffffff.mp4")
        
        if FileManager.default.fileExists(atPath:videoOutputURL.path) {
            
            /// try to delete the old generated video
            
            try? FileManager.default.removeItem(at:videoOutputURL)
            
            print("removed")
        }
        
        
        let image = UIImage(named: "www.jpg")!
        
        PhotosVC.writeSingleImageToMovie1(images:[image], durations:[2], outputFileURL: videoOutputURL) { (ee) in
       
            let aw = AVAsset(url: fileUrl)
         
            let dur = Int(CMTimeGetSeconds(aw.duration))
            
            PhotosVC.trimVideoProgBadge(audioUrl: videoOutputURL, from: 0, to: 2, success: { (weweww1) in
                
                PhotosVC.trimVideoProgBadge(audioUrl: fileUrl, from: 0, to:dur, success: { (weweww2) in
                    
                    VideoGenerator.mergeMovies(videoURLs:[weweww2,weweww1], andFileName:"cccc", success: { (videoURL) in
                        
                        DispatchQueue.main.async {
                            
                 
                            print(videoURL)
                            
                            let activityVC = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
                            activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact]
                            self.present(activityVC, animated: true, completion: nil)
                            
                        }
                        
                        
                    }) { (error) in
                        
                      
                        
                    }
                    
                    
                }, progress: { oiopo in
                    
                }, failure: { (eee) in
                    
                 
                    
                })
                
            }, progress: { oiopo in
                
            }, failure: { (eee) in
                
              
                
            })
            
        }
        
    }


}

class PhotosVC {
    
    static func writeSingleImageToMovie1(images: [UIImage], durations: [Int], outputFileURL: URL, completion: @escaping (Error?) -> ()) {
        do {
            let videoWriter = try AVAssetWriter(outputURL: outputFileURL, fileType: AVFileType.mp4)
            
            //            let codecSettings: [String: Any] = [AVVideoAverageBitRateKey:NSNumber(value: 960000),
            //                                                AVVideoMaxKeyFrameIntervalKey: NSNumber(value: 1)
            //                                                ]
            
            
            
            
            let videoSettings: [String: Any] = [AVVideoCodecKey: AVVideoCodecType.h264,
                                                AVVideoWidthKey: 480,
                                                AVVideoHeightKey: 640
                //                                                AVVideoCompressionPropertiesKey : [
                //                      AVVideoAverageBitRateKey : NSInteger(1000000),
                //                      AVVideoMaxKeyFrameIntervalKey : NSInteger(16),
                //                      AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel
                //                ]
            ]
            //  AVVideoCompressionPropertiesKey:codecSettings]
            
            let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
            let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: nil)
            
            if videoWriter.canAdd(videoWriterInput) {
                videoWriterInput.expectsMediaDataInRealTime = true
                videoWriter.add(videoWriterInput)
                
            }
            
            videoWriter.startWriting()
            let timeScale: Int32 = 1    // recommended in CMTime for movies.
            var startFrameTime = CMTimeMake(value: 0, timescale: timeScale)
            //            var endFrameTime = CMTimeMakeWithSeconds(halfMovieLength, preferredTimescale: timeScale)
            //
            //
            //            var images = [#imageLiteral(resourceName: "image1"), #imageLiteral(resourceName: "image2"), #imageLiteral(resourceName: "image3"), #imageLiteral(resourceName: "image4")]
            //            var durations = [20,10,5,7]
            var counter = 0
            
            var buffer: CVPixelBuffer!
            
            var elabsed = 0
            
            
            //
            //  let images = images.map { $0.scaleImageToSize(newSize: CGSize(width: 800, height: 800)) }
            
            
            videoWriter.startSession(atSourceTime: startFrameTime)
            
            
            //            while (videoWriter.status.rawValue != 1) {
            //                videoWriter.overallDurationHint = CMTime(seconds: 33, preferredTimescale: 1)
            //
            //            }
            
            
            
            images.forEach {
                
                print("elelelelelleel  ",elabsed)
                
                let cgImage = $0.cgImage!
                
                let  buffer = try! self.pixelBuffer(fromImage: cgImage, size: $0.size)
                while !adaptor.assetWriterInput.isReadyForMoreMediaData { usleep(10) }
                let startFrameTime = CMTimeMake(value:Int64(elabsed), timescale: timeScale)
                adaptor.append(buffer, withPresentationTime: startFrameTime)
                
                
                let halfMovieLength1 = elabsed + durations[counter] - 1
                
                print("halfMovieLength1  ",halfMovieLength1)
                let endFrameTime = CMTimeMake(value:Int64(halfMovieLength1), timescale: timeScale) // CMTimeMakeWithSeconds(Float64(halfMovieLength1), preferredTimescale: 1)
                while !adaptor.assetWriterInput.isReadyForMoreMediaData { usleep(10) }
                
                adaptor.append(buffer, withPresentationTime: endFrameTime)
                
                elabsed += durations[counter]
                
                counter += 1
                
            }
            
            videoWriterInput.markAsFinished()
            videoWriter.finishWriting {
                print("hjsddhjsjdhfhjjhsdjhdjhdjhsdhjdshjshjdsjhds 1")
                completion(videoWriter.error)
            }
        } catch {
            
            print("hjsddhjsjdhfhjjhsdjhdjhdjhsdhjdshjshjdsjhds 2")
            completion(error)
        }
    }
    
    static func pixelBuffer(fromImage image: CGImage, size: CGSize) throws -> CVPixelBuffer {
        let options: CFDictionary = [kCVPixelBufferCGImageCompatibilityKey as String: true, kCVPixelBufferCGBitmapContextCompatibilityKey as String: true] as CFDictionary
        var pxbuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32ARGB, options, &pxbuffer)
        if let buffer = pxbuffer, status == kCVReturnSuccess {
            CVPixelBufferLockBaseAddress(buffer, [])
            if let pxdata = CVPixelBufferGetBaseAddress(buffer)  {
                let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
                print("bjhdhjdbbnnbdsnbdsnbdsnbds")
                let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
                if let context = CGContext(data: pxdata, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)  {
                    context.concatenate(CGAffineTransform(rotationAngle: 0))
                    context.draw(image, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    CVPixelBufferUnlockBaseAddress(buffer, [])
                    return buffer
                }
                
            }
            
        }
        
        return pxbuffer!
    }
    
    
    class func trimVideoProgBadge(audioUrl: URL,from:Int,to:Int, success: @escaping ((URL) -> Void),progress: @escaping ((Float?) -> Void), failure: @escaping ((Error?) -> Void)) {
        
        
        //   let currentTime = CFAbsoluteTimeGetCurrent()
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        //  compositionAudioTrack!.preferredVolume = 0.8
        let avAsset = AVURLAsset(url: audioUrl, options: nil)
        print("\(avAsset)")
        var tracks = avAsset.tracks(withMediaType: AVMediaType.video)
        let clipAudioTrack = tracks[0]
        
        ///////////////////////////////////////////////////////////////////////
        
        var tracksAud = avAsset.tracks(withMediaType: AVMediaType.audio)
        var clipAudioTrackAud = tracksAud.first
        
        print("clipAudioTrackAudclipAudioTrackAudclipAudioTrackAudclipAudioTrackAud ",clipAudioTrackAud)
        
        
        do {
            try compositionVideoTrack!.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: avAsset.duration), of: clipAudioTrack, at: CMTime.zero)
            compositionVideoTrack!.preferredTransform = clipAudioTrack.preferredTransform
            
            
            if let clipAudioTrackAud = clipAudioTrackAud {
                
                
                try compositionAudioTrack!.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: avAsset.duration), of: clipAudioTrackAud, at: CMTime.zero)
            }
            else {
                
               
                let inputVideoURL1: URL = Bundle.main.url(forResource: "muted", withExtension: "mp3")! // Gably El 3enab // muted
                let sourceAsset1 = AVURLAsset(url: inputVideoURL1)
                var sourceVideoTrack1: AVAssetTrack? = sourceAsset1.tracks(withMediaType: AVMediaType.audio)[0]
                try compositionAudioTrack!.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: avAsset.duration), of: sourceVideoTrack1!, at: CMTime.zero)
            }
        }
        catch {
            
            
        }
        
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let outputURL = URL(fileURLWithPath: documentsPath).appendingPathComponent("Upload\(NSDate().timeIntervalSince1970).mp4")
        
        do {
            if FileManager.default.fileExists(atPath: outputURL.path) {
                
                try FileManager.default.removeItem(at: outputURL)
            }
        } catch {
            
        }
        
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPreset640x480)
        // exporter!.outputURL = documentsURL
        exportSession!.outputFileType = AVFileType.mp4
        // let duration = CMTimeGetSeconds(avAsset.duration)
        //        print(duration)
        //        if (duration < 5.0) {
        //            print("sound is not long enough")
        //            return
        //        }
        //        // e.g. the first 30 seconds
        
        
        let progTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (t
            ) in
            
            progress(exportSession?.progress ?? 0 * 100)
            
            
        })
        
        
        
        
        let startTime = CMTimeMake(value:Int64(from), timescale: 1)
        let stopTime = CMTimeMake(value:Int64(to),timescale: 1)
        let exportTimeRange = CMTimeRangeFromTimeToTime(start: startTime, end: stopTime)
        print(exportTimeRange)
        exportSession!.timeRange = exportTimeRange
        exportSession?.outputURL = outputURL
        print(exportSession!.timeRange)
        
        exportSession!.exportAsynchronously
            {() -> Void in
                
                progTimer.invalidate()
                
                switch exportSession!.status {
                case .failed:
                    if let _error = exportSession!.error {
                        failure(_error)
                    }
                    
                case .cancelled:
                    if let _error = exportSession!.error {
                        failure(_error)
                    }
                    
                default:
                    print("finished")
                    success(outputURL)
                }
                
                
        }
    }
    
    
    
    
    
}



//  Car.swift
import Foundation
class Car {
    var miles = 0
    var type: CarType
    var transmissionMode: CarTransmissionMode
    init(type:CarType, transmissionMode:CarTransmissionMode){
        self.type = type
        self.transmissionMode = transmissionMode
    }
    func start(minutes: Int) {
        var speed = 0
        if self.type == .Economy && self.transmissionMode == .Drive {
            speed = 35
        }
        if self.type == .OffRoad && self.transmissionMode == .Drive {
            speed = 50
        }
        if self.type == .Sport && self.transmissionMode == .Drive {
            speed = 70
        }
        self.miles = speed * (minutes / 60)
    }
}

enum CarType {
    case Economy
    case OffRoad
    case Sport
}
enum CarTransmissionMode {
    case Park
    case Reverse
    case Neutral
    case Drive
}





//  ViewController.swift
import UIKit
class ViewControllerd: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let ferrari = Car(type: .Sport, transmissionMode: .Drive)
        ferrari.start(minutes: 120)
        print(ferrari.miles) // => 140
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
