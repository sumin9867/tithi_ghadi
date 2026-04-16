# Backend API Specification for Push Notifications

This document outlines the API endpoints your backend needs to implement to support push notifications in the Tithi Gadhi Flutter app.

## Overview

The app uses Firebase Cloud Messaging (FCM) for push notifications. Your backend needs to:

1. Store the mapping between users and their FCM tokens
2. Provide endpoints to register/update/unregister devices
3. Use the FCM tokens to send notifications via Firebase Admin SDK

## Authentication

All endpoints require authentication. The client sends:
- `idToken`: Firebase ID token obtained after user authentication
- Server-side: Verify the token with Firebase Admin SDK

```python
# Python example
from firebase_admin import auth

try:
    decoded_token = auth.verify_id_token(id_token)
    user_id = decoded_token['uid']
    email = decoded_token['email']
except Exception as e:
    return error_response("Invalid token")
```

## Endpoints

### 1. Register Device

**Endpoint**: `POST /auth/register-device`

Register a device when user logs in. This stores the FCM token for future notifications.

#### Request

```json
{
  "idToken": "eyJhbGciOiJIUzI1NiJ9...",
  "fcmToken": "fcm:APA91bHkT5...",
  "deviceId": "flutter-device-12345",
  "deviceName": "Pixel 8 Pro"
}
```

**Fields**:
- `idToken` (required): Firebase ID token
- `fcmToken` (required): Firebase Cloud Messaging token
- `deviceId` (required): Unique device identifier
- `deviceName` (optional): Human-readable device name for management

#### Response

**Success (200 OK)**:
```json
{
  "status": "success",
  "message": "Device registered successfully",
  "device_id": "flutter-device-12345"
}
```

**Error (400 Bad Request)**:
```json
{
  "status": "error",
  "message": "Invalid or missing FCM token"
}
```

**Error (401 Unauthorized)**:
```json
{
  "status": "error",
  "message": "Invalid ID token"
}
```

#### Implementation Example (Python/Flask)

```python
from flask import request, jsonify
from firebase_admin import auth
import datetime

@app.route('/auth/register-device', methods=['POST'])
def register_device():
    data = request.get_json()
    
    # Validate input
    if not data.get('idToken') or not data.get('fcmToken'):
        return jsonify({
            "status": "error",
            "message": "idToken and fcmToken are required"
        }), 400
    
    try:
        # Verify Firebase token
        decoded_token = auth.verify_id_token(data['idToken'])
        user_id = decoded_token['uid']
        
        # Store/update device record
        device = {
            'user_id': user_id,
            'fcm_token': data['fcmToken'],
            'device_id': data.get('deviceId'),
            'device_name': data.get('deviceName'),
            'registered_at': datetime.datetime.utcnow(),
            'last_updated': datetime.datetime.utcnow(),
            'is_active': True
        }
        
        # Save to database (example with MongoDB)
        db.devices.update_one(
            {'user_id': user_id, 'device_id': data.get('deviceId')},
            {'$set': device},
            upsert=True
        )
        
        return jsonify({
            "status": "success",
            "message": "Device registered successfully",
            "device_id": data.get('deviceId')
        }), 200
        
    except auth.InvalidIdTokenError:
        return jsonify({
            "status": "error",
            "message": "Invalid ID token"
        }), 401
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500
```

---

### 2. Update FCM Token

**Endpoint**: `POST /auth/update-fcm-token`

Update the FCM token when it refreshes (happens periodically or when user reinstalls app).

#### Request

```json
{
  "idToken": "eyJhbGciOiJIUzI1NiJ9...",
  "fcmToken": "fcm:APA91bHkT5..."
}
```

**Fields**:
- `idToken` (required): Firebase ID token
- `fcmToken` (required): New Firebase Cloud Messaging token

#### Response

**Success (200 OK)**:
```json
{
  "status": "success",
  "message": "FCM token updated",
  "updated_devices": 1
}
```

**Error (401 Unauthorized)**:
```json
{
  "status": "error",
  "message": "Invalid ID token"
}
```

#### Implementation Example (Python/Flask)

