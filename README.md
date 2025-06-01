# blood bank (BBMS)

A web-based application for managing blood donations, donors, patients, and blood inventory. Built with PHP, MySQL, and Bootstrap.

---

## Features

- **User Roles:** Admin, Donor, Patient
- **Authentication:** Secure registration and login for all roles
- **Blood Stock Management:** Admin can view and update blood inventory
- **Donor Management:** Register, login, donate blood, view donation history, update/delete profile
- **Patient Management:** Register, login, request blood, view request history, update/delete profile
- **Approval Workflow:** Admin approves/rejects donations and requests
- **History Tracking:** All donations and requests are logged
- **Responsive UI:** Built with Bootstrap for mobile and desktop

---

## Folder Structure

```
BBMS/
│
├── admin/      # Admin dashboard and management
├── donor/      # Donor dashboard and actions
├── patient/    # Patient dashboard and actions
├── includes/   # Shared database, session, and template files
├── images/     # Project images and icons
├── index.php   # Landing page
└── dbfinal.txt # Database schema
```

---

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/muba5hir1/BBMS.git
   ```

2. **Import the Database:**
   - Open `dbfinal.txt` and execute the SQL commands in your MySQL server (e.g., using phpMyAdmin).

3. **Configure XAMPP:**
   - Place the project folder in `c:/xampp/htdocs/`.
   - Ensure MySQL and Apache are running.

4. **Database Credentials:**
   - Default credentials are set in `includes/dbh.inc.php`:
     - Host: `localhost`
     - User: `root`
     - Password: (empty)
     - Database: `BBMS`

5. **Access the Application:**
   - Open your browser and go to:  
     `http://localhost/BBMS/index.php`

---

## Screenshots

---

## Technologies Used

- PHP (Backend)
- MySQL (Database)
- Bootstrap (Frontend)
- HTML, CSS, JavaScript

---

## Security

- Uses PDO for secure database access
- Session management with regeneration and timeout
- Input validation on all forms

---

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## License


---

## Authors

- Mubashir Ali ([GitHub](https://github.com/muba5hir1))
- Tayyab Mehmood ([GitHub](https://github.com/Tayyabpcomits))
