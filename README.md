
# PaywallerSDK-iOS

Design long paywalls remotely withot needing developers to make A/B tests faster and easier.

PaywallerSDK is a framework that makes building drag-and-drop paywalls for iOS fast and easy. It’s native, lightweight and works with all populer in app purchase handlers like Adapty, RevenueCat, AppHud, Purchasely and Qonversion.

## Configuration (Adapty Example)

To get started with PaywallerSDK, you'll need to configure it in your `AppDelegate.swift` file:

```swift
import UIKit
import Paywaller

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        Paywaller.configure(
            apiKey: "YOUR_PAYWALLER_API_KEY_HERE",
            provider: .adapty(
                apiKey: "YOUR_ADAPTY_API_KEY_HERE",
                placementIDs: ["PLACEMENT_1", "PLACEMENT_2"],
                accessLevel: "ACCESS_LEVEL"
            )
        )
        
        return true
    }
}

```

In this code block, you'll need to replace "YOUR_PAYWALLER_API_KEY_HERE" and "YOUR_ADAPTY_API_KEY_HERE" with your actual API keys. You can also customize the placementIDs and accessLevel according to your paywall requirements.

## Usage

Next, let's take a look at how you can use PaywallerSDK to display a paywall in your view controller:

```swift

import UIKit
import Paywaller

class ViewController: UIViewController, PaywallerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    @objc func showPaywall() {
        Paywaller.presentPaywall(with: .adapty(placementID: "paywall_1"), from: self)
    }
    
    func purchased(from controller: UIViewController, identifier: String) {
        // Handle the purchase event here
    }
    
    func restored(from controller: UIViewController) {
        // Handle the restoration event here
    }
    
    func dismissed(from controller: UIViewController) {
        // Handle the dismissal event here
    }
}

```

In this code block, we create a button that, when tapped, triggers the showPaywall() method. Inside the showPaywall() method, we use Paywaller.presentPaywall() to display the paywall with the specified Adapty placement ID. You can customize the UI and behavior as needed.

The PaywallerDelegate methods are implemented to handle purchase, restoration, and dismissal events related to the paywall.
