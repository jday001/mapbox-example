This is an example project to demonstrate a basic implementation of the MapBox SDK for iOS. The app uses a long press gesture to place pins on a map, which can also be deleted. The callout view for the pin displays an altitude for that location, looked up on Google's Elevation API.

Alamofire and MapBox were specifically requested for this project, so they are included via Cocoapods.

Pins are saved between sessions using CoreData, and MapBox's offline mode is also supported.