```python
@app.route('/auth/update-fcm-token', methods=['POST'])
def update_fcm_token():
    data = request.get_json()
    
    if not data.get('idToken') or not data.get('fcmToken'):
        return jsonify({
            "status": "error",
            "message": "idToken and fcmToken are required"
        }), 400
    
    try:
        decoded_token = auth.verify_id_token(data['idToken'])
        user_id = decoded_token['uid']
        
        # Update all devices for this user with new token
        result = db.devices.update_many(
            {'user_id': user_id},
            {
                '$set': {
                    'fcm_token': data['fcmToken'],
                    'last_updated': datetime.datetime.utcnow()
                }
            }
        )
        
        return jsonify({
            "status": "success",
            "message": "FCM token updated",
            "updated_devices": result.modified_count
        }), 200
        
    except auth.InvalidIdTokenError:
        return jsonify({
            "status": "error",
            "message": "Invalid ID token"
        }), 401
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500
```

---

### 3. Unregister Device

**Endpoint**: `POST /auth/unregister-device`

Unregister a device when user logs out. This removes the FCM token from storage.

#### Request

```json
{
  "idToken": "eyJhbGciOiJIUzI1NiJ9..."
}
```

**Fields**:
- `idToken` (required): Firebase ID token

#### Response

**Success (200 OK)**:
```json
{
  "status": "success",
  "message": "Device unregistered",
  "deleted_devices": 1
}
```

**Error (401 Unauthorized)**:
```json
{
  "status": "error",
  "message": "Invalid ID token"
}
```

#### Implementation Example (Python/Flask)

```python
@app.route('/auth/unregister-device', methods=['POST'])
def unregister_device():
    data = request.get_json()
    
    if not data.get('idToken'):
        return jsonify({
            "status": "error",
            "message": "idToken is required"
        }), 400
    
    try:
        decoded_token = auth.verify_id_token(data['idToken'])
        user_id = decoded_token['uid']
        
        # Mark devices as inactive (or delete)
        result = db.devices.update_many(
            {'user_id': user_id},
            {
                '$set': {
                    'is_active': False,
                    'last_updated': datetime.datetime.utcnow()
                }
            }
        )
        
        return jsonify({
            "status": "success",
            "message": "Device unregistered",
            "deleted_devices": result.modified_count
        }), 200
        
    except auth.InvalidIdTokenError:
        return jsonify({
            "status": "error",
            "message": "Invalid ID token"
        }), 401
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500
```

---

## Database Schema

### Devices Collection/Table

Store FCM tokens for push notifications.

```javascript
// MongoDB Schema Example
db.devices.createCollection("devices", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["user_id", "fcm_token", "device_id", "registered_at"],
      properties: {
        _id: { bsonType: "objectId" },
        user_id: {
          bsonType: "string",
          description: "Firebase UID"
        },
        fcm_token: {
          bsonType: "string",
          description: "Firebase Cloud Messaging token"
        },
        device_id: {
          bsonType: "string",
          description: "Unique device identifier"
        },
        device_name: {
          bsonType: "string",
          description: "Human-readable device name"
        },
        registered_at: {
          bsonType: "date",
          description: "When device was first registered"
        },
        last_updated: {
          bsonType: "date",
          description: "When FCM token was last updated"
        },
        is_active: {
          bsonType: "bool",
          description: "Whether device is active"
        }
      }
    }
  }
});

// Create index for faster lookups
db.devices.createIndex({ user_id: 1 });
db.devices.createIndex({ device_id: 1 });
```

```sql
-- PostgreSQL Schema Example
CREATE TABLE devices (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    fcm_token VARCHAR(500) NOT NULL,
    device_id VARCHAR(255),
    device_name VARCHAR(255),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE(user_id, device_id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE INDEX idx_user_id ON devices(user_id);
CREATE INDEX idx_device_id ON devices(device_id);
```

---

## Sending Notifications

Once you have FCM tokens stored, you can send notifications using Firebase Admin SDK.

### Example: Send Notification to User

```python
# Python example with firebase-admin
from firebase_admin import messaging

def send_notification_to_user(user_id, title, body, data=None):
    """Send notification to all active devices for a user"""
    
    # Get all active FCM tokens for user
    devices = db.devices.find({
        'user_id': user_id,
        'is_active': True
    })
    
    tokens = [device['fcm_token'] for device in devices]
    
    if not tokens:
        print(f"No active devices found for user {user_id}")
        return
    
    # Prepare message
    notification = messaging.Notification(
        title=title,
        body=body
    )
    
    multicast_message = messaging.MulticastMessage(
        notification=notification,
        data=data or {},
        tokens=tokens
    )
    
    # Send message
    response = messaging.send_multicast(multicast_message)
    
    print(f"Sent {response.success_count} messages successfully")
    
    # Handle failures (optional)
    if response.failure_count > 0:
        for idx, error in enumerate(response.errors):
            print(f"Failed to send to {tokens[idx]}: {error}")
            
            # Mark invalid token as inactive
            if isinstance(error, messaging.UnregisteredError):
                db.devices.update_one(
                    {'fcm_token': tokens[idx]},
                    {'$set': {'is_active': False}}
                )
```

