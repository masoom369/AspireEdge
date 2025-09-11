# Software Requirements Specification  

**Version:** 1.0  
**Project Name:** AspireEdge  
**Theme:** Career Passport – Future Path Explorer  
**Category:** Cross-Platform App Development  

---

## Table of Contents  

1.1 Background and Necessity for Cross-Platform App  
1.2 Proposed Solution  
1.3 Purpose of this Document  
1.4 Scope of Project  
1.5 Constraints  
1.6 Functional Requirements  
1.7 Non-Functional Requirements  
1.8 Interface Requirements  
 Hardware  
 Software  
 Testing  
1.9 Project Deliverables  

---

## 1.1 Background and Necessity for Cross-Platform App  

Lack of structured guidance to students and young professionals in choosing the right career path often leads to confusion, dissatisfaction, and misaligned educational pursuits. Many individuals end up making critical academic or professional decisions without a clear understanding of their strengths, interests, or the opportunities available to them. Existing career guidance solutions are often fragmented, outdated, or overly generic, lacking the level of personalization and interactivity that today’s users expect.  

In a digitally evolving landscape, mobile-first experiences are becoming the norm. There is an urgent demand for an interactive, comprehensive, and user-friendly cross-platform app that simplifies career exploration. Such a platform should provide tailored recommendations, easy access to coaching tools, self-assessment modules, and inspirational content. This will help to bridge the gap between ambition and awareness and empower users to make informed decisions about their future.  

---

## 1.2 Proposed Solution  

A cross-platform app named AspireEdge is proposed as a solution that provides a tier-wise career guidance platform for:  

- School students (Grades 8–12)  
- College students and graduates (Undergraduates/Postgraduates)  
- Working professionals  

It combines modules such as CV tips, stream selectors, and interview prep with interactive tools including quizzes, resource hubs, and video libraries. These help to provide an engaging, end-to-end experience.  

---

## 1.3 Purpose of this Document  

This document defines the functional and non-functional requirements for the AspireEdge app. It is intended for developers, testers, stakeholders, and project managers to ensure alignment and clarity during design and development.  

---

## 1.4 Scope of Project  

The cross-platform app will incorporate a range of features designed to support diverse user needs. It will provide tiered navigation tailored to different user types, ensuring a personalized experience. Users can explore career options through tools such as a Career Bank and an Interest Quiz.  

The app will also include coaching aids such as a Stream Selector and modules focused on interview preparation and CV building. To further engage users, it will offer educational and motivational content, including blogs, videos, and success stories. Additionally, the app will collect user feedback through integrated forms and feature a login screen to control access and personalize the experience.  

---

## 1.5 Constraints  

The app must fetch live data from a connected database, support fast and secure authentication, and ensure minimal load times. Key modules such as quiz and resource hub should function smoothly even without constant backend access.  

---

## 1.6 Functional Requirements  

The app will be designed as a set of Forms/Pages, Navigation, and Fragments/Screens with menus representing choice of activities to be performed.  

Following are the functional requirements of cross-platform app:  

### Authentication (Login/SignUp)  

- Users (other than Admin) can register with their email, name, password, and selected tier.  
- Passwords should be securely stored in the database.  
- Registered users can log in and access tier-specific features.  
- Proper error handling and validation (email format and password strength) must be applied.  
- Registered users can login to AspireEdge app and access various features of the app.  
- After user has logged in, the username should be displayed at the top right corner.  
- Users can select their category (Student, Graduate, or Professional) to access personalized content.  
- Each user tier redirects to specific static or dynamic pages relevant to their career journey.  

**ADMIN:** This option will allow ADMIN to directly login to the app and perform administrative tasks. The tasks may include adding/modifying/deleting records in career bank and quizzes, post or update blogs, resources, and more.  

---

### Career Bank  

The Career Bank is a central feature of the app that allows users to explore a wide variety of career options.  

- Browse and filter careers by industry (IT, Health, Design, Agriculture, and so on.)  
- Each career card displays:  
  - Title  
  - Short Description  
  - Required Skills  
  - Salary Range  
  - Education Path (Outlines the typical academic journey required to pursue that profession viz. Recommended Degrees or Courses, Certifications, and so on.)  

---

### Admission and Coaching Tools  

The Admission and Coaching Tools section provides users with essential guidance to prepare for academic and career advancement.  

- Static modules:  
  - Stream Selector - Helps students choose the right academic stream based on interests and strengths.  
  - CV Tips - Offers resume formats, sample templates, and do’s and don’ts.  
  - Interview Preparation - Shares common interview questions, body language tips, and mock interview videos.  

- Content: Embedded videos and downloadable templates  

---

### Resources Hub  

It is a centralized library of curated content designed to support users in their career exploration and skill development journey.  

- Categories: Blogs, EBooks, Videos, Gallery  
  - Blogs on career tips, trends, and expert advice. Provides downloadable guides and study materials. Videos on talks by industry experts, tutorials, and so on.  
- Filter and search content by type  
- Dynamically loaded using metadata from JSON files or database  
- Enable bookmarking or favoriting of resources  
- Create a wishlist of items they would like to see in future  

