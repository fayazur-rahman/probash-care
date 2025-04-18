# Probash Care – Your One-Step Solution for Expatriate Welfare

**Probash Care** is an innovative mobile application built using Flutter to support **Bangladeshi expatriates**—whether they are students pursuing higher education or workers seeking ethical employment abroad. It provides verified, relevant, and practical resources that make life easier while living overseas.

---

## 🚀 Getting Started

Probash Care helps users navigate the challenges of migration by offering:

- ✅ Verified resources and support for **students** and **job seekers**  
- ✅ Visa guidance and legal support for **laborers**  
- ✅ Community connection, emergency help, and updates on migration policy  

---

## 🧰 Technology Used

- **Flutter** – For cross-platform mobile app development  
- **Dart** – Programming language used by Flutter  
- **Firebase Authentication** – For secure user login and registration  
- **Cloud Firestore** – For storing and retrieving user and app data  
- **URL Launcher** – To open external agency websites and video links  
- **Provider** – For state management across screens  

---

## 📦 How to Install & Run

To set up and run the Probash Care app locally, follow these steps:

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/probash-care.git
   cd probash-care

2. **Install dependencies**
   ```bash
   flutter pub get

4. **Connect to Firebase**
   - Create a Firebase project at https://console.firebase.google.com
   - Add your google-services.json (Android) or GoogleService-Info.plist (iOS) to the respective folders
   - Enable Email/Password authentication in Firebase Authentication
   - Create the necessary Firestore collections (e.g., users, agencies, courses)
     
6. **Run the app**
   ```bash
   flutter run

> **Note**: Make sure you have Flutter and Dart installed, and your Android/iOS emulator or real device is properly set up.

---

## 🔐 User Authentication

### 🔸 Login & Registration

<div style="display: flex; gap: 10px;">
  <img src="Screenshots/1.png" alt="Login Page" width="150"/>
  <img src="Screenshots/2.jpg" alt="Registration Page" width="150"/>
</div>

Users can log in with existing credentials or register with necessary details by clicking the sign-up button.

---

### 🔸 Email Verification Process

<div style="display: flex; gap: 10px;">
  <img src="Screenshots/3.jpg" alt="Verification Message" width="150"/>
  <img src="Screenshots/4.jpg" alt="Verification Email" width="150"/>
  <img src="Screenshots/5.jpg" alt="Verified Message" width="150"/>
</div>

After registering, users receive a verification message. They must confirm their email via the link received in the email. Without this verification, login will not be permitted.

---

### 🔸 Accessing the Dashboard

<div style="display: flex; gap: 10px;">
  <img src="Screenshots/6.jpg" alt="Login Page Verified" width="150"/>
  <img src="Screenshots/7.jpg" alt="Dashboard" width="150"/>
</div>

Once verified, users can log in and land on the dashboard. From here, they can explore Hot Topics or choose between Student and Laborer services.

---

## 🎓 Student Services

### 🔸 Search Functionality

<img src="Screenshots/10.jpg" alt="Student Search" width="150"/>

Students select their desired country and degree type to access customized support.

---

### 🔸 Student Resources Overview

<div style="display: flex; gap: 10px;">
  <img src="Screenshots/11.jpg" alt="Agency List" width="150"/>
  <img src="Screenshots/12.jpg" alt="Agency Detail" width="150"/>
  <img src="Screenshots/13.jpg" alt="External Agency Link" width="150"/>
</div>

Students can view filtered agency lists, see detailed information for each agency, and access their official websites directly.

Available resources include:
- Verified agencies
- IELTS prep materials
- Visa guidance
- Scholarship info

---

## 🛠️ Laborer Support

### 🔸 Job Search and Resources

<img src="Screenshots/16.jpg" alt="Laborer Search" width="150"/>

Laborers select their target country and job type to view tailored opportunities and support options.

---

### 🔸 Course and Training Resources

<div style="display: flex; gap: 10px;">
  <img src="Screenshots/17.jpg" alt="Course List" width="150"/>
  <img src="Screenshots/18.jpg" alt="Course Detail" width="150"/>
</div>

Relevant training courses appear based on job type. For instance, selecting a construction job may suggest a “12 Steps of Construction” YouTube course, linked directly within the app.

---

## 📋 Side Navigation Menu

<img src="Screenshots/19.jpg" alt="Sidebar Navigation" width="150"/>

The app’s sidebar allows access to:
- Home  
- Students  
- Laborers  
- Profile  
- Feedback  
- Logout  

---

## 👤 Profile Management

<img src="Screenshots/20.jpg" alt="Profile Page" width="150"/>

Users can view and update their profile information directly within the app.

---

## 💬 Feedback System

<img src="Screenshots/23.jpg" alt="Feedback Page" width="150"/>

Users can submit feedback to improve the app and share their experiences.

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss the changes you'd like to propose.

---

## 📧 Contact

For support or collaboration:  
**Email:** fayazur7@gmail.com  
**Developed By:** [MD Fayazur Rahman](https://www.linkedin.com/in/md-fayazur-rahman/)

---
