# Hospital Records Management System - API Documentation

## Overview

This document provides comprehensive documentation for all REST API endpoints in the Hospital Records Management System backend.

**Base URL:** `http://localhost:4000/api/v1`

**Authentication:** Most endpoints require JWT token authentication via Bearer token in the Authorization header.

---

## Table of Contents

1. [Authentication](#authentication)
2. [Patients](#patients)
3. [Doctors](#doctors)
4. [Departments](#departments)
5. [Inventory](#inventory)
6. [Prescriptions](#prescriptions)
7. [Audit Logs](#audit-logs)
8. [Response Codes](#response-codes)
9. [Error Handling](#error-handling)

---

## Authentication

### Login

**Endpoint:** `POST /auth/login`  
**Access:** Public  
**Description:** Authenticate user and receive JWT token

**Request Body:**
```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "name": "Alice Admin",
      "email": "alice@hospital.com",
      "role": "admin"
    }
  }
}
```

**Roles:**
- `admin` - Full system access
- `doctor` - Patient records, prescriptions
- `pharmacist` - Inventory, prescriptions (view)
- `receptionist` - Patient management

---

### Register User

**Endpoint:** `POST /auth/register`  
**Access:** Admin only  
**Description:** Register a new user account

**Headers:**
```
Authorization: Bearer <admin-token>
```

**Request Body:**
```json
{
  "name": "string (required)",
  "email": "string (required, valid email)",
  "password": "string (required, min 8 chars, must include uppercase, lowercase, number, special char)",
  "role": "string (required: admin|doctor|pharmacist|receptionist)"
}
```

**Response:** `201 Created`
```json
{
  "status": "success",
  "message": "User registered successfully",
  "data": {
    "id": 5,
    "name": "Dr. Emily Brown",
    "email": "emily.brown@hospital.com",
    "role": "doctor"
  }
}
```

---

### Refresh Token

**Endpoint:** `POST /auth/refresh`  
**Access:** Public  
**Description:** Refresh expired JWT token

**Request Body:**
```json
{
  "refreshToken": "string (required)"
}
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "token": "new-jwt-token"
  }
}
```

---

## Patients

### Get All Patients

**Endpoint:** `GET /patients`  
**Access:** Admin, Doctor, Receptionist  
**Description:** Retrieve paginated list of patients with optional filters

**Headers:**
```
Authorization: Bearer <token>
```

**Query Parameters:**
- `page` (integer, default: 1) - Page number
- `limit` (integer, default: 10) - Items per page
- `sort` (string, default: 'id') - Sort field
- `order` (string, default: 'desc') - Sort order (asc|desc)
- `search` (string, optional) - Search by name, phone, email, or national_id

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "patients": [
      {
        "id": 1,
        "first_name": "Jane",
        "last_name": "Doe",
        "dob": "1985-03-15",
        "gender": "female",
        "phone": "+1-555-0100",
        "email": "jane.doe@email.com",
        "address": "123 Main St, Springfield, IL 62701",
        "allergies": "Penicillin, Peanuts",
        "known_conditions": "Hypertension, Type 2 Diabetes",
        "created_at": "2024-01-10T08:30:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 45,
      "pages": 5
    }
  }
}
```

---

### Get Patient by ID

**Endpoint:** `GET /patients/:id`  
**Access:** Admin, Doctor, Receptionist  
**Description:** Retrieve detailed information for a specific patient

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "first_name": "Jane",
    "last_name": "Doe",
    "dob": "1985-03-15",
    "gender": "female",
    "national_id": "NAT123456789",
    "phone": "+1-555-0100",
    "email": "jane.doe@email.com",
    "address": "123 Main St, Springfield, IL 62701",
    "emergency_contact_name": "John Doe",
    "emergency_contact_phone": "+1-555-0101",
    "allergies": "Penicillin, Peanuts",
    "known_conditions": "Hypertension, Type 2 Diabetes",
    "created_at": "2024-01-10T08:30:00.000Z",
    "updated_at": "2024-01-10T08:30:00.000Z"
  }
}
```

---

### Create Patient

**Endpoint:** `POST /patients`  
**Access:** Admin, Doctor, Receptionist  
**Description:** Create a new patient record

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "first_name": "string (required)",
  "last_name": "string (required)",
  "dob": "string (required, format: YYYY-MM-DD)",
  "gender": "string (required: male|female|other)",
  "national_id": "string (optional)",
  "phone": "string (optional)",
  "email": "string (optional, valid email)",
  "address": "string (optional)",
  "emergency_contact_name": "string (optional)",
  "emergency_contact_phone": "string (optional)",
  "allergies": "string (optional)",
  "known_conditions": "string (optional)"
}
```

**Response:** `201 Created`
```json
{
  "status": "success",
  "message": "Patient created successfully",
  "data": {
    "id": 46,
    "first_name": "Michael",
    "last_name": "Johnson",
    "dob": "1975-08-20",
    "gender": "male",
    "phone": "+1-555-0200",
    "email": "michael.j@email.com"
  }
}
```

---

### Update Patient

**Endpoint:** `PUT /patients/:id`  
**Access:** Admin, Doctor, Receptionist  
**Description:** Update patient information

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:** (all fields optional)
```json
{
  "first_name": "string",
  "last_name": "string",
  "phone": "string",
  "email": "string",
  "address": "string",
  "allergies": "string",
  "known_conditions": "string"
}
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Patient updated successfully",
  "data": {
    "id": 1,
    "first_name": "Jane",
    "last_name": "Doe",
    "phone": "+1-555-9999",
    "updated_at": "2024-01-15T10:30:00.000Z"
  }
}
```

---

### Delete Patient

**Endpoint:** `DELETE /patients/:id`  
**Access:** Admin only  
**Description:** Soft delete a patient (sets deleted_at timestamp)

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Patient deleted successfully"
}
```

---

### Get Patient Medical Records

**Endpoint:** `GET /patients/:id/records`  
**Access:** Admin, Doctor  
**Description:** Retrieve complete medical history including prescriptions

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "patient": {
      "id": 1,
      "first_name": "Jane",
      "last_name": "Doe",
      "dob": "1985-03-15",
      "allergies": "Penicillin, Peanuts",
      "known_conditions": "Hypertension, Type 2 Diabetes"
    },
    "prescriptions": [
      {
        "id": 1,
        "issue_date": "2024-01-15T10:30:00.000Z",
        "notes": "Patient presenting with chest pain",
        "status": "active",
        "doctor_name": "Dr. John Smith",
        "specialization": "Cardiology",
        "items": [
          {
            "med_name": "Amoxicillin 500mg",
            "dose": "500mg",
            "frequency": "TID",
            "route": "oral",
            "quantity": 21,
            "instructions": "Take with food"
          }
        ]
      }
    ]
  }
}
```

---

## Doctors

### Get All Doctors

**Endpoint:** `GET /doctors`  
**Access:** Admin, Doctor, Receptionist  
**Description:** Retrieve list of all doctors

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "user_id": 2,
      "name": "Dr. John Smith",
      "email": "john.smith@hospital.com",
      "department_id": 1,
      "department_name": "Cardiology",
      "license_number": "MD-12345",
      "specialization": "Cardiology",
      "phone": "+1-555-0123"
    }
  ]
}
```

---

### Get Doctor by ID

**Endpoint:** `GET /doctors/:id`  
**Access:** Admin, Doctor, Receptionist  
**Description:** Retrieve detailed information for a specific doctor

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "user_id": 2,
    "name": "Dr. John Smith",
    "email": "john.smith@hospital.com",
    "department_id": 1,
    "department_name": "Cardiology",
    "license_number": "MD-12345",
    "specialization": "Cardiology",
    "phone": "+1-555-0123",
    "created_at": "2024-01-01T00:00:00.000Z"
  }
}
```

---

### Create Doctor

**Endpoint:** `POST /doctors`  
**Access:** Admin only  
**Description:** Create a new doctor profile

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "user_id": "integer (required)",
  "department_id": "integer (optional)",
  "license_number": "string (optional)",
  "specialization": "string (optional)",
  "phone": "string (optional)"
}
```

**Response:** `201 Created`
```json
{
  "status": "success",
  "message": "Doctor created successfully",
  "data": {
    "id": 5,
    "user_id": 10,
    "department_id": 2,
    "license_number": "MD-67890",
    "specialization": "Neurology"
  }
}
```

---

### Update Doctor

**Endpoint:** `PUT /doctors/:id`  
**Access:** Admin only  
**Description:** Update doctor information

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:** (all fields optional)
```json
{
  "department_id": "integer",
  "license_number": "string",
  "specialization": "string",
  "phone": "string"
}
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Doctor updated successfully"
}
```

---

### Delete Doctor

**Endpoint:** `DELETE /doctors/:id`  
**Access:** Admin only  
**Description:** Delete doctor profile

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Doctor deleted successfully"
}
```

---

## Departments

### Get All Departments

**Endpoint:** `GET /departments`  
**Access:** Admin, Doctor, Receptionist  
**Description:** Retrieve list of all departments

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "name": "Cardiology",
      "description": "Heart and cardiovascular system care",
      "created_at": "2024-01-01T00:00:00.000Z"
    }
  ]
}
```

---

### Get Department by ID

**Endpoint:** `GET /departments/:id`  
**Access:** Admin, Doctor, Receptionist  
**Description:** Retrieve specific department details

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "name": "Cardiology",
    "description": "Heart and cardiovascular system care",
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  }
}
```

---

### Create Department

**Endpoint:** `POST /departments`  
**Access:** Admin only  
**Description:** Create a new department

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "name": "string (required)",
  "description": "string (optional)"
}
```

