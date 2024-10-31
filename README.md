**Feed It Forward App**

FeeditForward is a mobile application designed to tackle hunger by connecting recipients, donors, and organizations. The app provides a collaborative platform to streamline food donations, reduce waste, and ensure communities have access to nutritious food, supporting the mission of SDG 2: Zero Hunger. The recipients can request for donation, donors can donate their money to the recipients while the organizations collaborate with the supermarket to distribute the surplus food. 

**Table of contents**
- Featues
- Setup
- Dependencies
- Usage
- Contributing

**Features**
1. Recipient can request for food and locate foodbanks location
2. Donor contributions by donating directly through QR Code or Bank Number
3. Organization can create campaign to collect donation
4. Organization support for food distribution while collaborating with supermarkets
5. Real-time inventory and donation tracking
6. Reward system for donors to encourage them to donate
7. Real time notification and real-time updates
8. Organizations and donors can locate emergency alert location through map in the app
   
**Setup**

PREREQUISITE 
- Flutter SDK
- Dart SDK

INSTALLATION
1. Clone the repository
   git clone https://github.com/nrlayna/FeedItForward.git
   cd FeedItForward

2. Install dependencies
   flutter pub get

3. Run the app
   
**Dependencies**

The FeeditForward app relies on several Flutter packages. Here’s a list of the primary dependencies:

- firebase_core - Integrates Firebase into the app.
- firebase_auth - Provides user authentication features.
- cloud_firestore - Allows interaction with the Firestore database
- google_maps_flutter - To integrate Google Maps within the app

**Usage**

**_1. User Registration and Login_**
- User can choose their role (Recepient, Organization or Donor) before Sign Up/Sign In into the app.
- Once register, user can login using their email/username and password.

**_2. Recepient Requests and Donor Contribution_**
- Recipients can submit requests for food donations
- Donors and organization can view these requests and make contribution via the app, with real-time updates.

**_3. Organization and Supermarket Collaboration_**
- Organizations receive notifications for donations and manage distribution logistics
- Supermarkets list surplus food for quick redistribution to those in need
- Organization can create campaign to collect donation for the needy

**_4. Real-Time Tracking_**
- Track donations and distributions in real-time, improving transparency and efficiency

**_5. Reward System_**
- Donors can get badges by completing quest to encourage donors to donate more
  
