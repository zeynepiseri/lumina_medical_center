# Lumina Medical Center - Mobile Client

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-Language-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-FF4081?style=for-the-badge)
![State Management](https://img.shields.io/badge/State-BLoC-8A2BE2?style=for-the-badge)

The cross-platform mobile application for the Lumina Hospital Management System. Designed for high performance and maintainability, the app features distinct operational dashboards for Patients, Doctors, and Administrators.

🔗 **Backend API Repository:** [Lumina Core API](https://github.com/zeynepiseri/lumina-backend)

---

## Application Showcase

| Patient Flow | Book Appointment | My Appointments |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/e48728de-e96c-4755-b558-319da38e62e6" width="250" /> | <img src="https://github.com/user-attachments/assets/93d3be4b-cf73-441b-8e68-237ad9a769af" width="250" /> | <img src="https://github.com/user-attachments/assets/e0932afe-0685-47ad-a304-13f7df7f7e40" width="250" /> |
| **Doctor Detail** | **Admin Dashboard** | **Edit Doctor** |
| <img src="https://github.com/user-attachments/assets/968d346d-c18e-4a79-a28c-84543596bc11" width="250" /> | <img src="https://github.com/user-attachments/assets/4dda64c9-5c81-492f-9a4c-73efa7db2b74" width="250" /> | <img src="https://github.com/user-attachments/assets/2119773b-db8f-46be-9837-74ba83b4d9d2" width="250" /> |

---

## Architecture & Code Structure

The project strictly follows **Clean Architecture** combined with a **Feature-First** folder structure. This ensures highly decoupled, testable, and scalable code.

Each feature (e.g., `appointment`, `auth`, `doctor_dashboard`) is isolated into three layers:
* **`presentation/`**: Contains UI components (Widgets, Pages) and State Management (`BLoC` / `Cubit`).
* **`domain/`**: Houses the core business logic (Entities, Use Cases, Repository Interfaces).
* **`data/`**: Manages external data fetching (Remote Data Sources, Models, Repository Implementations).

### Core Tech Stack
* **State Management:** `flutter_bloc` / `cubit` (for predictable state transitions)
* **Dependency Injection:** `get_it` & `injectable` (for automated DI container generation)
* **Networking:** `dio` (configured with custom JWT interceptors for secure API calls)
* **Data Parsing:** `freezed` & `json_serializable` (for immutable models and safe JSON parsing)
* **Responsive UI:** `flutter_screenutil` (ensuring pixel-perfect layouts across different device dimensions)
* **Localization:** ARB-based internal i18n (`l10n/app_en.arb`, `app_tr.arb`).

---

## Key Features

* **Dynamic Role-Based UI:** The application dynamically routes users to entirely different flows (Admin Panel, Doctor Schedule Manager, Patient Portal) based on their JWT claims.
* **Complex Scheduling Interface:** Interactive time-slot generation matrix for booking appointments, preventing double-bookings natively.
* **Offline-First Capabilities:** Utilizes local data caching strategies for essential configurations and user sessions.
* **Real-time Form Validation:** Comprehensive form validations using custom reusable widget architectures.

---

## Local Setup & Installation

**Prerequisites:** Flutter SDK (3.x.x) and Dart installed on your machine.

```bash
# 1. Clone the repository
git clone [https://github.com/your-username/lumina_medical_center.git](https://github.com/your-username/lumina_medical_center.git)
cd lumina_medical_center

# 2. Fetch dependencies
flutter pub get

# 3. Generate boilerplate code (Crucial for DI and JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# 4. Generate localization files
flutter gen-l10n

# 5. Run the application
flutter run
