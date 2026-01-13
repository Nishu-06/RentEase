# RentEase – Property Management System

A complete full-stack property management application built with Spring Boot (Backend) and Flutter (Frontend). This project demonstrates clean architecture, JWT-based authentication, and RESTful API design.

## 📋 Project Overview

RentEase is a property management system that allows property owners to manage their properties and tenants. The system provides secure authentication, property CRUD operations, and tenant management capabilities.

## 🏗️ Architecture

```
┌─────────────┐         HTTP/REST          ┌─────────────┐         JDBC         ┌─────────────┐
│   Flutter   │ ◄────────────────────────► │ Spring Boot │ ◄──────────────────► │ PostgreSQL  │
│  (Frontend) │      (JWT Authenticated)    │  (Backend)  │    (Database)       │  (Database) │
└─────────────┘                             └─────────────┘                      └─────────────┘
```

### Flow:
1. **Frontend (Flutter)**: User interacts with Material UI screens
2. **Backend (Spring Boot)**: Handles business logic, authentication, and API endpoints
3. **Database (PostgreSQL)**: Stores users, properties, and tenants data

## 🛠️ Tech Stack

### Backend
- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Web** - REST API
- **Spring Data JPA** - Database operations
- **Spring Security** - Authentication & Authorization
- **JWT** - Token-based authentication
- **PostgreSQL** - Relational database
- **Maven** - Dependency management
- **Lombok** - Boilerplate reduction
- **BCrypt** - Password encryption

### Frontend
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **HTTP** - API communication
- **Shared Preferences** - Local token storage
- **Provider** - State management

## 📁 Project Structure

### Backend Structure
```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/rentease/
│   │   │   ├── controller/      # REST Controllers
│   │   │   ├── service/         # Business Logic
│   │   │   ├── repository/      # Data Access Layer
│   │   │   ├── entity/          # JPA Entities
│   │   │   ├── dto/             # Data Transfer Objects
│   │   │   ├── security/        # JWT & Security Config
│   │   │   ├── exception/       # Exception Handlers
│   │   │   └── RentEaseApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
└── pom.xml
```

### Frontend Structure
```
frontend/
├── lib/
│   ├── main.dart
│   ├── models/          # Data Models
│   ├── services/        # API Services
│   ├── screens/         # UI Screens
│   └── utils/           # Utilities (API Client)
└── pubspec.yaml
```

## ✨ Features

### Authentication
- User registration with email validation
- Secure login with JWT token
- Password encryption using BCrypt
- Token-based API authentication

### Property Management
- Create new properties
- View all properties
- View properties by owner
- Update property details
- Delete properties

### Tenant Management
- Create tenants linked to properties
- View all tenants
- View tenants by property
- Update tenant information
- Delete tenants

### Security
- JWT token authentication
- Secure password storage
- CORS configuration
- Protected API endpoints

## 🚀 Getting Started

### Prerequisites
- **Java 17** or higher
- **Maven 3.6+**
- **PostgreSQL 12+**
- **Flutter SDK 3.0+**
- **Dart SDK 3.0+**

### Backend Setup

#### 1. Database Setup
```sql
-- Create database
CREATE DATABASE rentease;

-- Or using psql command line
createdb rentease
```

#### 2. Configure Database
Edit `backend/src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/rentease
spring.datasource.username=postgres
spring.datasource.password=your_password
```

#### 3. Build and Run
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

The backend will start on `http://localhost:8080`

### Frontend Setup

#### 1. Install Dependencies
```bash
cd frontend
flutter pub get
```

#### 2. Configure API URL
Edit `frontend/lib/utils/api_client.dart` if your backend runs on a different host:
```dart
static const String baseUrl = 'http://localhost:8080';
```

For Android emulator, use `http://10.0.2.2:8080`
For iOS simulator, use `http://localhost:8080`
For physical device, use your computer's IP address (e.g., `http://192.168.1.100:8080`)

#### 3. Run Flutter App
```bash
flutter run
```

## 📡 API Documentation

### Base URL
```
http://localhost:8080/api
```

