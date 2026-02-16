# Lumina Medical Center

**A production-ready, RBAC-enabled Hospital Management System built with Clean Architecture.**

## 🏥 Project Overview

Lumina Medical Center is a comprehensive **Hospital Management System** engineered to streamline healthcare interactions. It bridges the gap between patients, medical staff, and administrators through a secure, cross-platform interface backed by a robust microservices architecture.

**Core Workflows:**
* **For Patients:** Seamless appointment booking, real-time doctor availability checks by specialty, and medical history tracking.
* **For Doctors:** A dedicated dashboard to manage daily schedules, view upcoming appointments, and update professional profiles.
* **For Admins:** A Web & Mobile optimized command center for managing hospital branches, overseeing doctor/patient records, and handling system-wide analytics.

## 📱 Screenshots

| Patient Flow | Doctor Dashboard | Admin Panel |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/e48728de-e96c-4755-b558-319da38e62e6" width="250" /> | <img src="https://github.com/user-attachments/assets/93d3be4b-cf73-441b-8e68-237ad9a769af" width="250" /> | <img src="https://github.com/user-attachments/assets/e0932afe-0685-47ad-a304-13f7df7f7e40" width="250" /> |
| **Appointment Detail** | **Profile & Stats** | **Clean UI** |
| <img src="https://github.com/user-attachments/assets/968d346d-c18e-4a79-a28c-84543596bc11" width="250" /> | <img src="https://github.com/user-attachments/assets/4dda64c9-5c81-492f-9a4c-73efa7db2b74" width="250" /> | <img src="https://github.com/user-attachments/assets/93d3be4b-cf73-441b-8e68-237ad9a769af" width="250" /> |

## ⚡ Architectural Highlights

* **Cross-Platform Core:** Single codebase deploying to **Android, iOS, and Web**, utilizing `responsive_framework` and `flutter_screenutil` for adaptive layouts across different screen sizes.
* **Role-Based Access Control (RBAC):** Distinct, secure flows for **Admins** (Web-optimized Dashboard), **Doctors**, and **Patients** protected by JWT authentication.
* **Clean Architecture & Feature-First:** Strict separation of concerns (Domain, Data, Presentation) ensuring scalability and testability.
* **Microservices Backend:** Custom **Spring Boot** API handling complex scheduling logic, PostgreSQL persistence, and Spring Security.

## 🛠 Tech Stack

| Category | Technologies |
| :--- | :--- |
| **Platforms** | Android, iOS, Web (Chrome/Safari) |
| **Architecture** | Clean Architecture, Feature-First, MVVM |
| **State Management** | `flutter_bloc`, `equatable`, `get_it`, `injectable` |
| **Responsive UI** | `responsive_framework`, `flutter_screenutil`, `sidebarx` (Web Nav) |
| **Networking** | `dio` (Interceptors for JWT), `json_serializable` |
| **Quality Assurance** | Unit & Widget Tests, Mockito, BlocTest |
| **Backend** | **Spring Boot**, PostgreSQL, Spring Security, Docker |