### Example: Send Notification to Multiple Users

```python
def send_notification_to_users(user_ids, title, body, data=None):
    """Send notification to multiple users"""
    
    # Get tokens for all users
    devices = db.devices.find({
        'user_id': {'$in': user_ids},
        'is_active': True
    })
    
    tokens = [device['fcm_token'] for device in devices]
    
    if not tokens:
        print("No active devices found")
        return
    
    # Batch send (Firebase has a limit of 500 tokens per request)
    batch_size = 500
    for i in range(0, len(tokens), batch_size):
        batch_tokens = tokens[i:i + batch_size]
        
        multicast_message = messaging.MulticastMessage(
            notification=messaging.Notification(title=title, body=body),
            data=data or {},
            tokens=batch_tokens
        )
        
        response = messaging.send_multicast(multicast_message)
        print(f"Batch {i//batch_size + 1}: Sent {response.success_count} messages")
```

---

## Sample Notifications

### Tithi Update Notification

```json
{
  "notification": {
    "title": "Tithi Update",
    "body": "Today's Tithi is Shukla Chaturthi"
  },
  "data": {
    "action": "tithi_update",
    "tithi": "Shukla Chaturthi",
    "date": "2026-04-16"
  }
}
```

### Festival Reminder

```json
{
  "notification": {
    "title": "Festival Alert",
    "body": "Ramnavami is tomorrow"
  },
  "data": {
    "action": "festival_reminder",
    "festival": "Ramnavami",
    "date": "2026-04-17"
  }
}
```

### Auspicious Time Notification

```json
{
  "notification": {
    "title": "Auspicious Time",
    "body": "Good time for important tasks: 2:30 PM - 3:45 PM"
  },
  "data": {
    "action": "auspicious_time",
    "start_time": "14:30",
    "end_time": "15:45"
  }
}
```

---

## Error Handling

Handle these common Firebase errors:

```python
from firebase_admin import messaging

def handle_messaging_error(exception):
    """Handle Firebase Messaging errors"""
    
    if isinstance(exception, messaging.UnregisteredError):
        # Token no longer valid - remove from database
        return "invalid_token"
    elif isinstance(exception, messaging.InvalidArgumentError):
        # Message format invalid
        return "invalid_message"
    elif isinstance(exception, messaging.ThirdPartyAuthError):
        # Authentication error with FCM
        return "auth_error"
    else:
        return "unknown_error"
```

---

## Best Practices

1. **Token Validity**: Regularly clean up invalid tokens from database
2. **Batch Sending**: Use multicast_message for sending to multiple users
3. **Error Recovery**: Retry failed sends with exponential backoff
4. **Rate Limiting**: Implement rate limiting to prevent abuse
5. **Opt-in**: Only send notifications to users who have opted in
6. **Testing**: Send test notifications before production deployment
7. **Monitoring**: Log all notification sends and failures
8. **Data Privacy**: Never log sensitive user data in notification payloads

---

## Testing

### Test with cURL

```bash
# Register device
curl -X POST http://localhost:5000/auth/register-device \
  -H "Content-Type: application/json" \
  -d '{
    "idToken": "your-id-token",
    "fcmToken": "fcm:APA91bHkT5...",
    "deviceId": "test-device-1"
  }'

# Update token
curl -X POST http://localhost:5000/auth/update-fcm-token \
  -H "Content-Type: application/json" \
  -d '{
    "idToken": "your-id-token",
    "fcmToken": "fcm:APA91bHkT5...new-token"
  }'

# Unregister device
curl -X POST http://localhost:5000/auth/unregister-device \
  -H "Content-Type: application/json" \
  -d '{
    "idToken": "your-id-token"
  }'
```

---

## References

- [Firebase Admin SDK Documentation](https://firebase.google.com/docs/reference/admin)
- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Firebase Authentication Verification](https://firebase.google.com/docs/auth/admin-sdk)
