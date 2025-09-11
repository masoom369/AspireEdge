# Software Requirements Specification (SRS)

**Version:** 1.0  
**Project Name:** AspireEdge  
**Theme:** Career Passport – Future Path Explorer  
**Category:** Cross-Platform App Development  

---

## 1. Introduction

### 1.1 Background and Necessity
Students and young professionals often lack structured guidance in choosing the right career path, leading to confusion, dissatisfaction, and misaligned education or work choices. Existing career guidance platforms are often generic, outdated, or fragmented.  
A modern solution requires **personalized, interactive, and mobile-first experiences** to bridge the gap between ambition and awareness.

### 1.2 Proposed Solution
A cross-platform app named **AspireEdge** will serve as a **tier-wise career guidance platform** for:
- School students (Grades 8–12)  
- College students (UG/PG)  
- Working professionals  

It will combine:
- Career exploration (Career Bank, Quizzes)  
- Coaching tools (Stream Selector, CV Tips, Interview Prep)  
- Interactive content (Videos, Blogs, Testimonials)  

### 1.3 Purpose of Document
This document defines the **functional and non-functional requirements** for AspireEdge. It serves as a reference for developers, testers, and stakeholders.

### 1.4 Scope
The app will:
- Provide tier-based navigation (Student, Graduate, Professional)  
- Offer **career exploration tools** (Career Bank, Interest Quiz)  
- Include **coaching aids** (Stream Selector, CV Tips, Interview Prep)  
- Deliver **educational & motivational content** (Blogs, Videos, Success Stories)  
- Collect user feedback via integrated forms  
- Secure access through login/sign-up  

### 1.5 Constraints
- Must fetch live data from DB  
- Support secure authentication  
- Minimal load times  
- Some modules (Quiz, Resource Hub) must work offline  

---

## 2. Functional Requirements

The app consists of forms, pages, navigation, and fragments/screens.

### 2.1 Authentication (Login/SignUp)
- Users register with email, name, password, and tier  
- Secure password storage  
- Validation (email format, password strength)  
- Login for registered users  
- Username displayed after login  
- Tier selection → personalized content  
- **Admin access**: manage Career Bank, Quizzes, Blogs, Resources  

### 2.2 Career Bank
- Browse/filter careers by industry  
- Career card shows:  
  - Title  
  - Description  
  - Skills required  
  - Salary Range  
  - Education Path (Degrees, Certifications, Courses)  

### 2.3 Admission & Coaching Tools
- **Stream Selector** (choose academic path)  
- **CV Tips** (templates, do’s/don’ts)  
- **Interview Preparation** (Q&A, body language, mock videos)  
- Embedded videos & downloadable templates  

### 2.4 Resources Hub
- Categories: Blogs, EBooks, Videos, Gallery  
- Filter & search content  
- Bookmark & wishlist support  
- Dynamic content loading (JSON/DB)  

### 2.5 Career Interest Quiz
- Multi-step interactive quiz with score mapping  
- Suggest suitable career tier  
- Optional AI-powered analysis  

### 2.6 Multimedia Guidance
- Embedded **Videos & Podcasts**  
- Filters: Experts, Career Talks, Student Panels  

### 2.7 Testimonials / Success Carousel
- Rotating success stories  
- Each story includes name, image, and career journey  

### 2.8 Feedback Forms
- Fields: Name, Email, Contact, Feedback (positive/negative/bug)  

### 2.9 General Functionalities
- **Contact Us** (form, details, Google Maps integration)  
- **Search, Sort, Filter** (careers/resources)  
- **Push Notifications** (new blogs, resources, quizzes)  
- **User Profile** (update info, change password, wishlist/bookmarks)  

---

## 3. Non-Functional Requirements
- **Performance**: Fast load, smooth transitions  
- **Security**: Authentication, encryption, RBAC  
- **Scalability**: Handle growth in users & data  
- **Accessibility**: Clear UI, legible fonts  
- **Reliability**: 24/7 availability, minimal downtime  
- **Data Backup**: Auto-backups for logs & records  
- **Offline Access**: Blogs & Quizzes available offline  

---

## 4. Database Design (Sample)
### Users
- User_Id (PK), Name, Email, Password, Phone, Tier  

### Career Bank
- Career_Id (PK), Title, Industry, Description, Skills, Salary_Range, Education_Path  

### Quiz
- Question_Id (PK), Question_Text, Options (A–D), Score_Map  

### Testimonials
- Testimonial_Id (PK), Name, Image_URL, Tier, Story  

### Feedback
- Feedback_Id (PK), User_Id (FK), Name, Email, Phone, Message, Sub_Date_Time  

---

## 5. Interface Requirements

### Hardware
- Intel i5/i7 or higher  
- 8 GB RAM+  
- 500 GB HDD  
- Internet (4G/WiFi)  

### Software
- IDE: Android Studio (Java) or Flutter (Dart)  
- Database: SQLite / Firebase  

### Testing
- On Android/iOS device or emulator  

---

## 6. Project Deliverables
- Project report (problem definition, design specs, diagrams, DB design)  
- Source code (zip file) + ReadMe.doc  
- SQL script files  
- Android Package File (.apk)  
- Test data  
- User credentials  
- Demo video (.mp4) showing full functionality  

---