**Response:** `201 Created`
```json
{
  "status": "success",
  "message": "Department created successfully",
  "data": {
    "id": 8,
    "name": "Neurology",
    "description": "Nervous system disorders"
  }
}
```

---

### Update Department

**Endpoint:** `PUT /departments/:id`  
**Access:** Admin only  
**Description:** Update department information

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "name": "string (optional)",
  "description": "string (optional)"
}
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Department updated successfully"
}
```

---

### Delete Department

**Endpoint:** `DELETE /departments/:id`  
**Access:** Admin only  
**Description:** Delete a department

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Department deleted successfully"
}
```

---

## Inventory

### Get All Inventory

**Endpoint:** `GET /inventory`  
**Access:** Admin, Doctor, Pharmacist  
**Description:** Retrieve paginated inventory list with filters

**Headers:**
```
Authorization: Bearer <token>
```

**Query Parameters:**
- `page` (integer, default: 1) - Page number
- `limit` (integer, default: 10) - Items per page
- `search` (string, optional) - Search by name or SKU
- `expiring_soon` (boolean, optional) - Filter items expiring within 30 days
- `low_stock` (boolean, optional) - Filter items with quantity < 50

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "inventory": [
      {
        "id": 1,
        "sku": "MED-AMOX-500",
        "name": "Amoxicillin 500mg",
        "description": "Antibiotic",
        "batch_number": "BATCH-2024-001",
        "expiry_date": "2025-06-30",
        "unit": "tablets",
        "quantity": 500,
        "location": "Pharmacy A, Shelf 3"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 120,
      "pages": 12
    }
  }
}
```

---

### Get Inventory by ID

**Endpoint:** `GET /inventory/:id`  
**Access:** Admin, Doctor, Pharmacist  
**Description:** Retrieve specific inventory item

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "sku": "MED-AMOX-500",
    "name": "Amoxicillin 500mg",
    "description": "Broad-spectrum antibiotic",
    "batch_number": "BATCH-2024-001",
    "expiry_date": "2025-06-30",
    "unit": "tablets",
    "quantity": 500,
    "location": "Pharmacy A, Shelf 3",
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-15T10:00:00.000Z"
  }
}
```

