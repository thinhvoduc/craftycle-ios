# Craftycle  
----  
Table of contents  
[1. Introduction](#introduction)  
[2. Requirements](#requirements)  
[3. Architecture](#architecture)  
[4. Dependencies](#dependencies)  
[5. Appendix](#appendix)  

----
## <a name="introduction"></a>Introduction  
Craftycle is a mobile app which motivates user to do the recycling in unconventional ways. It also allows to share tips to recycle, sell or give away their redundant/extra items.  
----
## <a name="requirements"></a>Requirements  
  * Xcode 8.0+  
  * [Backend](https://github.com/thinhvoduc/craftycle-backend).  
    NOTE: You need setup your own server before running the iOS app.  
  * Edit `$BASE_URL` in App's Build Settings, under User-Defined section, in both Debug and Release.  
    NOTE: Hit `Command + Option + Shift + K` to clean the build folder, otherwise it won't make any changes.  
  * [CocoaPods](https://cocoapods.org/).  
    Open Terminal from and type `sudo gem install cocoapods` to install [CocoaPods](https://cocoapods.org/).  
    Note: In this project we are not going to heavily rely on open source libraries, the purpose is to get familar with CocoaPods(Dependency manager) and how to integrate Objective-C code in Swift project.  
    To see how to initialize a CocoaPod project and how to integrate Objective-C code in Swift project, please check out this [appendix](#appendix).  
  * To run the project, open `Craftycle.xcworkspace` instead of `Craftycle.xcodeproj`. This git project does not ignore the Pod files so simply open `Craftycle.xcworkspace` and hit run.  
    Note: In case you do not see `Craftycle.xcworkspace`, open Terminal on this project's directory, run `pod install`, then you should see `Craftycle.xcworkspace`.  
      
## <a name="architecture">Architecture  
  [1. General](#achitecture-general)  
  [2. Networking Layer](#architecture-networking-layer)  
        
### <a name="achitecture-general"></a>General  
   >Will be updated later  
### <a name="architecture-networking-layer"></a>Networking Layer  
Why Networking Layer?  
  * Move all of your networking code off the controllers or avoid single fat network manager.  
  * Adopt SOLID princicles.  
  * Increase testability.  
  * Increase mockability.  
  * Easy to integrate with either URLSession or [Alamofire](https://github.com/Alamofire/Alamofire).  
   
What does the Networking Layer have?  
  * `ServiceConfiguration` class which contains the configurations for the `Service` object such as base url, cache policy, etc.  
  * `Serive` protocol defines the properties the Service is going to have and one required method which handle the execution of the requet to the server.  
     `func execute(_ request: Request, completionHandler: @escaping ((Response) -> Void))`.  
  * `Request` protocol describes how the request looks like. Such as: httpMethod, endpoint, etc.  
  * `RequestBody` struct contains the data which is passed to the request's body and encoding type.  
  * `Response` protocol contains an enum called `Result` which indicate the response type, whether a successful or a failure response.  
  * `AuthenticatedService` protocol indicates that the service which conforms to must define a `Authorization` header.
   You can ignore the AuthenticatedService protocol in this project since we are not going to have any authenticated service. However, a complete networking layer must have a way to define the authorization header.  
   
How does it work?  
  1. Create `BaseWebService`, `BaseRequest`, `BaseResponse`.  
  2. We need a configuration in order to initialize the the service.  
   The convenience initialization of ServiceConfiguration is loaded from `Info.plist` file.  
   In the `Info.plist` file, there is a dictionary under the name `Endpoint`. Inside the dictionary:  
    `Base`: `$BASE_URL`. `$BASE_URL` is taken from Use-Defined section you defined previously in project's Build Settings and `$BASE_URL` is determinded by the build you chose, Release or Debug(in this case, it is debug).  
  3. Example:  
   * Create a `CategoryService` subclass from the `BaseWebService`
   * We need a function to load all categories from the server, for example:
    `getAllCategories(successBlock:(([Category]) -> Void)?, failureBlock:WebSerivceErrorBlock?)` which takes two closures.  
    Inside this method we can call the superclass's `execute(_)` method to dispatch the request. In the completion handler we can parse the response to the desired model and call the successBlock with that parsed data, or if there is an error occured we can trigger the failure closure.  
   * We want to use fetch the categories inside the View Controller or the Data Source object, for example, do the following:  
    
```swift
let categoryService = CategoryService(ServiceConfiguration.defaultAppConfiguration()!) // Fail on purpose if there is no default configuration.
categoryService.getAllCategories(successBlock: {[weak self] allCategories in
    guard let strongSelf = self else {
        return
    }
    strongSelf.categories = allCategories
    strongSelf.pickerView.reloadAllComponents()
}, failureBlock: nil)
```
  
## <a name="dependencies"></a>Dependencies  
  In this project, the following dependecies are used:  
  [DTCircularActivityIndicator](https://github.com/ducthinh2410/DTCircularActivityIndicator): Simple library to demonstrate the Objective-C integration into Swift project.  
  
## <a name="appendix"></a>Appendix  
  [1. How to instantiate CocoaPods project?](#initialize-cocoapods)  
  [2. How to integate Objective-C code?](#integrate-objective-c)  
  
  ### <a name="initialize-cocoapods"></a>How to instantiate CocoaPods project?  
   * Open terminal, change to project's root directory where `ProjectName.xcodeproj` resides.  
   * Type `pod init` and return.  
   * `Podfile` is created. Open `Podfile` and add dependencies to the `Podfile` under `# Pods for ProjectName`. Hit Save and return to terminal.  
   * Type `pod install` and return.  
   * `ProjectName.xcworkspace` will be created for you.  
   
  ### <a name="integrate-objective-c"></a>How to integate Objective-C code in Swift project?  
    We add a file called bridging header to link Objective-C code into Swift code.  
   * Under ProjectName folder, create a Header file.  
   * Open `Build Settings` of the desired target.  
   * In `Swift Compiler - General` section. Navigate to `Objective-C Bridging Header` and set the value to `ProjectName/Bridging-Header-Filename.h`.  
   * Search for `User Header Search Paths` and set its value to `Pods/**`.  
   * Open the newly created header file and import the desired Objective-C libraries/frameworks.  
    
