# final-project-final-opal

Cabell Glancy (bcg7mf) <br>
Matias Rietig (mjr9r)

---

Our app uses GPS and the MapKit so it has to be **run on an actual device** and **will not behave normally in the Xcode simulator**.

- We implemented the MapView, it is our intended starting screen. It zooms to the user location on start up and updates it as it changes.
- Also, we built custom annotations to be displayed on the map (at the moment, two of them are displayed statically, they are automatically displayed in a different color depending on their category though) and the user is able to click on them to see the actual message content.
- We also took the necessary steps to implement Firebase into the app which will contain all the messages that users dropped.