---

### Create Inventory Item

**Endpoint:** `POST /inventory`  
**Access:** Admin, Pharmacist  
**Description:** Add new inventory item

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "sku": "string (required, unique)",
  "name": "string (required)",
  "description": "string (optional)",
  "batch_number": "string (optional)",
  "expiry_date": "string (optional, format: YYYY-MM-DD)",
  "unit": "string (optional)",
  "quantity": "integer (required)",
  "location": "string (optional)"
}
```

**Response:** `201 Created`
```json
{
  "status": "success",
  "message": "Inventory item created successfully",
  "data": {
    "id": 121,
    "sku": "MED-LISIN-10",
    "name": "Lisinopril 10mg",
    "quantity": 500
  }
}
```

---

### Update Inventory Item

**Endpoint:** `PUT /inventory/:id`  
**Access:** Admin, Pharmacist  
**Description:** Update inventory item

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:** (all fields optional)
```json
{
  "quantity": "integer",
  "location": "string",
  "batch_number": "string",
  "expiry_date": "string"
}
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Inventory item updated successfully"
}
```

---

### Delete Inventory Item

**Endpoint:** `DELETE /inventory/:id`  
**Access:** Admin only  
**Description:** Delete inventory item

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Inventory item deleted successfully"
}
```

---

## Prescriptions

