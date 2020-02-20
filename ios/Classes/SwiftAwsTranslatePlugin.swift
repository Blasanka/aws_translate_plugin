import Flutter
import UIKit
import AWSCognito
import AWSTranslate

public class SwiftAwsTranslatePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.blasanka.translateFlutter/aws_translate", binaryMessenger: registrar.messenger())
        let instance = SwiftAwsTranslatePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.translateText(result: result, args: call.arguments)
    }
    
    public func translateText(result: @escaping FlutterResult, args: Any?) {
        let argsMap = args as! NSDictionary
        
        if let poolId = argsMap["poolId"], let region = argsMap["region"], let text = argsMap["text"], let to = argsMap["to"], let from = argsMap["from"] {
            
//            let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "", secretKey: "")
            
            let convertedRegion = self.decideRegion(region as! String)

            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: convertedRegion, identityPoolId: poolId as! String);
            
            let configuration = AWSServiceConfiguration(region: convertedRegion, credentialsProvider: credentialsProvider)
            
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            
            let translateClient = AWSTranslate.default()
            let translateRequest = AWSTranslateTranslateTextRequest()
            translateRequest?.sourceLanguageCode = from as? String
            translateRequest?.targetLanguageCode = to as? String
            translateRequest?.text = text as? String
            
            let callback: (AWSTranslateTranslateTextResponse?, Error?) -> Void = { (response, error) in
                guard let response = response else {
                    print("Got error \(String(describing: error))")
                    return
                }
                
                if let translatedText = response.translatedText {
                    print(translatedText)
                    result(translatedText)
                }
            }
            
            translateClient.translateText(translateRequest!, completionHandler: callback)
        } else {
            print("Did not provided required args")
            result(nil)
        }
    }

    private func decideRegion(_ region: String) -> AWSRegionType {
        let reg: String = (region as AnyObject).replacingOccurrences(of: "Regions.", with: "")
        switch reg {
            case "Unknown":
                return AWSRegionType.Unknown
        case "US_EAST_1":
            return AWSRegionType.USEast1
        case "US_EAST_2":
            return AWSRegionType.USEast2
        case "US_WEST_1":
            return AWSRegionType.USWest1
        case "US_WEST_2":
            return AWSRegionType.USWest2
        case "EU_WEST_1":
            return AWSRegionType.EUWest1
        case "EU_WEST_2":
            return AWSRegionType.EUWest2
        case "EU_CENTRAL_1":
            return AWSRegionType.EUCentral1
        case "AP_SOUTHEAST_1":
            return AWSRegionType.APSoutheast1
        case "AP_NORTHEAST_1":
            return AWSRegionType.APNortheast1
        case "AP_NORTHEAST_2":
            return AWSRegionType.APNortheast2
        case "AP_SOUTHEAST_2":
            return AWSRegionType.APSoutheast2
        case "AP_SOUTH_1":
            return AWSRegionType.APSouth1
        case "CN_NORTH_1":
            return AWSRegionType.CNNorth1
        case "CA_CENTRAL_1":
            return AWSRegionType.CACentral1
        case "USGovWest1":
            return AWSRegionType.USGovWest1
        case "CN_NORTHWEST_1":
            return AWSRegionType.CNNorthWest1
        case "EU_WEST_3":
            return AWSRegionType.EUWest3
//        case "US_GOV_EAST_1":
//            return AWSRegionType.USGovEast1
//        case "EU_NORTH_1":
//            return AWSRegionType.EUNorth1
//        case "AP_EAST_1":
//            return AWSRegionType.APEast1
//        case "ME_SOUTH_1":
//            return AWSRegionType.MESouth1
        default:
            return AWSRegionType.Unknown
        }
    }
     

}
