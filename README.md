# final-project-final-opal

Cabell Glancy (bcg7mf) <br>
Matias Rietig (mjr9r)

---
## Radar
Our app, Radar, will function as an all-purpose geospatial message board. It allows users to post messages anonymously to a shared map for other users to discover them. There is a real lack in the market for a strong spatially based messaging app. While Snapchat currently includes features to display user’s locations, no current messaging app allows for anonymous public location based messaging. Allowing users to anonymously post messages to real world features and landmarks opens up a whole new method for communication. 

### Platform Justification
We think that the target audience for our app would definitely be digital natives in Western countries that like similar simple messaging apps and social networks such as Snapchat or Instagram. Since iOS is much more prominent in Western than in developing countries, the choice of development target was straightforward for us. Also, the MapKit of iOS and the new features that were introduced with iOS 11 (MarkerAnnotations that we use a lot) seemed very exciting and opened up interesting design choices.

### Major Features
- Main Screen (**Map**): This is the heart of our app and users will spend most of their time on this screen. Users can see all messages dropped within a certain (user-specified) range and click on the annotations to see the message content. Messages are sorted and distinguished by different categories like "Funny", "Cute", "Educational", ... . If enabled in the settings, the mapview also provides a "Quickdrop" option, which allows the user to compose a message within the map view and drop it without changing tabs. Also, users can bookmark messages to save and review them later in the "Saved" tab.

- Compose Screen: This screen allows users to compose message in a more detailed way. They can choose a filter, the range in which the message should be visible, and the duration the message should be visible. Unless bookmarked, the message will disappear after the specified time.

- Saved Screen: This screen has two tabs and is divided into "Sent" and "Bookmarked". Both are table views of messages that have been saved or bookmarked. They will remain in the app until uninstall.

- Settings Screen: This screen allows adjusting some of the app's settings. Users can enable/disable the quickdrop function on the map screen, they can set default values for quickdrop distance and duration. Also, users can specify the maximum range from their position that they want to scan for new messages.

### Optional Features
- Firebase Implementation: The main map screen pulls and filters the messages that were dropped by users from Firebase. There is a refresh button on the map that allows the user to check Firebase for new messages in their surroundings. The map view also refreshes whenever the user changes back to its tab. Messages dropped via quickdrop as well as the compose function will be pushed to Firebase and pulled whenever the map view gets refreshed.

### Testing Methodologies

### Usage

### Lessons Learned


Our app uses GPS and the MapKit so it has to be **run on an actual device** and **will not behave normally in the Xcode simulator**.

- We implemented the MapView, it is our intended starting screen. It zooms to the user location on start up and updates it as it changes.
- Also, we built custom annotations to be displayed on the map (at the moment, two of them are displayed statically, they are automatically displayed in a different color depending on their category though) and the user is able to click on them to see the actual message content.
- We also took the necessary steps to implement Firebase into the app which will contain all the messages that users dropped.