### Get All Prescriptions

**Endpoint:** `GET /prescriptions`  
**Access:** Admin, Doctor, Pharmacist  
**Description:** Retrieve paginated list of prescriptions

**Headers:**
```
Authorization: Bearer <token>
```

**Query Parameters:**
- `page` (integer, default: 1) - Page number
- `limit` (integer, default: 10) - Items per page
- `status` (string, optional) - Filter by status (active|completed|cancelled)
- `patient_id` (integer, optional) - Filter by patient
- `doctor_id` (integer, optional) - Filter by doctor

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "prescriptions": [
      {
        "id": 1,
        "patient_id": 1,
        "patient_name": "Jane Doe",
        "doctor_id": 1,
        "doctor_name": "Dr. John Smith",
        "issue_date": "2024-01-15T10:30:00.000Z",
        "notes": "Patient presenting with acute bronchitis",
        "status": "active",
        "items_count": 2
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 234,
      "pages": 24
    }
  }
}
```

---

### Get Prescription by ID

**Endpoint:** `GET /prescriptions/:id`  
**Access:** Admin, Doctor, Pharmacist  
**Description:** Retrieve detailed prescription with items

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "patient_id": 1,
    "patient_name": "Jane Doe",
    "doctor_id": 1,
    "doctor_name": "Dr. John Smith",
    "issue_date": "2024-01-15T10:30:00.000Z",
    "notes": "Patient presenting with acute bronchitis",
    "status": "active",
    "items": [
      {
        "id": 1,
        "inventory_id": 1,
        "med_name": "Amoxicillin 500mg",
        "dose": "500mg",
        "frequency": "TID (three times daily)",
        "route": "oral",
        "quantity": 21,
        "instructions": "Take with food for 7 days"
      },
      {
        "id": 2,
        "inventory_id": 2,
        "med_name": "Paracetamol 500mg",
        "dose": "500mg",
        "frequency": "Q6H PRN",
        "route": "oral",
        "quantity": 20,
        "instructions": "Take for pain or fever"
      }
    ]
  }
}
```

---

### Create Prescription

**Endpoint:** `POST /prescriptions`  
**Access:** Admin, Doctor  
**Description:** Create new prescription (automatically deducts inventory if inventory_id provided)

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "patient_id": "integer (required)",
  "doctor_id": "integer (required)",
  "notes": "string (optional)",
  "status": "string (optional, default: active)",
  "items": [
    {
      "inventory_id": "integer (optional, for inventory tracking)",
      "med_name": "string (required)",
      "dose": "string (optional)",
      "frequency": "string (optional)",
      "route": "string (optional)",
      "quantity": "integer (optional)",
      "instructions": "string (optional)"
    }
  ]
}
```

**Response:** `201 Created`
```json
{
  "status": "success",
  "message": "Prescription created successfully",
  "data": {
    "id": 235,
    "patient_id": 1,
    "doctor_id": 1,
    "status": "active",
    "items_created": 2
  }
}
```

---

### Update Prescription

**Endpoint:** `PUT /prescriptions/:id`  
**Access:** Admin, Doctor  
**Description:** Update prescription (notes and status only)

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "notes": "string (optional)",
  "status": "string (optional: active|completed|cancelled)"
}
```

**Response:** `200 OK`
```json
{
  "status": "success",
  "message": "Prescription updated successfully"
}
```

---

## Audit Logs

