# PTSD---IM-OOP

 PUP Document Tracking System (PDTS)

Professional Document Tracking System developed for researchers/students. This system follows the Four Pillars of OOP (Encapsulation, Abstraction, Inheritance, and Polymorphism) and a Service-Oriented Architecture.

  Project Structure


pdts-project/
├── .vscode/               # IDE Settings for Java
├── src/
│   └── main/
│       ├── java/          # Backend Logic (Spring Boot Style)
│       │   └── com/pdts/
│       │       ├── model/      # Encapsulated Entity Classes
│       │       ├── service/    # Business Logic (Email, Token Gen)
│       │       └── controller/ # API Endpoint logic
│       └── resources/     # Assets & Templates
│           ├── static/    # CSS, JS, Images (Vanilla JS)
│           └── templates/ # HTML View Templates
├── database/              # MySQL Workbench SQL Scripts
└── README.md


  Getting Started

 1. Requirements
- Java 17+ (JDK)
- VS Code with "Extension Pack for Java"
- MySQL Workbench

 2. Database Setup
1. Open MySQL Workbench.
2. Create a new schema named `pdts_db`.
3. Open the file `database/pdts_schema.sql` and execute the script.
4. Update `src/main/resources/application.properties` with your MySQL credentials.

 3. Running in VS Code
1. Open the project folder in VS Code.
2. The IDE will automatically detect the Spring Boot project if the extensions are installed.
3. Click on the **Run** button found above the `main` method in `PdtsApplication.java`.
4. Access the landing page at `http://localhost:8080`.

  Key Features
- PUP-SIS Inspired UI: Dynamic MAROON-GOLD theme with animated backgrounds.
- Tokenized Tracking: Public search bar for real-time status updates via unique tokens.
- Automated Actions: 
  - Unique Token Generation (TRK-XXXXXXXX).
  - Automated Acknowledgement Emails.
  - Automated Receipt Generation.
- Normalized Address Database: Broken down into Barangay, City, Region for granular reporting.
- evidence Upload: Support for receipt photos (max 300KB).

  Development Roles
- Backend Developer: Java (Spring Boot), JPA, MySQL.
- Frontend Designer: HTML5, CSS3, Vanilla JS.
- Architect: System design following OOP principles.


