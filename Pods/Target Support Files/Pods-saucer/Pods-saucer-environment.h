
// To check if a library is compiled with CocoaPods you
// can use the `COCOAPODS` macro definition which is
// defined in the xcconfigs so it is available in
// headers also when they are imported in the client
// project.


// Alamofire
#define COCOAPODS_POD_AVAILABLE_Alamofire
#define COCOAPODS_VERSION_MAJOR_Alamofire 3
#define COCOAPODS_VERSION_MINOR_Alamofire 0
#define COCOAPODS_VERSION_PATCH_Alamofire 0

// SwiftyJSON
#define COCOAPODS_POD_AVAILABLE_SwiftyJSON
#define COCOAPODS_VERSION_MAJOR_SwiftyJSON 2
#define COCOAPODS_VERSION_MINOR_SwiftyJSON 3
#define COCOAPODS_VERSION_PATCH_SwiftyJSON 0

// UIColor_Hex_Swift
#define COCOAPODS_POD_AVAILABLE_UIColor_Hex_Swift
#define COCOAPODS_VERSION_MAJOR_UIColor_Hex_Swift 1
#define COCOAPODS_VERSION_MINOR_UIColor_Hex_Swift 2
#define COCOAPODS_VERSION_PATCH_UIColor_Hex_Swift 0

// UIScrollView-InfiniteScroll
#define COCOAPODS_POD_AVAILABLE_UIScrollView_InfiniteScroll
#define COCOAPODS_VERSION_MAJOR_UIScrollView_InfiniteScroll 0
#define COCOAPODS_VERSION_MINOR_UIScrollView_InfiniteScroll 7
#define COCOAPODS_VERSION_PATCH_UIScrollView_InfiniteScroll 3

// Debug build configuration
#ifdef DEBUG

  // Reveal-iOS-SDK
  #define COCOAPODS_POD_AVAILABLE_Reveal_iOS_SDK
  #define COCOAPODS_VERSION_MAJOR_Reveal_iOS_SDK 1
  #define COCOAPODS_VERSION_MINOR_Reveal_iOS_SDK 5
  #define COCOAPODS_VERSION_PATCH_Reveal_iOS_SDK 1

#endif