### Get Audit Logs

**Endpoint:** `GET /audit/logs`  
**Access:** Admin only  
**Description:** Retrieve audit trail logs with filters

**Headers:**
```
Authorization: Bearer <token>
```

**Query Parameters:**
- `page` (integer, default: 1) - Page number
- `limit` (integer, default: 50) - Items per page
- `user_id` (integer, optional) - Filter by user
- `action` (string, optional) - Filter by action (CREATE|UPDATE|DELETE)
- `object_type` (string, optional) - Filter by object type
- `start_date` (string, optional) - Filter from date (YYYY-MM-DD)
- `end_date` (string, optional) - Filter to date (YYYY-MM-DD)

**Response:** `200 OK`
```json
{
  "status": "success",
  "data": {
    "logs": [
      {
        "id": 1234,
        "user_id": 2,
        "user_name": "Dr. John Smith",
        "action": "CREATE",
        "object_type": "prescription",
        "object_id": 235,
        "changes": {
          "patient_id": 1,
          "doctor_id": 1,
          "status": "active"
        },
        "created_at": "2024-01-15T10:30:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 50,
      "total": 5678,
      "pages": 114
    }
  }
}
```

---

## Response Codes

| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Request successful |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Invalid request data or validation error |
| 401 | Unauthorized | Missing or invalid authentication token |
| 403 | Forbidden | Insufficient permissions for the action |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Resource conflict (e.g., duplicate email) |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |

---

## Error Handling

### Error Response Format

All errors follow a consistent format:

```json
{
  "status": "fail",
  "message": "Error description"
}
```

### Common Errors

**Validation Error (400):**
```json
{
  "status": "fail",
  "message": "\"first_name\" is required, \"email\" must be a valid email"
}
```

**Unauthorized (401):**
```json
{
  "status": "fail",
  "message": "No token provided. Please authenticate."
}
```

**Forbidden (403):**
```json
{
  "status": "fail",
  "message": "You do not have permission to perform this action."
}
```

**Not Found (404):**
```json
{
  "status": "fail",
  "message": "Patient not found"
}
```

**Conflict (409):**
```json
{
  "status": "fail",
  "message": "Email already registered"
}
```

**Rate Limited (429):**
```json
{
  "status": "fail",
  "message": "Too many requests from this IP. Please try again later."
}
```

**Server Error (500):**
```json
{
  "status": "error",
  "message": "Something went wrong. Please try again later."
}
```

---

## Authentication Flow

1. **Login:** `POST /auth/login` with email and password
2. **Receive Token:** Store the JWT token securely
3. **Use Token:** Include in Authorization header: `Bearer <token>`
4. **Token Expiry:** Default expiry is 1 hour
5. **Refresh:** Use `POST /auth/refresh` to get a new token

### Example Authentication Header

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInJvbGUiOiJhZG1pbiIsImlhdCI6MTcwNjc4NDAwMCwiZXhwIjoxNzA2Nzg3NjAwfQ.xxx
```

---

## Rate Limiting

- **Authentication endpoints:** 5 requests per 15 minutes per IP
- **General endpoints:** 100 requests per 15 minutes per IP

---

## Security Notes

1. **HTTPS Required:** All production traffic must use HTTPS
2. **Token Storage:** Store tokens securely (not in localStorage for web apps)
3. **Password Requirements:** Minimum 8 characters with uppercase, lowercase, number, and special character
4. **PHI Protection:** All patient data is considered Protected Health Information
5. **Audit Trail:** All CREATE, UPDATE, DELETE operations are logged
6. **Soft Deletes:** Patients and users are soft-deleted to maintain audit trail

---

## Testing

### Default Test Users

After running seed data:

| Email | Password | Role |
|-------|----------|------|
| alice@hospital.com | Admin@123 | admin |
| john.smith@hospital.com | Doctor@123 | doctor |
| sarah.johnson@hospital.com | Pharmacist@123 | pharmacist |

---

## Support

For API issues or questions:
- Check error messages for detailed information
- Review audit logs for debugging (admin only)
- Ensure proper authentication headers are included
- Verify role permissions for the endpoint

---

**Version:** 1.0.0  
**Last Updated:** November 2024
