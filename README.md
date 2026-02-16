# Lumina Medical Center

**An Enterprise-Level, RBAC-enabled Hospital Management System built with Clean Architecture.**

---

## Project Overview

Lumina Medical Center is a comprehensive **Hospital Management System** engineered to streamline healthcare interactions. It bridges the gap between patients, medical staff, and administrators through a secure, cross-platform interface backed by a scalable Spring Boot backend architecture.

### Core Workflows

- **For Patients:** Seamless appointment booking, real-time doctor availability checks by specialty, and medical history tracking.
- **For Doctors:** A dedicated dashboard to manage daily schedules, view upcoming appointments, and update professional profiles.
- **For Admins:** A Web & Mobile optimized command center for managing hospital branches, overseeing doctor/patient records, and handling system-wide analytics.

---

## Screenshots

| Patient Flow | Book Appointment | My Appointments |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/e48728de-e96c-4755-b558-319da38e62e6" width="250" /> | <img src="https://github.com/user-attachments/assets/93d3be4b-cf73-441b-8e68-237ad9a769af" width="250" /> | <img src="https://github.com/user-attachments/assets/e0932afe-0685-47ad-a304-13f7df7f7e40" width="250" /> |
| **Doctor Detail** | **Admin Dashboard** | **Edit Doctor** |
| <img src="https://github.com/user-attachments/assets/968d346d-c18e-4a79-a28c-84543596bc11" width="250" /> | <img src="https://github.com/user-attachments/assets/4dda64c9-5c81-492f-9a4c-73efa7db2b74" width="250" /> | <img src="https://github.com/user-attachments/assets/2119773b-db8f-46be-9837-74ba83b4d9d2" width="250" /> |

---

## Architecture & Tech Stack

### Architecture

![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-blue)
![Feature First](https://img.shields.io/badge/Pattern-Feature--First-blue)
![MVVM](https://img.shields.io/badge/Pattern-MVVM-blue)
![RBAC](https://img.shields.io/badge/Security-RBAC-red)
![JWT](https://img.shields.io/badge/Auth-JWT-red)

---

### Technologies

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Bloc](https://img.shields.io/badge/State%20Management-Bloc-blue)
![Dio](https://img.shields.io/badge/Networking-Dio-orange)
![Spring Boot](https://img.shields.io/badge/Backend-SpringBoot-green?logo=springboot)
![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-blue?logo=postgresql)
![Docker](https://img.shields.io/badge/Container-Docker-blue?logo=docker)

---

### Detailed Stack

| Category | Technologies |
|----------|--------------|
| **Platforms** | Android, iOS, Web |
| **State Management** | flutter_bloc, equatable |
| **Dependency Injection** | get_it, injectable |
| **Responsive UI** | responsive_framework, flutter_screenutil, sidebarx |
| **Networking** | dio (JWT Interceptors), json_serializable |
| **Localization** | flutter_localizations, l10n, ARB |
| **Testing** | Unit Tests, Widget Tests, Mockito, BlocTest |
| **Backend** | Spring Boot, Spring Security |
| **Containerization** | Docker |
| **Infrastructure** | Render (Hosting), Neon (Serverless PostgreSQL) |

---

## Installation & Getting Started

The application is pre-configured to connect to the live backend (Render).  
You can run the mobile app directly without setting up a local server.

---

## Prerequisites

- Flutter SDK (3.x.x)
- Java JDK (17 or higher)

---

## 1. Mobile Application Setup (Flutter)

Navigate to the project directory and install dependencies.

```bash
# Get Flutter dependencies
flutter pub get

# Generate code files (Injectable & JSON Serialization)
dart run build_runner build --delete-conflicting-outputs

# Generate Localization files
flutter gen-l10n
```

---

## 2. Running the App

```bash
# Run on Android/iOS Emulator
flutter run

# Run Admin Dashboard on Web
flutter run -d chrome --web-renderer html
```

---

## Running Tests

```bash
# Run all tests
flutter test
```