### Authentication Endpoints

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "User registered successfully",
  "userId": 1,
  "name": "John Doe",
  "email": "john@example.com"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "Login successful",
  "userId": 1,
  "name": "John Doe",
  "email": "john@example.com"
}
```

### Property Endpoints

#### Get All Properties
```http
GET /api/properties
Authorization: Bearer <token>
```

**Response:**
```json
[
  {
    "id": 1,
    "title": "2BHK Apartment",
    "address": "123 Main St, City",
    "rentAmount": 1500.00,
    "ownerId": 1,
    "ownerName": "John Doe"
  }
]
```

#### Create Property
```http
POST /api/properties
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "3BHK House",
  "address": "456 Oak Ave, City",
  "rentAmount": 2000.00
}
```

#### Get Property by ID
```http
GET /api/properties/{id}
Authorization: Bearer <token>
```

#### Update Property
```http
PUT /api/properties/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated Title",
  "address": "Updated Address",
  "rentAmount": 1800.00
}
```

#### Delete Property
```http
DELETE /api/properties/{id}
Authorization: Bearer <token>
```

### Tenant Endpoints

#### Get All Tenants
```http
GET /api/tenants
Authorization: Bearer <token>
```

#### Create Tenant
```http
POST /api/tenants
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Jane Smith",
  "email": "jane@example.com",
  "phone": "+1234567890",
  "propertyId": 1
}
```

#### Get Tenants by Property
```http
GET /api/tenants/property/{propertyId}
Authorization: Bearer <token>
```

#### Update Tenant
```http
PUT /api/tenants/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Jane Updated",
  "email": "jane.updated@example.com",
  "phone": "+1234567890",
  "propertyId": 1
}
```

#### Delete Tenant
```http
DELETE /api/tenants/{id}
Authorization: Bearer <token>
```

## 🔐 Authentication Flow

1. **Registration/Login**: User provides credentials
2. **Backend Validation**: Server validates and authenticates
3. **JWT Generation**: Server generates JWT token with user info
4. **Token Storage**: Frontend stores token in SharedPreferences
5. **API Requests**: Frontend includes token in `Authorization: Bearer <token>` header
6. **Token Validation**: Backend validates token on each request
7. **Access Control**: Only authenticated users can access protected endpoints

## 🧪 Testing APIs with Postman

### Step 1: Register a User
1. Create a new POST request to `http://localhost:8080/api/auth/register`
2. In **Body** tab, select **raw** and **JSON**
3. Add JSON:
```json
{
  "name": "Test User",
  "email": "test@example.com",
  "password": "test123"
}
```
4. Click **Send**
5. Copy the `token` from response

### Step 2: Create Property (Authenticated)
1. Create a new POST request to `http://localhost:8080/api/properties`
2. Go to **Headers** tab
3. Add header: `Authorization: Bearer <your_token_from_step_1>`
4. In **Body** tab, select **raw** and **JSON**
5. Add JSON:
```json
{
  "title": "Test Property",
  "address": "123 Test St",
  "rentAmount": 1000.00
}
```
6. Click **Send**

### Step 3: Get Properties
1. Create a new GET request to `http://localhost:8080/api/properties`
2. Add header: `Authorization: Bearer <your_token>`
3. Click **Send**

## 📱 Frontend Screens

### Login Screen
- Email and password input
- Register/Login toggle
- Form validation
- Loading states
- Error handling

### Property List Screen
- Display all properties
- Pull-to-refresh
- Empty state
- Logout functionality
- Navigation to add property

### Add Property Screen
- Form for property details
- Input validation
- Success/error feedback
- Navigation back to list

## 🔧 Configuration

### JWT Configuration
JWT settings are in `application.properties`:
```properties
jwt.secret=MySecretKeyForJWTTokenGenerationAndValidationInRentEaseApplication2024
jwt.expiration=86400000  # 24 hours in milliseconds
```

### CORS Configuration
CORS is configured in `SecurityConfig.java` to allow Flutter apps from:
- `http://localhost:3000`
- `http://localhost:5000`

## 📝 Notes

- This project follows **Clean Architecture** principles
- All passwords are encrypted using **BCrypt**
- JWT tokens expire after 24 hours
- Database schema is auto-generated by Hibernate (`spring.jpa.hibernate.ddl-auto=update`)
- All API endpoints (except `/api/auth/**`) require authentication
- Input validation is implemented using Bean Validation annotations

## 🐛 Troubleshooting

### Backend Issues
- **Port 8080 already in use**: Change `server.port` in `application.properties`
- **Database connection failed**: Verify PostgreSQL is running and credentials are correct
- **JWT token expired**: Login again to get a new token

### Frontend Issues
- **Cannot connect to backend**: 
  - Verify backend is running
  - Check API URL in `api_client.dart`
  - For physical devices, ensure device and computer are on same network
- **Build errors**: Run `flutter pub get` to install dependencies

## 📄 License

This project is built for educational purposes and internship interviews.

## 👨‍💻 Author

Built as a demonstration of full-stack development skills with Spring Boot and Flutter.

---

**Happy Coding! 🚀**