---

### Career Interest Quiz  

- Multi-step quiz using score mapping: An interactive, guided quiz designed to assess user interests and preferences.  
- Suggest suitable career tier based on user responses: This feature analyzes user’s responses — such as their current education level, interests, and goals — to determine the most appropriate career tier for them.  
- AI powered quiz (optional): The AI-powered quiz dynamically analyzes user inputs to deliver personalized, data-driven career recommendations tailored to their interests and strengths.  

---

### Multimedia Guidance  

- Embedded videos, podcasts:  
  - Sessions by professionals sharing career journeys and advice.  
  - Podcasts with Audio content on skills, motivation, and industry trends.  
- Filter by tag: Experts, Career Talks, or Student Panels  

---

### Testimonials/Success Carousel  

This section showcases real stories from students, graduates, and professionals who have successfully navigated their career paths.  

- Rotating carousel of testimonials  
- Each includes name, image, and short success story  

---

### Feedback Forms  

- A form to accept user feedback with fields for name, email, contact number, and feedback. The feedback could be positive or negative (such as a bug report or error).  

---

### General Functionalities For Users  

- Contact Us:  
  - Inquiry form through which users can submit enquiries  
  - Contact details about the organization/team that has developed the app  
  - Google Maps integration for office location(s)  
- Search, Sort, and Filter: Users can search, sort, or filter careers by industry, salary, skills, title, interview types, coaching , and so on.  
- Push Notifications: Whenever a new resource is available, push notifications can be sent to users. Similarly, for blog updates and Quiz participation alerts.  
- User Profile: Users can view/update profile, change password, and visit their wishlist or bookmarked items.  

---

## 1.7 Non-Functional Requirements  

- **Performance:** The cross-platform app should demonstrate high value of performance through speed and throughput. In simple terms, the cross-platform app should be fast to load, transitions should be smooth.  
- **Security:** The cross-platform app should implement adequate security measures such as authentication. All data must be encrypted; role-based access control implemented.  
- **Scalability:** The app architecture and infrastructure should be designed to handle increasing user traffic, data storage, and feature expansions.  
- **Accessibility:** The cross-platform app should have clear and legible fonts, user-interface elements, and navigation elements.  
- **Reliability:** The cross-platform app should be available 24/7 with minimum downtime.  
- **Data Backup:** Scheduled auto-backups for records and logs should be performed.  
- **Offline Access:** Blogs and Quizzes should be available offline.  

These are the bare minimum expectations from the project. It is a must to implement the functional and non-functional requirements given in this SRS. Once they are complete, you can use your own creativity and imagination to add more features if required.  

---

## Database Design  

**Users**  
- User_Id (PK)  
- Name  
- Email  
- Password  
- Phone  
- Tier  

**Career Bank**  
- Career_Id (PK)  
- Title  
- Industry  
- Description  
- Skills  
- Salary_Range  
- Education_Path  

**Quiz**  
- Question_Id (PK)  
- Question_Text  
- Option_A  
- Option_B  
- Option_C  
- Option_D  
- Score_Map  

**Testimonials**  
- Testimonial_Id (PK)  
- Name  
- Image_Url  
- Tier  
- Story  

**Feedback**  
- Feedback_Id (PK)  
- User_Id (FK)  
- Name  
- Email  
- Phone  
- Message  
- Sub_Date_Time  

Similarly, you can define other entities and relationships between entities and methods representing activities on the entities.  

Note: These are just examples, you do not have to adhere to these structures and can design your own table structure with columns.  

---

## 1.8 Interface Requirements  

### Hardware  
- Intel Core i7/ i5 Processor or higher  
- 8 GB RAM or above  
- Color SVGA monitor  
- 500 GB Hard Disk space  
- Mouse  
- Keyboard  
- Internet access (4G or Wi-Fi)  

### Software  
- Programming Software and IDE:  
  - Android Studio IDE with Android 9 or higher with Java  
  - Flutter 1.2 with Dart 2.6 or higher  

- Database: SQLite or Firebase  

### Testing  
- You can test the cross-platform app using a mobile device (Android Smartphone or iPhone ) or a suitable emulator.  

---

## 1.9 Project Deliverables  

You must design and build the project and submit it along with a complete project report that includes:  

- Problem Definition  
- Design Specifications  
- Diagrams such as Flowcharts for various Activities, Data Flow Diagrams, and so on  
- Database Design  
- Android Package File (.apk file)  
- Test Data Used in the Project  
- Project Installation Instructions (if any)  
- User Credentials (Login ID and Password)  

Documentation is considered as a very important part of the project. Ensure that documentation is complete and comprehensive. Documentation should not contain any source code.  

The consolidated project will be submitted as a Source Code zip file with a ReadMe.doc file listing assumptions (if any) made at your end. It should include SQL scripts files (.sql) containing database and table definitions and Android Package File (.apk file) for the cross-platform app.  

Submit a video (.mp4 file) demonstrating the working of the cross-platform app, including all the functionalities of the project. This is MANDATORY.  

Over and above the given specifications, you can apply your creativity and logic to improve the cross-platform app.  

---

~~ End of the Document ~~
